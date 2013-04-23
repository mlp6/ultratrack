function [rf,t0]=uf_scan(probe,beamset,tx,rx,phantom,txoffset,varargin);
% Added txoffset as an input to allow for the Tx beam to be
% offset (m) from the Rx beam; this is passed to uf_set_beam()
% Mark 06/17/05
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make sure that phantom.[position amplitude] are double precision
% Mark Palmeri (mark.palmeri@duke.edu)
% 2009-09-26
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Change to accomodate an additional input variable
% Mark 06/16/06
%if (nargin>5),
if (nargin>6),
	stat_win=(varargin{1}==2);
	stat_txt=(varargin{1}==1);
	else
	stat_txt=1;
	stat_win=0;
	end;
	
% make sure that phantom.position and phantom.amplitude are double precision variables
phantom.position = double(phantom.position);
phantom.amplitude = double(phantom.amplitude);

% Select each vector in the beamset and calculate echo signal
%
rfdata=zeros(1,beamset.no_beams);
for n_vector=1:beamset.no_beams,
	if stat_txt,
		disp(sprintf('Processing Vector %d of %d',n_vector, beamset.no_beams));
		end;
	
	% Modified the code to pass txoffset to uf_set_beam()
	% Mark 06/16/05
	%uf_set_beam(tx,rx,probe,beamset,1,n_vector);
	uf_set_beam(tx,rx,probe,beamset,1,n_vector,txoffset);

	[v,t1]=calc_scat(tx,rx,phantom.position,phantom.amplitude);
	if (size(rfdata,1)<length(v)),
		disp('Memory');
		rfdata=[rfdata ;zeros(length(v)-size(rfdata,1),beamset.no_beams) ];
		end;
	rfdata(1:length(v),n_vector)=v;
	start_times(n_vector)=t1;
end;
% Create rf with equal t0s from rfdata
%
[rf,t0]=uf_time_eq(rfdata,start_times,probe.field_sample_freq);
t0=t0-length(probe.impulse_response)*2/probe.field_sample_freq;
