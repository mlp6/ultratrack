function ultra_driver(phantom_seed, nodes, dispdat)
% function ultra_driver(phantom_seed, nodes, dispdat)
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
% EXAMPLE: driver(0, './nodes.dyn', './disp.dat')
%

% ------------------PHANTOM PARAMETERS----------------------------
% setup phantom parameters (PPARAMS)
% leave any empty to use mesh limit
generatephantom = logical(1);
PPARAMS.sym = 'q';
PPARAMS.xmin=[-0.5];PPARAMS.xmax=[0.3];	% out-of-plane,cm
PPARAMS.ymin=[-1.0];PPARAMS.ymax=[1.0];	% lateral, cm \
PPARAMS.zmin=[-3.0];PPARAMS.zmax=[-0.1];% axial, cm   / X,Y SWAPPED vs FIELD!
% Timesteps to simulation (leave empty for all FEM timesteps)
PPARAMS.TIMESTEP=[];

% compute number of scatteres to use
SCATTERER_DENSITY = 300; % scatterers/cm^3
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

PARAMS = parallel_tx_rx(0, 0, PARAMS); % Tx & Rx beam override possible with 1s

%% ------------- GENERATE RF SCANS OF SCATTERER FIELDS -------------------
RF_DIR=[make_file_name('rf', [PHANTOM_DIR 'rf'], PARAMS) '/'];
RF_FILE=[RF_DIR 'rf'];
mkdir(RF_DIR);
field_init(-1);
do_dyna_scans(PHANTOM_FILE, RF_FILE, PARAMS);
field_end;
