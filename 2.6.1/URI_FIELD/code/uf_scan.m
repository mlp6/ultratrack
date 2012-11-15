function [rf,t0]=uf_scan(probe,beamset,tx,rx,phantom,varargin);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make sure that phantom.[position amplitude] are double precision
% Mark Palmeri (mark.palmeri@duke.edu)
% 2009-09-26
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (nargin>5),
	stat_win=(varargin{1}==2);
	stat_txt=(varargin{1}==1);
	else
	stat_txt=1;
	stat_win=0;
	end;
	
% make sure that phantom.position and phantom.amplitude are double precision variables
%run('/getlab/pjh7/field_sims/LoadPhantom.m')
phantom.position = double(phantom.position);
phantom.amplitude = double(phantom.amplitude);
            
% Select each vector in the beamset and calculate echo signal
%


rfdata=zeros(1,beamset.no_beams,beamset.no_beamsy,beamset.no_parallel);
tic
for n_vector=1:beamset.no_beams;
    if stat_txt;disp(sprintf('Processing Vector Lat %d of %d',n_vector, beamset.no_beams));end
    for m_vector = 1:beamset.no_beamsy;
        if stat_txt && beamset.no_beamsy>1;disp(sprintf('Processing Vector Elev %d of %d',m_vector, beamset.no_beamsy));end
            for p_vector = 1:beamset.no_parallel;
            if stat_txt && beamset.no_parallel>1;disp(sprintf('Processing Parallel RX %d of %d',p_vector, beamset.no_parallel));end
            %	uf_set_beam(tx,rx,probe,beamset,1,n_vector);
            toffset = uf_set_beam(tx,rx,probe,beamset,1,n_vector,m_vector,p_vector);
            % modified to restrict the number of scatterers passed off to scan to
            % the largest -6 dB DOF width to reduce the number of calculations that
            % need to be performed (i.e., don't evaluate a lot of zeros)
            search_radius = 10*probe.c*max(beamset.tx_f_num(1),beamset.rx_f_num(1))/beamset.tx_excitation.f0; % m
            
            
            %2012.11.14 Added new dynamic scatter reduction that uses beam sensitivity profile 
            minDB = -20;
            gridspacing = [1e-3 2e-3 2e-3];
            
           toc1 = toc;
           fprintf('Reducing Scatter Field to %0.0f dB limit...',minDB)
           [red_phantom]=reduce_scats_3(phantom,tx,rx,minDB,gridspacing);
           fprintf('done (%1.2fs, %0.1f%% reduction)\n',toc-toc1,100*(1-length(red_phantom.amplitude)/length(phantom.amplitude)));
            
            [v,t1]=calc_scat(tx,rx,red_phantom.position,red_phantom.amplitude);
            
            t1 = t1-toffset;
            if (size(rfdata,1)<length(v)),
                disp('Memory');
                rfdata=[rfdata ;zeros(length(v)-size(rfdata,1),beamset.no_beams,beamset.no_beamsy,beamset.no_parallel) ];
            end;
            rfdata(1:length(v),n_vector,m_vector,p_vector)=v;
            start_times(n_vector,m_vector,p_vector)=t1;
        end;
    end;
end

xdc_free(tx);
xdc_free(rx);

whos rfdata
% Create rf with equal t0s from rfdata
[rf,t0]=uf_time_eq(rfdata,start_times,probe.field_sample_freq);
[puls tpuls] = makeImpulseResponse(probe.impulse_response.bw*1e-2,probe.impulse_response.f0,probe.field_sample_freq);
t0=t0-(max(tpuls)-min(tpuls));%length(puls)/probe.field_sample_freq;

toc


     