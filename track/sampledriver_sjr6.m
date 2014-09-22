function ultratrackDriver_sjr6(phantom_seed)
% function ultratrackDriver_sjr6(phantom_seed)
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
% v2.5.0
% * added PARAMS.TX_FNUM_Y and PARAMS.RX_FNUM_Y for defining the 'enabled'
%   matrix for xdc_2d_array probes; these parameters only have to be defined
%   for the matrix probe type (currently, only the 4z1c)!!
% Mark Palmeri (mlp6@duke.edu)
% 2012-09-04
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% v2.6.0
% * removed TX_FNUM_Y and RX_FNUM_Y, and instead turned TX_FNUM and RX_FNUM
%   into 2 element arrays
% * added PARAMS.IMAGE_MODE (linear or phased) to help figure out how to do
%   parallel rx later on, and general tracking in a phased configuration
% Mark Palmeri (mlp6@duke.edu)
% 2012-10-09
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% v2.6.1
% Increased ways to specify phased array behavior and improved parallel
% receive specification
% Peter Hollender
% 2012-11-2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% v.2.6.1
% Added cluster and parfor processing to handle multiple timestamps at once
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% v.2.6.1
% Updating to use normalized cross-correlation for displacement estimation
% Stephen Rosenzweig (sjr6@duke.edu)
% 2014-01-02
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ------------ PATH TO URI/FIELD/TRACKING FILES ---------------
PARAMS.ULTRATRACK_PATH = '/luscinia/sjr6/ultratrack/tags/2.6.1/';
PARAMS.FIELD_PATH = '/luscinia/sjr6/Field_II/';
PARAMS.SCRATCH_PATH = fullfile(fileparts(mfilename('fullpath')), 'sgetmp'); %'/oceanus/sjr6/scratch/simData/sphere_0.80cm/E57.60kPa';

if ~exist(PARAMS.SCRATCH_PATH, 'dir'),mkdir(PARAMS.SCRATCH_PATH);end
addpath(PARAMS.ULTRATRACK_PATH)
addpath([PARAMS.ULTRATRACK_PATH '/URI_FIELD/code']);
addpath([PARAMS.ULTRATRACK_PATH '/URI_FIELD/code/probes']);
addpath(PARAMS.FIELD_PATH);

%% ------------------PHANTOM PARAMETERS----------------------------
% file containing comma-delimited node data
DYN_FILE='/luscinia/sjr6/sc2000/fem/12L4/lesionSims/mesh/nodes.dyn';
DEST_DIR = fileparts(mfilename('fullpath'));
DEST_DIR = [DEST_DIR '/'];
ZDISPFILE = [DEST_DIR 'disp.dat'];

% setup phantom parameters (PPARAMS)
% leave any empty to use mesh limit
PPARAMS.xmin=[-0.5];PPARAMS.xmax=[0];	% out-of-plane,cm
PPARAMS.ymin=[0];PPARAMS.ymax=[1.8];	% lateral, cm \
PPARAMS.zmin=[-4.1];PPARAMS.zmax=[-0.1];% axial, cm   / X,Y SWAPPED vs FIELD!
PPARAMS.TIMESTEP=[];	% Timesteps to simulate.  Leave empty to
% simulate all timesteps

% compute number of scatteres to use
TRACKING_VOLUME = (PPARAMS.xmax-PPARAMS.xmin)*(PPARAMS.ymax-PPARAMS.ymin)*(PPARAMS.zmax-PPARAMS.zmin); % cm^3
% scatterers/cm^3  % <- CHANGE THIS TO SOMETHING REASONABLE FOR YOUR SIMULATION
SCATTERER_DENSITY = 10*1e3 ./ ((1.54/5 * 1) * (1.54/5 * 5) * (1.54/5 * 2)); % 20 / ((lateral)*(elevation)*(axial))
PPARAMS.N = round(SCATTERER_DENSITY * TRACKING_VOLUME); % number of scatterers to randomly distribute over the tracking volume
PPARAMS.seed=phantom_seed;         % RNG seed

