function varargout=mkphantomfromdyna3(DYN_FILE,ZDISPFILE,OUTPUT_NAME,PPARAMS);
%
% mkphantomfromdyna3(DYN_FILE,ZDISPFILE,OUTPUT_NAME,PPARAMS);
%
% Function for reading .dyn and zdisp files and generating displaced
% scatterers for Field.  Function saves phantom structures compatible
% with the URI/Field II toolkit
%
% DYN_FILE: 	.dyn file name. Will be appended with timestep
% 		in %03d format, e.g. 'phantom002'
%
% ZDISPFILE:	name of matlab file containing zdisp
%
% OUTPUT_NAME:	name of output file containing phantom
%
% PPARAMS: 	structure with the following fields:
% 	N:		number of scatteres to create
% 	xmin, xmax,
% 	ymin, ymax,
% 	zmin, zmax:	Minimum and maximum spatial extent of scatters.
% 			Leave any empty to use the corresponding mesh
%			dimension as the limit
% 			NOTE!!! THESE ARE DYNA'S UNITS HERE!!!
% 			NOTE ALSO!! THIS IS DYNA COORDINATE SYSTEM!
% 			Z=AXIAL, Y = LATERAL, X=OUT OF PLANE
% 			In contrast, in field it's z axial,
%			y out of plane, and x lateral
% 			X and Y are swapped in scatterer output
%
% 	TIMESTEP 	Vector of timesteps for which to generate scatterer
% 			Use empty vector to simulate all time steps
%
%	seed		Seed state to use for random number generator.
%			Phantoms with identical N, dimensions, and seed
%			have identical inital scatterer positions
%
%	delta		rigid displacement added to all scatterer positions
%			before zdisp displacements are applied. A 1x3 vector
%			in the DYNA coordinate and unit system
%
%
% 11/11/2004 Stephen McAleavey, U. Rochester BME
% revised 11/17/04
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% brought function name into agreement with its actual filename
% Mark 03/31/08
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% converted positions and amplitudes to single precision variables
% Mark Palmeri (mark.palmeri@duke.edu)
% 2009-09-26
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% BEGIN PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FD_RATIO=0.01;		% What to mutiply dyna units by (cm) to
% get field units (m), here 100cm*0.01=1m

% END PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read the .dyn file to get node positions
disp(sprintf('Loading %s...',DYN_FILE));
[nodesAll,X,Y,Z]=read_dot_dyn(DYN_FILE);

% Create scatterers in proscribed volume
rand('state',PPARAMS.seed); % NEW ON 12/01/04: explicitly seed random generator
% to ensure identical scatterer location
% if desired
scatterers=rand(PPARAMS.N,3);
scatterers(:,1)=scatterers(:,1)*(PPARAMS.xmax-PPARAMS.xmin)+PPARAMS.xmin;
scatterers(:,2)=scatterers(:,2)*(PPARAMS.ymax-PPARAMS.ymin)+PPARAMS.ymin;
scatterers(:,3)=scatterers(:,3)*(PPARAMS.zmax-PPARAMS.zmin)+PPARAMS.zmin;

% NEW ON 12/01/04: Add rigid displacement to scatterers before shift
scatterers=scatterers+ones(PPARAMS.N,1)*PPARAMS.delta;

% MODIFIED to now read in individual time steps from a binary dat file instead
% of reading all time steps in at once (and using up excessive amounts of RAM).
% Old zdisp.mat files can be converted using convert_zdisp_dat.m .
%
% Load zdisp file;
%disp('Loading zdisp...');
%load(ZDISPFILE);
%
if(exist(ZDISPFILE,'file') == 0),
    error(sprintf('%s does not exist.  Make sure that zdisp.mat files are converted to zdisp.dat .',ZDISPFILE));
end;
zdisp_fid = fopen(ZDISPFILE,'r');

NUM_NODES = fread(zdisp_fid,1,'float32');
NUM_DIMS = fread(zdisp_fid,1,'float32');
NUM_TIMESTEPS = fread(zdisp_fid,1,'float32');

% Decide on timesteps to use
%if isempty(PPARAMS.TIMESTEP), PPARAMS.TIMESTEP=1:size(zdisp,3); end;
if isempty(PPARAMS.TIMESTEP), PPARAMS.TIMESTEP=1:NUM_TIMESTEPS; end;

