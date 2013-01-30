function cluster_scan(datafile,n)
load(datafile)

addpath(ULTRATRACK_PATH)
addpath([ULTRATRACK_PATH '/URI_FIELD/code']);
addpath([ULTRATRACK_PATH '/URI_FIELD/code/probes']);
addpath(FIELD_PATH);

field_init(-1)

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
        
		% Swapped TX offsets for RX offsets and rolled them into beamset
        % Pete 2012.11.2
        
        [rf,t0]=uf_scan(probe,beamset,dog);
		
        % Prepend zeros to make all start at zero
		rf=[zeros(round(t0*probe.field_sample_freq),beamset.no_beams,beamset.no_beamsy,beamset.no_parallel);rf];
		t0=0;

                % convert to single precision
                rf = single(rf);
                t0 = single(t0);

		% Save the result
        rffile = sprintf('%s%03d',OUTPUT_FILE,n);
		save(rffile,'rf','t0');

	end; % matches if isempty(tstep)

    %delete temporary file if you are the last one to finish.
    d = dir([OUTPUT_FILE '*.mat']);
    fprintf('%0.0f/%0.0f timesteps completed.',length(d),length(phantom_files));
    if length(d)==length(phantom_files)
        fprintf('Last file in. Deleting %s...\n',datafile);
        pause(0.1);
        if exist([datafile '.mat'],'file'); %Attempt to handle tiebreakers...
            delete([datafile '.mat'])
        end
    end
    
    field_end