%Optional point-scatterer locations
USE_POINT_SCATTERERS = 0;
if USE_POINT_SCATTERERS
PPARAMS.pointscatterers.x = 1e-3*[-30:4:30]; % X locations of point scatterers
PPARAMS.pointscatterers.z = 1e-3*[2:4:45]; % Y locations of point scatterers
PPARAMS.pointscatterers.y = 1e-3*[0]; % Z locations of point scatterers
PPARAMS.pointscatterers.a = 20; % Point scatterer amplitude
end

PPARAMS.delta=[0 0 0];   % rigid pre-zdisp-displacement scatterer translation,
% in the dyna coordinate/unit system to simulate s/w
% sequences - (2012.11.15 This may be outdated. Peter)

%%  --------------IMAGING PARAMETERS---------------------------------
PARAMS.PROBE ='12L4';
PARAMS.COMPUTATIONMETHOD = 'none'; % 'cluster','parfor', or 'none'
% setup some Field II parameters
PARAMS.field_sample_freq = 200e6; % Hz
PARAMS.c = 1540; % sound speed (m/s)

% TRANSMIT BEAM LOCATIONS
PARAMS.XMIN=    0;	   % Leftmost scan line (m)
PARAMS.XSTEP =  0.2e-3;      % Azimuth step size (m);
PARAMS.XMAX=    18e-3;	   % Rightmost scan line (m)
PARAMS.THMIN =  0;      % Leftmost azimuth angle (deg)
PARAMS.THSTEP = 0;    % Azimuth angle step(deg)
PARAMS.THMAX =  0;      % Rightmost azimuth angle (deg)
PARAMS.PHIMIN= 0;      % Frontmost elevation angle (deg)
PARAMS.PHISTEP = 0;    % Elevation angle step(deg)
PARAMS.PHIMAX= 0;      % Backmost elevation angle (deg)
PARAMS.YMIN=   0;		% Frontmost scan line (m)
PARAMS.YSTEP = 0;      % Elevation step size (m);
PARAMS.YMAX=   0;	    % Backmost scan line (m)
PARAMS.APEX = 0; %Apex of scan geometry. Set to 0 for linear scanning.
PARAMS.TX_FOCUS= 20e-3;    % Tramsmit focus depth (m)
PARAMS.TX_F_NUM=[2 1];      % Transmit f number (the "y" number only used for 2D matrix arrays)
PARAMS.TX_FREQ=7.12e6;      % Transmit frequency (Hz)
PARAMS.TX_NUM_CYCLES=1;     % Number of cycles in transmit toneburst
PARAMS.RX_FOCUS= 0;          % Depth of receive focus - use 0 for dyn. foc
PARAMS.RX_F_NUM=[0.5 0.5];  % Receive aperture f number (the "y" number only used for 2D matrix arrays)
PARAMS.RX_GROW_APERTURE=1;
PARAMS.MINDB = -20; %minimum contribution for including a scatter in sensitivity-based reduction
PARAMS.GRIDSPACING = [1e-3 2e-3 2e-3]; %Spacing of grid for sensitivity-based scatterer reduction (m)
% lateral offset of the Tx beam from the Rx beam (m) to simulated prll rx
% tracking (now a 2 element array, v2.6.0) (m)
%%% 2012.11.2 pjh7 adding native parallel receive functionality at lower
%%% level and swapped tx offsets for rx offsets
PARAMS.NO_PARALLEL = [1 1]; %[no_X no_Y]
PARAMS.PARALLEL_SPACING = [1 1]; % Spread || RX Beams Multiplier [X Y]

%% ---------- AUTOMATICALLY CALCULATED PARAMETERS -------------------
% You shouldn't need to change these unless you are using one of the
% override functions to specify non-uniform TX or || RX beam spacings