% Generate displaced scatterers for each timestep
for t=PPARAMS.TIMESTEP,
    
    % Get the displacement matricies
    disp(sprintf('Extracting displacements for timestep %d...',t));
    
    % extract the zdisp values for the appropriate time step
    fseek(zdisp_fid,3*4+NUM_NODES*NUM_DIMS*(t-1)*4,-1);
    zdisp_slice = fread(zdisp_fid,NUM_NODES*NUM_DIMS,'float32');
    zdisp_slice = double(reshape(zdisp_slice,NUM_NODES,NUM_DIMS));
    
    %Determine the indices of the nodes in the disp.dat file. This is
    %necessary for the next step of reforming the displacements into 3D
    %matrices because it is possible that not all nodes are output in the
    %NODOUT file (e.g. when using a PML)
    if t == PPARAMS.TIMESTEP(1)
        %Only need to do this on the first iteration of the loop because
        %the nodal positions don't change
        [i,j,k]=ind2sub(size(nodesAll),zdisp_slice(:,1));
        xRange = min(i):max(i);
        yRange = min(j):max(j);
        zRange = min(k):max(k);
        Xtmp = X(xRange,yRange,zRange);
        Ytmp = Y(xRange,yRange,zRange);
        Ztmp = Z(xRange,yRange,zRange);
        nodes = nodesAll(xRange,yRange,zRange);
        
        if strcmp(PPARAMS.SYM,'q')
            Xtmp = cat(1,Xtmp,-flipdim(Xtmp(1:end-1,:,:),1));
            Xtmp = cat(2,flipdim(Xtmp(:,2:end,:),2),Xtmp);
            
            Ytmp = cat(2,-flipdim(Ytmp(:,2:end,:),2),Ytmp);
            Ytmp = cat(1,Ytmp,flipdim(Ytmp(1:end-1,:,:),1));
            
            Ztmp = cat(1,Ztmp,flipdim(Ztmp(1:end-1,:,:),1));
            Ztmp = cat(2,flipdim(Ztmp(:,2:end,:),2),Ztmp);
        end
    end
        
    %Rearrange the displacement matrix into three 3D matrices corresponding
    %to x-displacement, y-displacement, and z-displacement
    [dX,dY,dZ]=reform_zdisp_slice(zdisp_slice,nodes);
    clear zdisp_slice
    
    if strcmp(PPARAMS.SYM,'q')
        % Account for quarter symmetry in the mesh
        dX = cat(1,dX,flipdim(dX(1:end-1,:,:),1));
        dX = cat(2,flipdim(dX(:,2:end,:),2),dX);
        
        dY = cat(1,dY,flipdim(dY(1:end-1,:,:),1));
        dY = cat(2,flipdim(dY(:,2:end,:),2),dY);
        
        dZ = cat(1,dZ,flipdim(dZ(1:end-1,:,:),1));
        dZ = cat(2,flipdim(dZ(:,2:end,:),2),dZ);
    elseif strcmp(PPARAMS.SYM,'h')
        error('Half symmetry not implemented yet.');
    end
    
    % Interpolate displacement values
    sdX = interpn(Xtmp,Ytmp,Ztmp,dX,...
        scatterers(:,1),scatterers(:,2),scatterers(:,3),'linear');
    sdY = interpn(Xtmp,Ytmp,Ztmp,dY,...
        scatterers(:,1),scatterers(:,2),scatterers(:,3),'linear');
    sdZ = interpn(Xtmp,Ytmp,Ztmp,dZ,...
        scatterers(:,1),scatterers(:,2),scatterers(:,3),'linear');
    
    %Remove any NaN values from scatterer displacement matrix. NaNs will
    %occur if a scatterers is placed outside of the bounds of the nodal
    %displacement matrix that is passed in.
    sdX(isnan(sdX)) = 0;
    sdY(isnan(sdY)) = 0;
    sdZ(isnan(sdZ)) = 0;
    
    % Add displacements to initial scatterer positions
    % and insert the values in the phantom structure
    phantom.position=(scatterers+[sdX sdY sdZ])*FD_RATIO;
    
    % Reverse z dimension and swap x and y
    % to go from dyna-land to field-world
    phantom.position(:,3)=phantom.position(:,3)*-1;
    phantom.position=phantom.position(:,[2 1 3]);
    
    % Insert amplitudes for scatterers
    phantom.amplitude=ones(size(scatterers,1),1);
    
    
    %Include evenly spaced bright scatterers (if requested) (Pete
    %2012.11.13)
    if isfield(PPARAMS,'pointscatterers')
        [xpos ypos zpos] = ndgrid(PPARAMS.pointscatterers.x,PPARAMS.pointscatterers.y,PPARAMS.pointscatterers.z);
        wire_positions = [xpos(:) ypos(:) zpos(:)]; %xyz Scatterer Locations [m]
        wire_amplitudes = PPARAMS.pointscatterers.a*ones(size(wire_positions,1),1);
        phantom.position = [phantom.position; wire_positions];
        phantom.amplitude = [phantom.amplitude; wire_amplitudes];
    end
    
    % convert to single precision
    phantom.position = single(phantom.position);
    phantom.amplitude = single(phantom.amplitude);
    
    
    % Append PPARAMS onto phantom structure
    phantom.PPARAMS=PPARAMS;
    
    % Save phantom to file
    save(sprintf('%s%03d',OUTPUT_NAME,t), 'phantom')
end;

fclose(zdisp_fid);

% NEW on 12/01/04: If an output argument is supplied/requested,
% output PPARAMS to it.
if (nargout>0)
    varargout={PPARAMS};
end;

disp('Done.');
