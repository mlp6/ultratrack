function []=att_scan(Smark,zdisp_path)
% function []=att_scan(Smark,zdisp_path)
%
% att_scan.m - script to run attenuation tracking simulations
% Mark 01/02/06
%
% arfi_scans.m
% 12/05/04
%
% Script for doing ARFI scans of phantoms incorporating 
% dyna-calculated displacements.  Incorporates function-ized
% versions of script_p and scan_script.  11/11/04 Stephen McAleavey
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Changes to arfi_scans2:
% (1) Changed URI code paths for 'mlp6' directories
% (2) Added GENERATE_PHANTOM flag to determine whether new
%     phantom files should be generated or use pre-existing ones.
% Mark 11/30/04
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Changes in arfi_scans3:
% (1) PPARAMS.seed - the value to seed the random number
%     generator with; this was added to allow for the same
%     scatterer distribution to be generated (with the same
%     seed value) to allow for identical phantoms when
%     generating 2D ARFI scan simulations
% (2) PPARAMS.delta - amount of offset to add to the scatterers
%     in the phantom; to be used to provide a lateral offset
%     when doing the 2D ARFI scans
% (3) mkphantomfromdyna3 was written to provide feedback on the
%     spatial extent of the phantom being simulated
%
% Changes were implemented by Steve, and I've incorporated them
% here in my master code directory.
% Mark 12/01/04
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Added flag to skip re-generation of RF data is only
% cross-correlation code needs to be run.
% Mark 12/03/04
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Some of the RF data files are off by one axial index -
% adding a buffer in the code to account for an off index.
% Mark 12/05/04
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% PATH TO URI/FIELD FILES:
addpath('/home/mlp6/matlab/URI_FIELD/code');
addpath('/home/mlp6/matlab/URI_FIELD/code/probes');

% SHOULD NEW PHANTOM FILES BE GENERATED
% SHOULD RF SCANS BE GENERATED
% BOOLEAN: 0 - no, 1 - yes
GENERATE_PHANTOM = 1;
GENERATE_RF = 1;

% PARAMETERS FOR PHANTOM CREATION
DYN_FILE='/home/mlp6/arfi/cirs_nodes.dyn'
%DEST_DIR='/emfd/mlp6/CIRS_FEM/HomogSims/E4kPa_foc5mm_a0p3_TopBCconst/'
DEST_DIR=zdisp_path;
ZDISPFILE = [DEST_DIR 'zdisp.mat'];
PPARAMS.N=2500;

PPARAMS.delta=[0 0 0]  % rigid pre-zdisp-displacement scatterer translation,
                          % in the dyna coordinate/unit system

				% leave any empty to use mesh limit
PPARAMS.xmin=[-0.15];PPARAMS.xmax=[0];		% out-of-plane,cm
PPARAMS.ymin=[-0.1];PPARAMS.ymax=[0.1];	% lateral, cm \
PPARAMS.zmin=[];PPARAMS.zmax=[-0.1];		% axial, cm   / X,Y SWAPPED vs FIELD!	
PPARAMS.TIMESTEP=[];		% Timesteps to simulate.  Leave empty to
                                % simulate all timesteps

PPARAMS.seed=Smark;     % Random number generator seed.  Use zero unless
                        % you have a good reason (i.e. want a
                        % different
                        % scatterer layout)

% PARAMETERS FOR SCANNING
PARAMS.PROBE_NAME='75L40.txt'; % Probe text file name
PARAMS.XMIN=-0.5e-3;		% Leftmost scan line (m)
PARAMS.XSTEP=5e-4;		% Scanline spacing (m)
PARAMS.XMAX=0.5e-3;		% Rightmost scan line (m)
PARAMS.TX_FOCUS=2e-2;           % Tramsmit focus depth (m)
PARAMS.TX_F_NUM=1;              % Transmit f number 
PARAMS.TX_FREQ=7e6;             % Transmit frequency (Hz)
PARAMS.TX_NUM_CYCLES=1;         % Number of cycles in transmit toneburst
PARAMS.RX_FOCUS=0;              % Depth of receive focus - use 0 for dyn. foc
PARAMS.RX_F_NUM=1;              % Receive aperture f number
PARAMS.RX_GROW_APERTURE=1;      %

PARAMS.TXOFFSET = 0;

% PARAMETERS FOR TRACKING
TRACKPARAMS.TRACK=1;		%1==samtrack, 2==gfptrack

% MAKE PHANTOMS
P=rmfield(PPARAMS,'TIMESTEP');
PHANTOM_DIR=[make_file_name([DEST_DIR 'phantom'],P) '/'];
unix(sprintf('mkdir %s',PHANTOM_DIR)); % mkdir(PHANTOM_DIR); %matlab 7
PHANTOM_FILE=[PHANTOM_DIR 'phantom'];
% UPDATE BY MARK; FLAG TO DETERMINE IF NEW PHANTOM FILES SHOULD
% BE GENERATED OR NOT
if(GENERATE_PHANTOM == 1),
	disp('GENERATING NEW PHANTOM FILES...');
	mkphantomfromdyna3(DYN_FILE,ZDISPFILE,PHANTOM_FILE,PPARAMS);
else,
	disp('USING EXISTING PHANTOM FILES.');
end;

% SCAN PHANTOMS
RF_DIR=[make_file_name([PHANTOM_DIR 'rf'],PARAMS) '/'];
unix(sprintf('mkdir %s',RF_DIR)); % mkdir(RF_DIR); %matlab 7
RF_FILE=[RF_DIR 'rf'];
field_init(-1);
set_field('show_times',0);
if(GENERATE_RF == 1),
  do_dyna_scans(PHANTOM_FILE,RF_FILE,PARAMS);
  disp('GENERATING RF DATA...');
else
  disp('USING EXSITING RF DATA.');
end;
field_end;

% TRACK RF
TRACK_DIR=[make_file_name([RF_DIR 'track'],TRACKPARAMS) '/'];
unix(sprintf('mkdir %s',TRACK_DIR)); % mkdir(TRACK_DIR); %matlab 7
TRACK_FILE=[TRACK_DIR 'track'];

% load all RF into a big matrix
n=1;
while ~isempty(dir(sprintf('%s%03d.mat',RF_FILE,n)))
        load(sprintf('%s%03d.mat',RF_FILE,n));
	% some rf*.mat files are off by one axial index;
	% allowing for some dynamic assignment of bigRF matrix
        % bigRF(:,:,n)=rf;
        bigRF(1:size(rf,1),:,n)=rf;
        n=n+1
        end;
                                                                                
% sam_track or gianmarco track it
if (TRACKPARAMS.TRACK==1),
	% sam_track all lines
	for n=1:size(bigRF,2)
        	[D(:,:,n),C(:,:,n)]=sam_track(squeeze(bigRF(:,n,:)),35,-5,5);
        	end;
	end;

if (TRACKPARAMS.TRACK==2),
	% use gfp's tracker
	disp('GFP Tracking code not integrated yet! Sorry!');
	end;
                                                                                
% save
save(TRACK_FILE,'D','C','PARAMS','TRACKPARAMS','PPARAMS','DYN_FILE','ZDISPFILE','RF_FILE','PHANTOM_FILE')

% DONE!
