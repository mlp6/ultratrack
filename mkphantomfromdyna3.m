function varargout = mkphantomfromdyna3(DYN_FILE, ZDISPFILE, OUTPUT_NAME, PPARAMS);
% function varargout = mkphantomfromdyna3(DYN_FILE, ZDISPFILE, OUTPUT_NAME, PPARAMS);
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

FD_RATIO=0.01;  % What to mutiply dyna units by (cm) to
			    % get field units (m), here 100cm*0.01=1m

% Read the .dyn file to get node positions
disp(sprintf('Loading %s...',DYN_FILE));
[nodes, X, Y, Z] = read_dot_dyn(DYN_FILE);

% Create scatterers in specified volume with explicitly seeded random generator
% to ensure identical scatterer location in subsequent runs if needed
rng(PPARAMS.seed);
scatterers=rand(PPARAMS.N,3);
scatterers(:,1) = scatterers(:,1) * (PPARAMS.xmax - PPARAMS.xmin) + PPARAMS.xmin;
scatterers(:,2) = scatterers(:,2) * (PPARAMS.ymax - PPARAMS.ymin) + PPARAMS.ymin;
scatterers(:,3) = scatterers(:,3) * (PPARAMS.zmax - PPARAMS.zmin) + PPARAMS.zmin;

% add rigid displacement to scatterers before shift
scatterers = scatterers + (ones(PPARAMS.N,1) * PPARAMS.delta);

if(exist(ZDISPFILE, 'file') == 0),
    error(sprintf('%s does not exist.', ZDISPFILE));
else
    zdisp_fid = fopen(ZDISPFILE, 'r');
end

NUM_NODES = fread(zdisp_fid, 1, 'float32');
NUM_DIMS = fread(zdisp_fid, 1, 'float32');
NUM_TIMESTEPS = fread(zdisp_fid, 1, 'float32');

% Decide on timesteps to use
if isempty(PPARAMS.TIMESTEP), 
    PPARAMS.TIMESTEP=1:NUM_TIMESTEPS; 
end

% Generate displaced scatterers for each timestep
for t=PPARAMS.TIMESTEP,
    
    % Get the displacement matricies
    disp(sprintf('Extracting displacements for timestep %d...',t));
    
    % extract the zdisp values for the appropriate time step
    fseek(zdisp_fid,3*4+NUM_NODES*NUM_DIMS*(t-1)*4,-1);
    zdisp_slice = fread(zdisp_fid,NUM_NODES*NUM_DIMS,'float32');
    zdisp_slice = double(reshape(zdisp_slice,NUM_NODES,NUM_DIMS));
    
    if (strcmp(PPARAMS.sym, 'q') | strcmp(PPARAMS.sym, 'h')) & ...
       (t == PPARAMS.TIMESTEP(1)),
        [X, Y, Z] = reflect_node_coord_disp('coord', PPARAMS.sym, X, Y, Z);
    end
        
    % Rearrange the displacement matrix into three 3D matrices corresponding to
    % x-displacement, y-displacement, and z-displacement
    [dX, dY, dZ] = reform_zdisp_slice(zdisp_slice, nodes);
    clear zdisp_slice
    
    if (strcmp(PPARAMS.sym, 'q') | strcmp(PPARAMS.sym, 'h')),
        [dX, dY, dZ] = reflect_node_coord_disp('disp', PPARAMS.sym, dX, dY, dZ);
    end
    
    % Interpolate displacement values
    sdX = interpn(X, Y, Z, dX, scatterers(:,1), scatterers(:,2), ...
                  scatterers(:,3), 'linear');
    sdY = interpn(X, Y, Z, dY, scatterers(:,1), scatterers(:,2), ...
                  scatterers(:,3), 'linear');
    sdZ = interpn(X, Y, Z, dZ, scatterers(:,1), scatterers(:,2), ...
                  scatterers(:,3), 'linear');
    
    % Remove any NaN values from scatterer displacement matrix. NaNs will
    % occur if a scatterers is placed outside of the bounds of the nodal
    % displacement matrix that is passed in.
    sdX(isnan(sdX)) = 0;
    sdY(isnan(sdY)) = 0;
    sdZ(isnan(sdZ)) = 0;
    
    % Add displacements to initial scatterer positions and insert the values in
    % the phantom structure
    phantom.position = (scatterers + [sdX sdY sdZ]) * FD_RATIO;
    
    % Reverse z dimension and swap x and y to go from dyna-land to field-world
    phantom.position(:,3) = phantom.position(:,3) * -1;
    phantom.position = phantom.position(:, [2 1 3]);
    
    % Insert amplitudes for scatterers
    % Have uniform amplitude, but can set to something other than 1 (e.g., 0,
    % to only have point scatteres (below))
    phantom.amplitude = PPARAMS.rand_scat_amp .* ones(size(scatterers,1),1);
    
    
    %Include evenly spaced bright scatterers (if requested)
    if isfield(PPARAMS,'pointscatterers')
        [xpos ypos zpos] = ndgrid(PPARAMS.pointscatterers.x, ...
                                  PPARAMS.pointscatterers.y, ...
                                  PPARAMS.pointscatterers.z);
        wire_positions = [xpos(:) ypos(:) zpos(:)]; %xyz Scatterer Locations [m]
        wire_amplitudes = PPARAMS.pointscatterers.a*ones(size(wire_positions,1),1);
        phantom.position = [phantom.position; wire_positions];
        phantom.amplitude = [phantom.amplitude; wire_amplitudes];
    end
    
    % convert to single precision
    phantom.position = single(phantom.position);
    phantom.amplitude = single(phantom.amplitude);

	% append PPARAMS onto phantom structure
	phantom.PPARAMS = PPARAMS;

	% save phantom to file
    save(sprintf('%s%03d', OUTPUT_NAME, t), 'phantom')

end; % end time loop

fclose(zdisp_fid);

% NEW on 12/01/04: If an output argument is supplied/requested,
% output PPARAMS to it.
if (nargout>0)
    varargout={PPARAMS};
end;

disp('Done.');