% ---------------- TRANSMIT OVERRIDE ---------------------------
% Override only if necessary. If you specify your own origins and angles,
% you can set the origins and angles as such:
%   ORIGIN  ANGLE
%   [1x1]   [1x1]   - single TX Beam
%   [1xN]   [1xN]   - specifiy origin and angle for each beam
%   [1xN]   [1x1]   - specify each origin, use same angle
%   [1x1]   [1xN]   - specify each angle, use same origin

TX_BEAM_OVERRIDE = 0;

if TX_BEAM_OVERRIDE
    PARAMS.BEAM_ORIGIN_X = 0;
    PARAMS.BEAM_ORIGIN_Y = 0;
    PARAMS.BEAM_ANGLE_X = 0;
    PARAMS.BEAM_ANGLE_Y = 0;
else
    
    PARAMS.BEAM_ORIGIN_X = PARAMS.XMIN:PARAMS.XSTEP:PARAMS.XMAX;
    PARAMS.BEAM_ORIGIN_Y = PARAMS.YMIN:PARAMS.YSTEP:PARAMS.YMAX;
    PARAMS.BEAM_ANGLE_X = PARAMS.THMIN:PARAMS.THSTEP:PARAMS.THMAX;
    PARAMS.BEAM_ANGLE_Y = PARAMS.PHIMIN:PARAMS.PHISTEP:PARAMS.PHIMAX;
    
    if PARAMS.XSTEP == 0;
        PARAMS.BEAM_ORIGIN_X = (PARAMS.XMIN + PARAMS.XMAX)/2;
    end
    if PARAMS.YSTEP == 0;
        PARAMS.BEAM_ORIGIN_Y = (PARAMS.YMIN + PARAMS.YMAX)/2;
    end
    if PARAMS.THSTEP == 0;
        PARAMS.BEAM_ANGLE_X = (PARAMS.THMIN + PARAMS.THMAX)/2;
    end
    if PARAMS.PHISTEP == 0;
        PARAMS.BEAM_ANGLE_Y = (PARAMS.PHIMIN + PARAMS.PHIMAX)/2;
    end
end

PARAMS.BEAM_ANGLE_X = deg2rad(PARAMS.BEAM_ANGLE_X);
PARAMS.BEAM_ANGLE_Y = deg2rad(PARAMS.BEAM_ANGLE_Y);


if length(PARAMS.BEAM_ANGLE_X) > 1 && length(PARAMS.BEAM_ORIGIN_X) > 1 && length(PARAMS.BEAM_ORIGIN_X)~=length(PARAMS.BEAM_ANGLE_X);
    error('BEAM_ORIGIN_X and BEAM_ANGLE_X cannot both be vectors and have different lengths.')
end
if length(PARAMS.BEAM_ANGLE_Y) > 1 && length(PARAMS.BEAM_ORIGIN_Y) > 1 && length(PARAMS.BEAM_ORIGIN_Y)~=length(PARAMS.BEAM_ANGLE_Y);
    error('BEAM_ORIGIN_Y and BEAM_ANGLE_Y cannot both be vectors and have different lengths.')
end

PARAMS.NO_BEAMS_X = max(length(PARAMS.BEAM_ORIGIN_X),length(PARAMS.BEAM_ANGLE_X));
PARAMS.NO_BEAMS_Y = max(length(PARAMS.BEAM_ORIGIN_Y),length(PARAMS.BEAM_ANGLE_Y));


%  ----------------- PARALLEL RX OVERRIDE ---------------------------
% Override if necessary. Default spaces || RX evenly between TX beams. If
% only a single TX beam is used, the step size dictates the spread of the
% || RX beams (Peter, 2012.11.15)

%FULL_PARLLEL_OVERRIDE lets you specify the parallel receive matrix. Each
%row corresponds to a parallel beam. the columns are x-offset (m),
%y-offset(m), x-angle offset (deg) y-angle offset(deg), respectively.
PARALLEL_OVERRIDE = 0;

if PARALLEL_OVERRIDE
    PARAMS.RXOFFSET = [0 0 0 0];
    
    PARAMS.RXOFFSET(:,3:4) = deg2rad(PARAMS.RXOFFSET(:,3:4));
