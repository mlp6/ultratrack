function []=createtrackres(C,D,PARAMS,PPARAMS,PHANTOM_FILE,RF_FILE,TRACKPARAMS,ZDISPFILE,DYN_FILE,TRACK_DIR);
% function []=createtrackres(C,D,PARAMS,PPARAMS,PHANTOM_FILE,RF_FILE,TRACKPARAMS,ZDISPFILE,DYN_FILE,TRACK_DIR);
% Create res_tracksim.mat that shares the same format as the res_sim.mat and
% res*.mat experimental files.
%
% Mark 03/22/08


% make this code backwards compatible for when these two constants were not
% passed along in the PARAMS structure
% SAMPLING FREQUENCY (Hz) OF THE D & C MATRICES
if(isfield(PARAMS,'field_sample_freq')),
    fs = PARAMS.field_sample_freq;
else,
    warning('The Field II sampling frequency cannot be found; assuming it was 100 MHz.');
    fs = 100e6;
end;

% SOUND SPEED (m/s)
if(isfield(PARAMS,'c')),
    c = PARAMS.c;
else,
    warning('The Field II sound speed cannot be found; assuming it was 1540 m/s');
    c = 1540;
end;

% CONVERT THE D MATRIX FROM FIELD SAMPLES TO DISPLACEMENT IN
% MICRONS, AND MAKE TIME THE THIRD DIMENSION
for t = 1:size(D,1),
    TrackedDisp(:,:,t) = D(t,:,:)*c*1e6/(2*fs);  % microns
end;

% setup the spatial axes
lat = (PARAMS.XMIN:PARAMS.XSTEP:PARAMS.XMAX)*1e3; % mm
if(length(lat) ~= size(D,3)),
    error('Mismatched lateral dimension');
end;

% the axial axis "should" always start at 0
axial = (0:(size(D,2)-1))*c/(2*fs)*1000;  % mm

arfidata = permute(D,[2,3,1]);
cc_coeff = permute(C,[2,3,1]);

% now we need to somehow define the time variable... and this is not easy
% internally w/i this body of code since only time step indices are used...
% grrrr.  we'll have to rely on the time variable that is saved from the pure
% FEM data as parsed by the PPARAMS.TIMESTEP variable defined in arfi_scans.m
if(exist('res_sim.mat','file')==2),
    resSim=load('res_sim.mat');
else,
    error('We have a problem; res_sim.mat does not exist in the CWD, so the time variable cannot be defined.');
end;

if(~isempty(PPARAMS.TIMESTEP)),
    t = resSim.t(PPARAMS.TIMESTEP); % s
else,
    t = resSim.t; % s
    if((length(t)-1) ~= size(arfidata,3)),
        error('Mismatched time dimension');
    end;
end;


% check to make sure that we aren't clobbering a result file that we make not
% want to clobber!
if(exist('res_tracksim.mat','file')==2),
    warning('res_tracksim.mat already exists; being backed up as res_tracksim.mat.old');
    system('mv res_tracksim.mat res_tracksim.mat.old');
end;

save([TRACK_DIR 'res_tracksim.mat'],'arfidata','lat','axial','t','cc_coeff');
