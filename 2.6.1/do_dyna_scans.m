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
% PARAMS.IMAGE_MODE             'linear' or 'phased'
% PARAMS.XMIN			Leftmost scan line
% PARAMS.XSTEP			Scanline spacing
% PARAMS.XMAX			Rightmost scan line
% PARAMS.TX_FOCUS		Transmit focus depth
% PARAMS.TX_FNUM		Transmit f number (lateral & elevation)
% PARAMS.TX_FREQ		Transmit frequency
% PARAMS.TX_NUM_CYCLES		Number of cycles in transmit toneburst
% PARAMS.RX_FOCUS		Depth of receive focus - use zero for dyn. foc
% PARAMS.RX_FNUM		Receive aperture f number (lateral & elevation)
% PARAMS.RX_GROW_APERTURE	1 means use aperture growth, 0 means don't
% PARAMS.TXOFFSET               Spatial offset for Tx beam (from Rx) for parallel rx
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
% Added PARAMS.TX_F_NUM_Y and PARAMS.RX_F_NUM_Y for elevation dimension
% F/#s *only* when defining the 2D arrays!!
% Mark Palmeri
% 2012-09-10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Added two new functions for the matrix definitions:
% def_matrix_enabled 
% def_active_min_max_ele_ids
%
% Commiting v2.5.0 with these additions for the matrix arrays
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% v2.6.0
% Incorporated PARAMS.IMAGE_MODE and mutli-D TX/RX FNUM and TX/RF FOCUS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% BEGIN PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PROBE_NAME = PARAMS.PROBE_NAME;
IMAGE_MODE = PARAMS.IMAGE_MODE; % 'linear' or 'phased'
XMIN=PARAMS.XMIN;		% Leftmost scan line
XSTEP=PARAMS.XSTEP;		% Scanline spacing
XMAX= PARAMS.XMAX;		% Rightmost scan line
YMIN=PARAMS.YMIN;		% Leftmost scan line
YSTEP=PARAMS.YSTEP;		% Scanline spacing
YMAX= PARAMS.YMAX;		% Rightmost scan line
TX_FOCUS = PARAMS.TX_FOCUS;	% Tramsmit focus depth
TX_FNUM=PARAMS.TX_F_NUM;	% Transmit f number
TX_FREQ=PARAMS.TX_FREQ;		% Transmit frequency
TX_NUM_CYCLES=PARAMS.TX_NUM_CYCLES;	% Number of cycles in transmit toneburst
RX_FOCUS=PARAMS.RX_FOCUS;	% Depth of receive focus - use zero for dyn. foc
RX_FNUM=PARAMS.RX_F_NUM;	% Receive aperture f number
RX_GROW_APERTURE=PARAMS.RX_GROW_APERTURE;	  % 1=grow, 0 = static 
TXOFFSET = PARAMS.TXOFFSET;     % Lateral & elevation offset of Tx beam from Rx beam (m)

% END PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Create probe structure for specified probe
probe=uf_txt_to_probe(PROBE_NAME);
%probe.field_sample_freq=100e6;
% this was hard-coded, but that was silly - now defined in arfi_scans.m
probe.field_sample_freq=PARAMS.field_sample_freq;
probe.c = PARAMS.c;
probe.txoffset = TXOFFSET;

% enabled matrix array elements (only for 2D matrix arrays!)
% 2D matrix of 0s (off) and 1s (on) that is no_ele_x x no_ele_y in dimension
if(probe.probe_type=='matrix'),
    [probe.tx_enabled]=def_matrix_enabled(probe.no_elements_x,TX_FNUM(1),probe.width+probe.kerf_x,probe.no_elements_y,TX_FNUM(2),probe.height+probe.kerf_y,TX_FOCUS)
    [probe.rx_enabled]=def_matrix_enabled(probe.no_elements_x,RX_FNUM(1),probe.width+probe.kerf_x,probe.no_elements_y,RX_FNUM(2),probe.height+probe.kerf_y,RX_FOCUS)
