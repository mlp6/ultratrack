function [rf,t0]=uf_scan(probe,beamset,tx,rx,phantom,varargin);

if (nargin>5),
	stat_win=(varargin{1}==2);
	stat_txt=(varargin{1}==1);
	else
	stat_txt=1;
	stat_win=0;
	end;
	

% Select each vector in the beamset and calculate echo signal
%
rfdata=zeros(1,beamset.no_beams);
for n_vector=1:beamset.no_beams,
	if stat_txt,
		disp(sprintf('Processing Vector %d of %d',n_vector, beamset.no_beams));
		end;
	
	uf_set_beam(tx,rx,probe,beamset,1,n_vector);
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