else
    
    PARALLEL_TH_MIN  = -0.5*PARAMS.THSTEP*PARAMS.PARALLEL_SPACING(1)* (PARAMS.NO_PARALLEL(1)-1)/(PARAMS.NO_PARALLEL(1));
    PARALLEL_TH_MAX  =  0.5*PARAMS.THSTEP*PARAMS.PARALLEL_SPACING(1)* (PARAMS.NO_PARALLEL(1)-1)/(PARAMS.NO_PARALLEL(1));
    PARALLEL_PHI_MIN = -0.5*PARAMS.PHISTEP*PARAMS.PARALLEL_SPACING(2)*(PARAMS.NO_PARALLEL(2)-1)/(PARAMS.NO_PARALLEL(2));
    PARALLEL_PHI_MAX =  0.5*PARAMS.PHISTEP*PARAMS.PARALLEL_SPACING(2)*(PARAMS.NO_PARALLEL(2)-1)/(PARAMS.NO_PARALLEL(2));
    PARALLEL_X_MIN   = -0.5*PARAMS.XSTEP*PARAMS.PARALLEL_SPACING(1)*  (PARAMS.NO_PARALLEL(1)-1)/(PARAMS.NO_PARALLEL(1));
    PARALLEL_X_MAX   =  0.5*PARAMS.XSTEP*PARAMS.PARALLEL_SPACING(1)*  (PARAMS.NO_PARALLEL(1)-1)/(PARAMS.NO_PARALLEL(1));
    PARALLEL_Y_MIN   = -0.5*PARAMS.YSTEP*PARAMS.PARALLEL_SPACING(2)*  (PARAMS.NO_PARALLEL(2)-1)/(PARAMS.NO_PARALLEL(2));
    PARALLEL_Y_MAX   =  0.5*PARAMS.YSTEP*PARAMS.PARALLEL_SPACING(2)*  (PARAMS.NO_PARALLEL(2)-1)/(PARAMS.NO_PARALLEL(2));
    
    PARALLEL_TH_OFFSET0 = deg2rad(linspace(PARALLEL_TH_MIN,PARALLEL_TH_MAX,PARAMS.NO_PARALLEL(1)));    %RADIANS!
    PARALLEL_PHI_OFFSET0 = deg2rad(linspace(PARALLEL_PHI_MIN,PARALLEL_PHI_MAX,PARAMS.NO_PARALLEL(2))); %RADIANS!
    PARALLEL_X_OFFSET0 = linspace(PARALLEL_X_MIN,PARALLEL_X_MAX,PARAMS.NO_PARALLEL(1));
    PARALLEL_Y_OFFSET0 = linspace(PARALLEL_Y_MIN,PARALLEL_Y_MAX,PARAMS.NO_PARALLEL(2));
    
    [PARALLEL_TH_OFFSET PARALLEL_PHI_OFFSET] = meshgrid(PARALLEL_TH_OFFSET0,PARALLEL_PHI_OFFSET0);
    [PARALLEL_X_OFFSET PARALLEL_Y_OFFSET] = meshgrid(PARALLEL_X_OFFSET0,PARALLEL_Y_OFFSET0);
    
    PARAMS.RXOFFSET =  [PARALLEL_X_OFFSET(:) PARALLEL_Y_OFFSET(:) PARALLEL_TH_OFFSET(:) PARALLEL_PHI_OFFSET(:)];
end
%% -------------- DISPLACEMENT TRACKING PARAMETERS --------------
% 'samtrack','samauto','ncorr','loupas'
TRACKPARAMS.TRACK_ALG='ncorr';
TRACKPARAMS.kernelLength = 1.5; % size of tracking kernel in wavelengths
TRACKPARAMS.c = PARAMS.c;
TRACKPARAMS.trackFrequency = PARAMS.TX_FREQ;
TRACKPARAMS.fs = PARAMS.field_sample_freq;
TRACKPARAMS.upsampleFactor = 1; % don't upsample
TRACKPARAMS.searchRange = 0.5; % wavelengths