end;

% Make transmit and receive apertures as defined by probe
[tx,rx]=uf_make_xdc(probe);

% Create beamset based on params above
beamset.type='B';
beamset.originx=(XMIN:XSTEP:XMAX)';
beamset.originy=(YMIN:YSTEP:YMAX)';
if(length(beamset.originy)==0);
   beamset.originy=0;
end;
beamset.no_beams=length(beamset.originx);
beamset.no_beamsy=length(beamset.originy);
beamset.directionx=zeros(size(beamset.originx))';
beamset.directiony=zeros(size(beamset.originy))';
beamset.tx_focus_range=TX_FOCUS(3);
beamset.tx_f_num=TX_FNUM(1);
beamset.tx_excitation.f0=TX_FREQ;
beamset.tx_excitation.num_cycles=TX_NUM_CYCLES;
beamset.tx_excitation.phase=0;
beamset.tx_excitation.wavetype='Square';
beamset.prf=NaN;
beamset.tx_apod_type=1; % Hamming apodization, select 0 for rectangular

beamset.is_dyn_focus = (RX_FOCUS(3)==0);	% If RX_FOCUS is spec'd zero, use	
					        % dynamic focus
beamset.rx_focus_range=RX_FOCUS(3);	        % Receive focal point,zero=dynamic
beamset.rx_apod_type=1; % 1=Hamming, 0 = rectangular apodization
beamset.rx_f_num=RX_FNUM;
beamset.aperture_growth=RX_GROW_APERTURE;
beamset.apex=NaN;
beamset.steering_anglex=zeros(size(beamset.originx))';
beamset.steering_angley=zeros(size(beamset.originy))';

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
		rf=[zeros(t0*probe.field_sample_freq,beamset.no_beams, beamset.no_beamsy);rf];
		t0=0;

                % convert to single precision
                rf = single(rf);
                t0 = single(t0);

		% Save the result
		save(sprintf('%s%03d',OUTPUT_FILE,n),'rf','t0');

	end; % matches if isempty(tstep)
end; 

end

% def_matrix_enabled - new for 2.5.0
% MLP 2012-10-04
function [enabled]=def_matrix_enabled(num_ele_x,fnum_x,pitch_x,num_ele_y,fnum_y,pitch_y,focal_depth)
% this function returns the enabled matrix that contains 0's and 1's determining if elements are 
% off or on, respectively; this has to be done for the Tx and Rx arrays

    % create a zero matrix for the array (all off)
    enabled=zeros(num_ele_x,num_ele_y);

    % figure out the min and max indices in each dimension of the aperture
    [active_x_min,active_x_max]=def_active_min_max_ele_ids(num_ele_x,focal_depth(3),fnum_x,pitch_x);
    [active_y_min,active_y_max]=def_active_min_max_ele_ids(num_ele_y,focal_depth(3),fnum_y,pitch_y);

    % turn on the active elements
    enabled(active_x_min:active_x_max,active_y_min:active_y_max) = 1;

end

% def_active_min_max_ele_ids - new for 2.5.0
% MLP 2012-10-04
function [active_min,active_max]=def_active_min_max_ele_ids(num_ele,focal_depth,fnum,pitch)
    % calculate the number of active elements
    active_elements = (focal_depth / fnum) / pitch;
    
    % we want to center this active aperture in the matrix
    center_element_id = floor(num_ele/2);

    % computer the min and max element ids for the active aperture
    active_min = center_element_id - floor(active_elements/2);
    active_max = center_element_id + floor(active_elements/2);

    % check to make sure that the min and max ids don't exceed the number of physical elements
    if (active_min < 1),
        warning('Matrix Min Element < 1; being set to 1.  Check matrix definition.');
        active_min = 1;
    end;

    if(active_max > num_ele),
        warning('Matrix Max Element > NUM_ELE; being set to NUM_ELE.  Check matrix definition.');
        active_max = num_ele;
    end;

end
