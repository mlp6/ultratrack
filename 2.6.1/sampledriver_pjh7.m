function []=sampledriver_pjh7(phantom_seed)
% function []=arfi_scans_template(phantom_seed)
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

% PATH TO URI/FIELD/TRACKING FILES:
ULTRATRACK_PATH = '/getlab/pjh7/ultratrack/2.6.1';
addpath(ULTRATRACK_PATH)
addpath([ULTRATRACK_PATH '/URI_FIELD/code']);
addpath([ULTRATRACK_PATH '/URI_FIELD/code/probes']);
%addpath('/radforce/mlp6/arfi_code/sam/trunk/');
addpath('/home/pjh7/FIELDII/');
%addpath('/luscinia/vr16/StrainLiver/trackingcode/simtrack');

%% ------------------PHANTOM PARAMETERS----------------------------
% file containing comma-delimited node data
DYN_FILE='/getlab/pjh7/field_sims/acunav128/mesh/nodes.dyn';
DEST_DIR = pwd;
DEST_DIR = [DEST_DIR '/'];
ZDISPFILE = [DEST_DIR 'disp.dat'];



% setup phantom parameters (PPARAMS)
% leave any empty to use mesh limit
PPARAMS.xmin=[-0.25];PPARAMS.xmax=[0.25];	% out-of-plane,cm
PPARAMS.ymin=[-1.5];PPARAMS.ymax=[1.5];	% lateral, cm \
PPARAMS.zmin=[-2.0];PPARAMS.zmax=[-1.0];% axial, cm   / X,Y SWAPPED vs FIELD!
PPARAMS.TIMESTEP=[];	% Timesteps to simulate.  Leave empty to
% simulate all timesteps

% compute number of scatteres to use
SCATTERER_DENSITY = 2*27610; % scatterers/cm^3
TRACKING_VOLUME = (PPARAMS.xmax-PPARAMS.xmin)*(PPARAMS.ymax-PPARAMS.ymin)*(PPARAMS.zmax-PPARAMS.zmin); % cm^3
PPARAMS.N = round(SCATTERER_DENSITY * TRACKING_VOLUME); % number of scatterers to randomly distribute over the tracking volume

PPARAMS.seed=phantom_seed;         % RNG seed

PPARAMS.pointscatterers.x = 1e-3*[-30:4:30]; % X locations of point scatterers
PPARAMS.pointscatterers.z = 1e-3*[2:4:45]; % Y locations of point scatterers
PPARAMS.pointscatterers.y = 1e-3*[0]; % Z locations of point scatterers
PPARAMS.pointscatterers.a = 20; % Point scatterer amplitude

PPARAMS.delta=[0 0 0];   % rigid pre-zdisp-displacement scatterer translation,
% in the dyna coordinate/unit system to simulate s/w
% sequences

%%  --------------IMAGING PARAMETERS---------------------------------
PARAMS.PROBE ='AcuNav10F';
%PARAMS.IMAGE_MODE='phased';  % 'linear' or 'phased' (help determine how to do parallel rx and matrix array work)

% setup some Field II parameters
PARAMS.field_sample_freq = 200e6; % Hz
PARAMS.c = 1540; % sound speed (m/s)

% TRANSMIT BEAM LOCATIONS
PARAMS.XMIN=    0.5*-3.54e-3;	   % Leftmost scan line (m)
PARAMS.XSTEP =  0*3.54e-3;      % Azimuth step size (m);
PARAMS.XMAX=    0.5*3.54e-3;	   % Rightmost scan line (m)
PARAMS.THMIN =  0;      % Leftmost azimuth angle (deg)
PARAMS.THSTEP = 40;    % Azimuth angle step(deg)
PARAMS.THMAX =  0;      % Rightmost azimuth angle (deg)
PARAMS.PHIMIN= 0;      % Frontmost elevation angle (deg)
PARAMS.PHISTEP = 0;    % Elevation angle step(deg)
PARAMS.PHIMAX= 0;      % Backmost elevation angle (deg)
PARAMS.YMIN=   0;		% Frontmost scan line (m)
PARAMS.YSTEP = 0;      % Elevation step size (m);
PARAMS.YMAX=   0;	    % Backmost scan line (m)
PARAMS.APEX = 2*-3.54e-3; %Apex of scan geometry. Set to 0 for linear scanning.
PARAMS.TX_FOCUS= 2*-3.54e-3;    % Tramsmit focus depth (m)
PARAMS.TX_F_NUM=[1 1];      % Transmit f number (the "y" number only used for 2D matrix arrays)
PARAMS.TX_FREQ=6.15e6;      % Transmit frequency (Hz)
PARAMS.TX_NUM_CYCLES=3;     % Number of cycles in transmit toneburst
PARAMS.RX_FOCUS= 0;          % Depth of receive focus - use 0 for dyn. foc
PARAMS.RX_F_NUM=[1 1];  % Receive aperture f number (the "y" number only used for 2D matrix arrays)
PARAMS.RX_GROW_APERTURE=1;