%% ---------------  MAP DYNA DISPLACEMENTS TO SCATTERER FIELD ------------
PHANTOM_DIR = fullfile(DEST_DIR, sprintf('phantom_seed%0.2d', phantom_seed));
if ~exist(PHANTOM_DIR,'dir')
    mkdir(PHANTOM_DIR)
else
    error('Error: phantom directory (%s) already exists', PHANTOM_DIR);
end
PHANTOM_FILE = fullfile(PHANTOM_DIR, 'phantom');
regeneratephantom = 0;
d = dir([PHANTOM_FILE '*.mat']);
if isempty(d) || regeneratephantom
    mkphantomfromdyna3(DYN_FILE,ZDISPFILE,PHANTOM_FILE,PPARAMS);
    %mkphantomfromdyna3symmetry(DYN_FILE,ZDISPFILE,PHANTOM_FILE,PPARAMS);
end

%% ------------- GENERATE RF SCANS OF SCATTERER FIELDS -------------------
RF_DIR = fullfile(PHANTOM_DIR, 'rfData');
if ~exist(RF_DIR,'dir')
    mkdir(RF_DIR)
else
    error('Error: rf data directory (%s) already exists', RF_DIR);
end
RF_FILE = fullfile(RF_DIR, 'rf');

%% at this point, write a mat file with the parameters
% save(fullfile(DEST_DIR, sprintf('ultratrackParams_seed%0.2d.mat', phantom_seed)), 'PPARAMS', 'PARAMS', 'TRACKPARAMS', 'DEST_DIR', 'PHANTOM_DIR', 'RF_DIR');

do_dyna_scans(PHANTOM_FILE,RF_FILE,PARAMS);


%% load all RF into a big matrix
n=1;

while ~isempty(dir(sprintf('%s%03d.mat',RF_FILE,n)))
   load(sprintf('%s%03d.mat',RF_FILE,n));
   % some rf*.mat files are off by one axial index; allowing for some PARAMS.YSTEPnamic
   % assignment of bigRF matrix
   % bigRF(:,:,n)=rf;
   bigRF(1:size(rf,1),:,n)=rf;
   n=n+1;
end;

%% track the displacements
%%[D,C]=estimate_disp(bigRF,TRACKPARAMS.TRACK_ALG,TRACKPARAMS.KERNEL_SAMPLES);
[arfidata,cc_coef]=estimate_disp(bigRF,TRACKPARAMS);

% save res_tracksim.mat (same format as experimental res*.mat files)
axial = (0:(size(arfidata,1)-1))*TRACKPARAMS.c/(2*TRACKPARAMS.fs)*1000;  % mm
lat = (PARAMS.XMIN:PARAMS.XSTEP:PARAMS.XMAX)*1e3; % mm
if exist(fullfile(DEST_DIR, 'res_sim.mat'),'file')
    resSim=load(fullfile(DEST_DIR, 'res_sim.mat'));
else
    error('We have a problem; res_sim.mat does not exist in the CWD, so the time variable cannot be defined.');
end;

if(~isempty(PPARAMS.TIMESTEP)),
    t = resSim.t(PPARAMS.TIMESTEP); % s
else
    t = resSim.t; % s
    if(length(t) ~= size(arfidata,3)),
        error('Mismatched time dimension');
    end;
end;

if(exist(fullfile(RF_DIR, 'res_tracksim.mat'),'file')==2),
    warning('res_tracksim.mat already exists; being backed up as res_tracksim.mat.old');
    movefile(fullfile(RF_DIR, 'res_tracksim.mat'), fullfile(RF_DIR, 'res_tracksim.mat.old'))
end;
% convert variables to singles to save space
for i={'arfidata','lat','axial','t','cc_coef'},
    eval(sprintf('%s = single(%s);',char(i),char(i)));
end;
save(fullfile(RF_DIR, 'res_tracksim.mat'),'arfidata','lat','axial','t','cc_coef');
disp('res_tracksim.mat created');