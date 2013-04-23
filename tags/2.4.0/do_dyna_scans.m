function do_dyna_scans(PHANTOM_FILE,OUTPUT_FILE,PARAMS);

%
% do_dyna_scans(PHANTOM_FILE,OUTPUT_FILE,PARAMS);
%
% Function for doing ARFI scans with the URI/Field toolkit 
%
% 11/11/04 Stephen McAleavey, U. Rochester BME
%
%
% PHANTOM_FILE	Filename for phantom files - will look for 
% 		everything w/ %03d number appended, e.g.
% 		phantom001, phantom010, etc
%
% OUTPUT_FILE	Filename containing simulated RF.  Output 
%		will have same number appended as input
%
% PARAMS	structure with the following entries:
%
% PARAMS.PROBE_NAME		Name of text file containing probe description
% PARAMS.XMIN			Leftmost scan line
% PARAMS.XSTEP			Scanline spacing
% PARAMS.XMAX			Rightmost scan line
% PARAMS.TX_FOCUS		Transmit focus depth
% PARAMS.TX_F_NUM		Transmit f number
% PARAMS.TX_FREQ		Transmit frequency
% PARAMS.TX_NUM_CYCLES		Number of cycles in transmit toneburst
% PARAMS.RX_FOCUS		Depth of receive focus - use zero for dyn. foc
% PARAMS.RX_F_NUM		Receive aperture f number
% PARAMS.RX_GROW_APERTURE	1 means use aperture growth, 0 means don't
%
% The uf_scan() call has been modified to allow for parallel rx
% simulations, by passing PARAMS.RXOFFSET to uf_scan() that
% is then passed to uf_set_beam() to laterally offset the Rx
% beam from the Tx beam.  This is also passed to uf_make_xdc().
% Mark 06/16/05
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Changed RXOFFSET -> TXOFFSET.
% Mark 06/17/05
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% converted rf and t0 to single precision variables
% Mark Palmeri (mark.palmeri@duke.edu)
% 2009-09-26
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% BEGIN PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PROBE_NAME = PARAMS.PROBE_NAME;
XMIN=PARAMS.XMIN;		% Leftmost scan line
XSTEP=PARAMS.XSTEP;		% Scanline spacing
XMAX= PARAMS.XMAX;		% Rightmost scan line
TX_FOCUS = PARAMS.TX_FOCUS;	% Tramsmit focus depth
TX_F_NUM=PARAMS.TX_F_NUM;	% Transmit f number
TX_FREQ=PARAMS.TX_FREQ;		% Transmit frequency
TX_NUM_CYCLES=PARAMS.TX_NUM_CYCLES;	% Number of cycles in transmit toneburst
RX_FOCUS=PARAMS.RX_FOCUS;	% Depth of receive focus - use zero for dyn. foc
RX_F_NUM=PARAMS.RX_F_NUM;	% Receive aperture f number
RX_GROW_APERTURE=PARAMS.RX_GROW_APERTURE;	  % 1=grow, 0 = static 
TXOFFSET = PARAMS.TXOFFSET; % Lateral offset of Rx beam from Tx beam (m)

% END PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Create probe structure for specified probe
probe=uf_txt_to_probe(PROBE_NAME);
%probe.field_sample_freq=100e6;
% this was hard-coded, but that was silly - now defined in arfi_scans.m
probe.field_sample_freq=PARAMS.field_sample_freq;
probe.c = PARAMS.c;
probe.txoffset = TXOFFSET;

% Make transmit and receive apertures as defined by probe
[tx,rx]=uf_make_xdc(probe);

% Create beamset based on params above
beamset.type='B';
beamset.origin=(XMIN:XSTEP:XMAX)';
beamset.no_beams=length(beamset.origin);
beamset.direction=zeros(size(beamset.origin))';
beamset.tx_focus_range=TX_FOCUS;
beamset.tx_f_num=TX_F_NUM;
beamset.tx_excitation.f0=TX_FREQ;
beamset.tx_excitation.num_cycles=TX_NUM_CYCLES;
beamset.tx_excitation.phase=0;
beamset.tx_excitation.wavetype='Square';
beamset.prf=NaN;
beamset.tx_apod_type=1; % Hamming apodization, select 0 for rectangular

beamset.is_dyn_focus = (RX_FOCUS==0); 	% If RX_FOCUS is spec'd zero, use	
					% dynamic focus
beamset.rx_focus_range=RX_FOCUS;	% Receive focal point,zero=dynamic
beamset.rx_apod_type=1; % 1=Hamming, 0 = rectangular apodization
beamset.rx_f_num=RX_F_NUM;
beamset.aperture_growth=RX_GROW_APERTURE;
beamset.apex=NaN;
beamset.steering_angle=zeros(size(beamset.origin))';

% Extract the pathname, if any, from PHANTOM_FILE
slashes=regexp(PHANTOM_FILE,'/'); % slashes has indicies of occurances of '/'
phantom_path=PHANTOM_FILE(1:max(slashes));

% Extract phantom name
if isempty(slashes)
	phantom_name=PHANTOM_FILE;
else
	phantom_name=PHANTOM_FILE((max(slashes+1):end));
end;

%Generate list of all files matching PHANTOM_FILE prefix
phantom_files=dir([PHANTOM_FILE '*']);

% Abort with message if there are no files found
if isempty(phantom_files),
	error('No phantom files found matching name given');
	end;


for n=1:length(phantom_files), % For each file,
	tstep=sscanf(phantom_files(n).name,[phantom_name '%03d']);
	if isempty(tstep),
		% Warn that we're skipping a file
		warning(['Skipping ' phantom_files(n).name]);
	else
		% Load the phantom
		s=[phantom_path phantom_files(n).name];
		bungle=load(s); % an hour of pain here.  phantom was being	
				% clobberd by function phantom.
		disp(['Processing ' s]); 
				
		dog=bungle.phantom;
% Scan the phantom
		% Changed to allow for the Rx beam to be offset from the Tx
		% beam
		% Mark 06/15/05	
		%[rf,t0]=uf_scan(probe,beamset,tx,rx,dog);

		[rf,t0]=uf_scan(probe,beamset,tx,rx,dog,TXOFFSET);

		% Prepend zeros to make all start at zero
		rf=[zeros(t0*probe.field_sample_freq,beamset.no_beams);rf];
		t0=0;

                % convert to single precision
                rf = single(rf);
                t0 = single(t0);

		% Save the result
		save(sprintf('%s%03d',OUTPUT_FILE,n),'rf','t0');

	end; % matches if isempty(tstep)
end; % matches for n loop


%end; % matches try above
%field_end; % shut down field


