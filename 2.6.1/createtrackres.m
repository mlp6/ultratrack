function []=createtrackres(C,D,PARAMS,PPARAMS,PHANTOM_FILE,RF_FILE,TRACKPARAMS,TRACK_DIR);
% function []=createtrackres(C,D,PARAMS,PPARAMS,PHANTOM_FILE,RF_FILE,TRACKPARAMS,TRACK_DIR);
% Create res_tracksim.mat that shares the same format as the res_sim.mat and
% res*.mat experimental files.
%
% Mark 03/22/08

% MODIFICATION HISTORY 
% 2009-07-25
% (1) changed cc_coeff -> cc_coef to be compatible with other conventions
% (2) added in a reference time step to cc_coef so that it has the same number of time steps as arfidata
% Mark Palmeri (mlp6)

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
    c = 1540; % m/s
end;

% convert time shifts to displacements (microns)
% the first time step is the reference one that isn't included in D, so
% it is manually added here to sync with the time (t) variable
TrackedDisp(1,:,:) = zeros(size(D,2),size(D,3));
for t = 1:size(D,1),
    TrackedDisp(t+1,:,:) = -D(t,:,:)*c*1e6/(2*fs);  % microns
end;

% setup the spatial axes
lat = (PARAMS.XMIN:PARAMS.XSTEP:PARAMS.XMAX)*1e3; % mm
if(length(lat) ~= size(D,3)),
    error('Mismatched lateral dimension');
end;

% the axial axis "should" always start at 0
axial = (0:(size(D,2)-1))*c/(2*fs)*1000;  % mm

arfidata = permute(TrackedDisp,[2,3,1]);
cc_coef = permute(C,[2,3,1]);

% make sure that cc_coef and arfidata have the same number of time steps
% (sometimes the reference time step is missing)
if(size(cc_coef,3) == (size(arfidata,3)-1)),
    temp = cc_coef;
    clear cc_coef;
    cc_coef(:,:,1) = ones(size(temp,1),size(temp,2));
    cc_coef(:,:,2:(size(temp,3)+1)) = temp;
end;

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
    if(length(t) ~= size(arfidata,3)),
        error('Mismatched time dimension');
    end;
end;


% check to make sure that we aren't clobbering a result file that we make not
% want to clobber!
if(exist('res_tracksim.mat','file')==2),
    warning('res_tracksim.mat already exists; being backed up as res_tracksim.mat.old');
    system('mv res_tracksim.mat res_tracksim.mat.old');
end;

% convert variables to singles to save space
for i={'arfidata','lat','axial','t','cc_coef'},
    eval(sprintf('%s = single(%s);',char(i),char(i)));
end;

save([TRACK_DIR 'res_tracksim.mat'],'arfidata','lat','axial','t','cc_coef');
disp('res_tracksim.mat created');
