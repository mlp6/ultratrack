function []=sphere_scans(phantom_seed)
% function []=sphere_scans(phantom_seed)
% INPUTS:	
%   phantom_seed (int) - scatterer position RNG seed
% OUTPUTS:	
%   Nothing returned, but lots of files and directories created in PATH
  
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MODIFICATION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Original script
% Mark 04/11/08
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Removed PATH as a function input for SGE array job compatibility.
%
% Mark Palmeri (mark.palmeri@duke.edu)
% 2009-01-04
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2009-09-20 (mlp6)
%
% (1) Compute absolute number of scatterers needed from a defined scatterer
% density to achieve fully developed speckle.
%
% (2) Changed zdisp.mat -> zdisp.dat.
%
% (3) Corrected path definitions.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TRACK_ONLY = 1; % set to 0 for a full sim

% PATH TO URI/FIELD/TRACKING FILES:
ULTRATRACK_PATH = '/krnlab/mlp6/ultratrack/2.5.0';
addpath(ULTRATRACK_PATH)
addpath([ULTRATRACK_PATH '/URI_FIELD/code']);
addpath([ULTRATRACK_PATH '/URI_FIELD/code/probes']);

% PARAMETERS FOR PHANTOM CREATION
% file containing comma-delimited node data
DYN_FILE='/krnlab/CIRSphantoms/fem/mesh/sphere2cm/nodes.dyn'
DEST_DIR = pwd; DEST_DIR = [DEST_DIR '/'];
ZDISPFILE = [DEST_DIR 'disp.dat'];

% setup some Field II parameters
PARAMS.field_sample_freq = 100e6; % Hz
PARAMS.c = 1540; % sound speed (m/s)

% setup phantom parameters (PPARAMS)
% leave any empty to use mesh limit
PPARAMS.xmin=[-0.15];PPARAMS.xmax=[0];	% out-of-plane,cm
PPARAMS.ymin=[-0.4];PPARAMS.ymax=[3.4];	% lateral, cm \
PPARAMS.zmin=[-8.0];PPARAMS.zmax=[-0.1];% axial, cm   / X,Y SWAPPED vs FIELD!	
PPARAMS.TIMESTEP=[];	% Timesteps to simulate.  Leave empty to
                        % simulate all timesteps

% compute number of scatteres to use
SCATTERER_DENSITY = 27610; % scatterers/cm^3
TRACKING_VOLUME = (PPARAMS.xmax-PPARAMS.xmin)*(PPARAMS.ymax-PPARAMS.ymin)*(PPARAMS.zmax-PPARAMS.zmin); % cm^3
PPARAMS.N = round(SCATTERER_DENSITY * TRACKING_VOLUME); % number of scatterers to randomly distribute over the tracking volume

PPARAMS.seed=phantom_seed;         % RNG seed

PPARAMS.delta=[0 0 0]   % rigid pre-zdisp-displacement scatterer translation,
                        % in the dyna coordinate/unit system to simulate s/w
                        % sequences

% PARAMETERS FOR SCANNING (PARAMS)
PARAMS.PROBE_NAME='ch4-1.txt';
PARAMS.XMIN=0;              % Leftmost scan line (m)
PARAMS.XSTEP=0.2e-3;        % Scanline spacing (m)
PARAMS.XMAX=30.0e-3;         % Rightmost scan line (m)
PARAMS.TX_FOCUS=10.0e-2;    % Tramsmit focus depth (m)
PARAMS.TX_F_NUM=3;          % Transmit f number 
PARAMS.TX_FREQ=3.08e6;      % Transmit frequency (Hz)
PARAMS.TX_NUM_CYCLES=2;     % Number of cycles in transmit toneburst
PARAMS.RX_FOCUS=0;          % Depth of receive focus - use 0 for dyn. foc
PARAMS.RX_F_NUM=0.5;        % Receive aperture f number
PARAMS.RX_GROW_APERTURE=1;

% lateral offset of the Tx beam from the Rx beam (m) to simulated prll rx
% tracking
PARAMS.TXOFFSET = 0;				

% TRACKING ALGORITHM TO USE
% 'samtrack','samauto','ncorr','loupas'
TRACKPARAMS.TRACK_ALG='xcorr_adaptive_cc';
TRACKPARAMS.WAVELENGTHS = 1.5; % size of tracking kernel in wavelengths
%TRACKPARAMS.WAVELENGTHS = 0.28; % size of tracking kernel in wavelengths (TO MATCH XUAN'S ANALYSIS)
TRACKPARAMS.KERNEL_SAMPLES = round((PARAMS.field_sample_freq/PARAMS.TX_FREQ)*TRACKPARAMS.WAVELENGTHS);


% MAKE PHANTOMS
P=rmfield(PPARAMS,'TIMESTEP');
PHANTOM_DIR=[make_file_name([DEST_DIR 'phantom'],P) '/'];
unix(sprintf('mkdir %s',PHANTOM_DIR)); % mkdir(PHANTOM_DIR); %matlab 7
PHANTOM_FILE=[PHANTOM_DIR 'phantom'];
if(TRACK_ONLY ~= 1),
    mkphantomfromdyna3(DYN_FILE,ZDISPFILE,PHANTOM_FILE,PPARAMS);
end;

% SCAN PHANTOMS
RF_DIR=[make_file_name([PHANTOM_DIR 'rf'],PARAMS) '/'];
unix(sprintf('mkdir %s',RF_DIR)); % mkdir(RF_DIR); %matlab 7
RF_FILE=[RF_DIR 'rf'];
if(TRACK_ONLY ~= 1),
    field_init(-1);
    do_dyna_scans(PHANTOM_FILE,RF_FILE,PARAMS);
    field_end;
end;

% TRACK RF
TRACK_DIR=[make_file_name([RF_DIR 'track'],TRACKPARAMS) '/'];
unix(sprintf('mkdir %s',TRACK_DIR)); % mkdir(TRACK_DIR); %matlab 7

% load all RF into a big matrix
n=1;
while ~isempty(dir(sprintf('%s%03d.mat',RF_FILE,n)))
    load(sprintf('%s%03d.mat',RF_FILE,n));
    % some rf*.mat files are off by one axial index; allowing for some dynamic
    % assignment of bigRF matrix
    % bigRF(:,:,n)=rf;
    bigRF(1:size(rf,1),:,n)=rf;
    n=n+1;
end;
                                                                                
% track the displacements
%[D,C]=estimate_disp(bigRF,TRACKPARAMS.TRACK_ALG,TRACKPARAMS.KERNEL_SAMPLES);
[D,C]=estimate_disp(bigRF,TRACKPARAMS);
                                                                                
% save res_tracksim.mat (same format as experimental res*.mat files)
track_save_path = pwd;
createtrackres(C,D,PARAMS,PPARAMS,PHANTOM_FILE,RF_FILE,TRACKPARAMS,TRACK_DIR);
