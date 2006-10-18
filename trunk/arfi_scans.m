function []=arfi_scans(Smark,PATH)
% function []=arfi_scans(Smark,PATH)
% INPUTS:	Smark - scatterer distribution seed
% 		Freq - frequency (MHz)
%			KernelSize - # samples in tracking kernel (default = 35)
%			PATH (string) - path to save tracked results and to find
%			zdisp.mat
% OUTPUTS:	files and directories created in PATH
%
% arfi_scans.m
% 04/23/05
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
% Adjusted the tracking kernel length from a fixed 35 samples
% (corresponding to 2.5 cycles @ 7 MHz) to a variable kernel
% length as a function of frequency.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fixed 0.35 us kernel length data saved in track_TRACK1_p35us
% directories, while the new data is in the standard
% track_TRACK1 directories.
% Mark 01/24/05
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Added PATH as an input variable.
% Mark 04/23/05
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Added PARAMS.RXOFFSET to allow for the Rx beam to be
% laterally offset from the Tx beam for parallel tracking ARFI
% simulations.  This value is used by do_dyna_scans() to pass
% to uf_scan(), which passes the variable to uf_set_beam(),
% where it is actually used.
% Mark 06/16/05
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Change RXOFFSET -> TXOFFSET to allow for easier spatial
% registration of the tracked displacements.
% Mark 06/17/05
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
DEST_DIR = PATH;
ZDISPFILE = [PATH 'zdisp.mat'];
%ZDISPFILE='/emfd/mlp6/CIRS_FEM/HomogSims/E4kPa_foc20mm_a0p5_TopBCconst/zdisp.mat'
%DEST_DIR='/emfd/mlp6/CIRS_FEM/HomogSims/E4kPa_foc20mm_a0p5_TopBCconst/'
%PPARAMS.N=1;
%PPARAMS.N=2500;
%PPARAMS.N=8000;
%PPARAMS.N=25000;
PPARAMS.N=45833;
%PPARAMS.N=58500;

				% leave any empty to use mesh limit
PPARAMS.xmin=[-0.25];PPARAMS.xmax=[0];		% out-of-plane,cm
% single line data
%PPARAMS.ymin=[-1.0];PPARAMS.ymax=[1.0];	% lateral, cm \
PPARAMS.ymin=[0];PPARAMS.ymax=[2.2];	% lateral, cm \
% full FOV data
%PPARAMS.ymin=[-1.0];PPARAMS.ymax=[1.0];	% lateral, cm \
PPARAMS.zmin=[];PPARAMS.zmax=[-0.1];		% axial, cm   / X,Y SWAPPED vs FIELD!	
PPARAMS.TIMESTEP=[];		% Timesteps to simulate.  Leave empty to
                                % simulate all timesteps

PPARAMS.seed=Smark;         % Random number generator seed.  Use zero unless
                        % you have a good reason (i.e. want a
                        % different
                        % scatterer layout)

PPARAMS.delta=[0 0 0]   % rigid pre-zdisp-displacement scatterer translation,
                        % in the dyna coordinate/unit system

% PARAMETERS FOR SCANNING
Freq = 7;
switch Freq
case 7,
  PARAMS.PROBE_NAME='75L40.txt'; % Probe text file name
otherwise,
  eval(sprintf('PARAMS.PROBE_NAME=''vf10-5_%iMHz.txt'';',Freq));
end;
PARAMS.XMIN=0.0;		% Leftmost scan line (m)
PARAMS.XSTEP=2e-4;		% Scanline spacing (m)
PARAMS.XMAX=8e-3;		% Rightmost scan line (m)
PARAMS.TX_FOCUS=2e-2;           % Tramsmit focus depth (m)
PARAMS.TX_F_NUM=1;              % Transmit f number 
PARAMS.TX_FREQ=Freq*1e6;        % Transmit frequency (Hz)
PARAMS.TX_NUM_CYCLES=1;         % Number of cycles in transmit toneburst
PARAMS.RX_FOCUS=0;              % Depth of receive focus - use 0 for dyn. foc
PARAMS.RX_F_NUM=0.5;              % Receive aperture f number
PARAMS.RX_GROW_APERTURE=1;      %

% lateral offset of the Tx beam from the Rx beam (m)
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
KernelSize = 35;
if(KernelSize == 35),
	TRACK_FILE=[TRACK_DIR 'track'];
else,
	TRACK_FILE=sprintf('%strackKS%i',TRACK_DIR,KernelSize);
end;

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
    % MODIFIED THE CODE TO HAVE A VARIABLE KERNEL
    % SIZE AS A FUNCTION OF FREQUENCY TO MAINTAIN A
    % CONSTANT 2.5 CYCLES / KERNEL
    % MARK 01/24/05
    %[D(:,:,n),C(:,:,n)]=sam_track(squeeze(bigRF(:,n,:)),35,-5,5);
		%
		% Allow for variable kernel sizes
		%
    %[D(:,:,n),C(:,:,n)]=sam_track(squeeze(bigRF(:,n,:)),35*7/Freq,-5,5);
    [D(:,:,n),C(:,:,n)]=sam_track(squeeze(bigRF(:,n,:)),KernelSize*7/Freq,-5,5);
  end;
end;

if (TRACKPARAMS.TRACK==2),
	% use gfp's tracker
	disp('GFP Tracking code not integrated yet! Sorry!');
	end;
                                                                                
% save
save(TRACK_FILE,'D','C','PARAMS','TRACKPARAMS','PPARAMS','DYN_FILE','ZDISPFILE','RF_FILE','PHANTOM_FILE')

% DONE!