% lateral offset of the Tx beam from the Rx beam (m) to simulated prll rx
% tracking (now a 2 element array, v2.6.0) (m)
%%% 2012.11.2 pjh7 adding native parallel receive functionality at lower
%%% level and swapped tx offsets for rx offsets
PARAMS.NO_PARALLEL = [64 1]; %[no_X no_Y]
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
TRACKPARAMS.TRACK_ALG='samtrack';
TRACKPARAMS.WAVELENGTHS = 1.5; % size of tracking kernel in wavelengths
%TRACKPARAMS.KERNEL_SAMPLES = 85; % samples
TRACKPARAMS.KERNEL_SAMPLES = round((PARAMS.field_sample_freq/PARAMS.TX_FREQ)*TRACKPARAMS.WAVELENGTHS);


%% ---------------  MAP DYNA DISPLACEMENTS TO SCATTERER FIELD ------------
P=rmfield(PPARAMS,{'TIMESTEP','pointscatterers'});
P.X = sprintf('%g_%g',10*P.ymin,10*P.ymax);
P.Y = sprintf('%g_%g',10*P.xmin,10*P.xmax);
P.Z = sprintf('%g_%g',-10*P.zmax,-10*P.zmin);
P = rmfield(P,{'xmin','xmax','ymin','ymax','zmin','zmax'});

PHANTOM_DIR=[make_file_name([DEST_DIR 'v_phantom_short'],P) '/'];
PHANTOM_FILE=[PHANTOM_DIR 'phantom'];
regeneratephantom = 0;
d = dir([PHANTOM_FILE '*.mat']);
if isempty(d) || regeneratephantom
    unix(sprintf('mkdir %s',PHANTOM_DIR)); % mkdir(PHANTOM_DIR); %matlab 7
    mkphantomfromdyna3symmetry(DYN_FILE,ZDISPFILE,PHANTOM_FILE,PPARAMS);
end

%% ------------- GENERATE RF SCANS OF SCATTERER FIELDS -------------------
P = rmfield(PARAMS,{'RXOFFSET','BEAM_ORIGIN_X','BEAM_ORIGIN_Y','BEAM_ANGLE_X','BEAM_ANGLE_Y'});
P.X = sprintf('%g_%g_%g',1e3*P.XMIN,1e3*P.XSTEP,1e3*P.XMAX);
P.Y = sprintf('%g_%g_%g',1e3*P.YMIN,1e3*P.YSTEP,1e3*P.YMAX);
P.PHI = sprintf('%g_%g_%g',P.PHIMIN,P.PHISTEP,P.PHIMAX);
P.THETA = sprintf('%g_%g_%g',P.THMIN,P.THSTEP,P.THMAX);
P = rmfield(P,{'XMIN','XMAX','XSTEP','YMIN','YMAX','YSTEP','PHIMIN','PHIMAX','PHISTEP','THMIN','THSTEP','THMAX'});
P.NO_BEAMS = sprintf('%g_%g',P.NO_BEAMS_X,P.NO_BEAMS_Y);
P = rmfield(P,{'NO_BEAMS_X','NO_BEAMS_Y'});
P.NPAR = sprintf('%g_%g',P.NO_PARALLEL(1),P.NO_PARALLEL(2));
P.PSPACE = sprintf('%g_%g',P.PARALLEL_SPACING(1),P.PARALLEL_SPACING(2));
P = rmfield(P,{'NO_PARALLEL','PARALLEL_SPACING'});
P.APEX = sprintf('%g',1e3*P.APEX);
P.TX_FOCUS = sprintf('%g',1e3*P.TX_FOCUS);
P.TX_FREQ = sprintf('%g',1e-6*P.TX_FREQ);
P.FS = sprintf('%g',1e-6*P.field_sample_freq);
P = rmfield(P,'field_sample_freq');
P.RX_FOCUS = sprintf('%g',1e3*P.RX_FOCUS);
P.TX_F_NUM = sprintf('%g_%g',P.TX_F_NUM(1),P.TX_F_NUM(2));
P.RX_F_NUM = sprintf('%g_%g',P.RX_F_NUM(1),P.RX_F_NUM(2));


RF_DIR=[make_file_name([PHANTOM_DIR 'rf'],P) '/'];
mkdir(RF_DIR); %matlab 7
RF_FILE=[RF_DIR 'rf'];
field_init(-1);
do_dyna_scans(PHANTOM_FILE,RF_FILE,PARAMS);
field_end;

%% TRACK RF
%TRACK_DIR=[make_file_name([RF_DIR 'track'],TRACKPARAMS) '/'];
%unix(sprintf('mkdir %s',TRACK_DIR)); % mkdir(TRACK_DIR); %matlab 7

%% load all RF into a big matrix
%n=1;

%while ~isempty(dir(sprintf('%s%03d.mat',RF_FILE,n)))
%    load(sprintf('%s%03d.mat',RF_FILE,n));
%    % some rf*.mat files are off by one axial index; allowing for some PARAMS.YSTEPnamic
%    % assignment of bigRF matrix
%    % bigRF(:,:,n)=rf;
%    bigRF(1:size(rf,1),:,n)=rf;
%    n=n+1;
%end;

%% track the displacements
%%[D,C]=estimate_disp(bigRF,TRACKPARAMS.TRACK_ALG,TRACKPARAMS.KERNEL_SAMPLES);
%[D,C]=estimate_disp(bigRF,TRACKPARAMS);

%% save res_tracksim.mat (same format as experimental res*.mat files)
%track_save_path = pwd;
%createtrackres(C,D,PARAMS,PPARAMS,PHANTOM_FILE,RF_FILE,TRACKPARAMS,TRACK_DIR);
