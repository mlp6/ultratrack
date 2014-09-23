function driver_parallel(phantom_seed, nodes, dispdat)
% function driver_parallel(phantom_seed, nodes, dispdat)
% INPUTS:
%   phantom_seed (int) - scatterer position RNG seed
%   nodes (string) - location of nodes.dyn (comma-delimited); must be absolute
%                    or explicitely relative
%   dispdat (string) - location of disp.dat (where phantom* results will be
%                      saved); must be absolute or explicitely relative
%
% OUTPUTS:
%   Nothing returned, but lots of files and directories created in the parent
%   directory of disp.
%
% EXAMPLE: driver_parallel(0, './nodes.dyn', './disp.dat')
%

% ------------------PHANTOM PARAMETERS----------------------------
% setup phantom parameters (PPARAMS)
% leave any empty to use mesh limit
generatephantom = logical(1);
PPARAMS.sym = 'q';
PPARAMS.xmin=[-0.25];PPARAMS.xmax=[0.25];	% out-of-plane,cm
PPARAMS.ymin=[-1.5];PPARAMS.ymax=[1.5];	% lateral, cm \
PPARAMS.zmin=[-2.0];PPARAMS.zmax=[-0.1];% axial, cm   / X,Y SWAPPED vs FIELD!
% Timesteps to simulation (leave empty for all FEM timesteps)
PPARAMS.TIMESTEP=[];

% compute number of scatteres to use
SCATTERER_DENSITY = 27610; % scatterers/cm^3
PPARAMS.N = calc_n_scats(SCATTERER_DENSITY, PPARAMS);

PPARAMS.seed=phantom_seed;         % RNG seed

% amplitude of the randomly-distributed scatterers 
% (set to 0 if you just want the point scatterers defined below)
PPARAMS.rand_scat_amp = 1;

% optional point-scatterer locations
USE_POINT_SCATTERERS = logical(0);
if USE_POINT_SCATTERERS,
    % x, y, z locations and amplitudes of point scatteres (FIELD II coords)
    PPARAMS.pointscatterers.x = 1e-3 * [-30:4:30]; 
    PPARAMS.pointscatterers.z = 1e-3 * [2:4:45]; 
    PPARAMS.pointscatterers.y = 1e-3 * [0]; 
    PPARAMS.pointscatterers.a = 20;
end

% rigid pre-zdisp-displacement scatterer translation, in the dyna
% coordinate/unit system to simulate ARFI sequences with multiple runs
PPARAMS.delta=[0 0 0];

%% MAP DYNA DISPLACEMENTS TO SCATTERER FIELD & GENERATE PHANTOMS 
PHANTOM_DIR=[make_file_name('phantom', [fileparts(dispdat) '/phantom'], PPARAMS) '/'];
PHANTOM_FILE=[PHANTOM_DIR 'phantom'];
d = dir([PHANTOM_FILE '*.mat']);
if isempty(d) || generatephantom,
    mkdir(PHANTOM_DIR);
    mkphantomfromdyna3(nodes, dispdat, PHANTOM_FILE, PPARAMS);
end

%  --------------IMAGING PARAMETERS---------------------------------
PARAMS.PROBE ='vf10-5';
PARAMS.COMPUTATIONMETHOD = 'none'; % 'cluster','parfor', or 'none'

% setup some Field II parameters
PARAMS.field_sample_freq = 1e9; % Hz
PARAMS.c = 1540; % sound speed (m/s)

% TRACKING BEAM PARAMETERS
PARAMS.XMIN=    0;              % Leftmost scan line (m)
PARAMS.XSTEP =  0.1e-3;         % Azimuth step size (m);
PARAMS.XMAX=    5e-3;	        % Rightmost scan line (m)
PARAMS.THMIN =  0;              % Leftmost azimuth angle (deg)
PARAMS.THSTEP = 0;              % Azimuth angle step(deg)
PARAMS.THMAX =  0;              % Rightmost azimuth angle (deg)
PARAMS.PHIMIN= 0;               % Frontmost elevation angle (deg)
PARAMS.PHISTEP = 0;             % Elevation angle step(deg)
PARAMS.PHIMAX= 0;               % Backmost elevation angle (deg)
PARAMS.YMIN=   0;		        % Frontmost scan line (m)
PARAMS.YSTEP = 0;               % Elevation step size (m)
PARAMS.YMAX=   0;	            % Backmost scan line (m)
PARAMS.APEX = 0;                % Apex of scan geometry; 0 for linear scanning
PARAMS.TX_FOCUS= 20.0e-3;       % Tramsmit focus depth (m)
PARAMS.TX_F_NUM=[1 1];          % Tx F/# (index 2 only used for 2D matrix arrays)
PARAMS.TX_FREQ=6.15e6;          % Transmit frequency (Hz)
PARAMS.TX_NUM_CYCLES=3;         % Number of cycles in transmit toneburst
PARAMS.RX_FOCUS= 0;             % Depth of receive focus - use 0 for dynamic Rx
PARAMS.RX_F_NUM=[1 1];          % Rx F/# (index 2 only used for 2D matrix arrays)
PARAMS.RX_GROW_APERTURE=1;      
PARAMS.MINDB = -20;             % Min dB to include a scat in reduction
PARAMS.NO_PARALLEL = [1 1];     % [no_X no_Y]
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

TX_BEAM_OVERRIDE = logical(0);

if TX_BEAM_OVERRIDE,
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


if length(PARAMS.BEAM_ANGLE_X) > 1 && ...
    length(PARAMS.BEAM_ORIGIN_X) > 1 && ...
    length(PARAMS.BEAM_ORIGIN_X) ~= ...
    length(PARAMS.BEAM_ANGLE_X);
    error('BEAM_ORIGIN_X and BEAM_ANGLE_X cannot both be vectors and have different lengths.')
end

if length(PARAMS.BEAM_ANGLE_Y) > 1 && ...
    length(PARAMS.BEAM_ORIGIN_Y) > 1 && ...
    length(PARAMS.BEAM_ORIGIN_Y) ~= ...
    length(PARAMS.BEAM_ANGLE_Y);
    error('BEAM_ORIGIN_Y and BEAM_ANGLE_Y cannot both be vectors and have different lengths.')
end

PARAMS.NO_BEAMS_X = max(length(PARAMS.BEAM_ORIGIN_X), length(PARAMS.BEAM_ANGLE_X));
PARAMS.NO_BEAMS_Y = max(length(PARAMS.BEAM_ORIGIN_Y), length(PARAMS.BEAM_ANGLE_Y));


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

%% ------------- GENERATE RF SCANS OF SCATTERER FIELDS -------------------
RF_DIR=[make_file_name('rf', [PHANTOM_DIR 'rf'], PARAMS) '/'];
RF_FILE=[RF_DIR 'rf'];
mkdir(RF_DIR);
field_init(-1);
do_dyna_scans(PHANTOM_FILE, RF_FILE, PARAMS);
field_end;
