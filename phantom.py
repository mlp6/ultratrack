import numpy as np

def main(timesteps):
    #for t in timesteps:
    p = Phantom()
    p.calc_n_scats()
    pass


class Phantom:
    """generate 3D scatterer phantoms with displacements from FEM models

    The FEM models are traditionally run with cgs units, with the following coordinate assumption:
        X - elevation dimension (0 -> negative for quarter symmetry)
        Y - lateral dimnenson (0 -> positive for quarter symmetry)
        Z - depth (0 -> negative, transducer at 0)

    This coordinate system differs from that used for Field II!!  This is accounted for in the downstream code that
    calls Field II, not here.

    :param nodesdynfile: nodes.dyn
    :param dispdatfile: disp.dat.xz
    :param phantomout: prefix for phantom HDF5 output filenames
    :param scat_density: scatterer density (scatterers / cm^3)
    :param phantom_bounds: tuple of scatterer phantom bounds using mesh coordinates
     (leave any dimension as 'None' to use mesh limit) ((xmin, xmax), (ymin, ymax), (zmin, zmax))
    :param timestep: timestep (single int) to create (based on FEM timesteps; keep as None to use all timesteps)
    :param rng_seed: RNG seed (to create the "same" random distributions for iterating over track parameters)
    :param delta_xyz: rigid x, y, z translation to apply to scatterers for the specified timestep
    """

    def __init__(self, nodesdynfile="nodes.dyn", dispdatfile="disp.dat.xz", phantomout="phantoms",
                 scat_density=20, phantom_bounds=((None, None), (None, None), (None, None)), timestep=1,
                 rng_seed=0, delta_xyz=(0, 0, 0)):
        self.nodesdynfile = nodesdynfile
        self.dispdatfile = dispdatfile
        self.phantomout = phantomout
        self.scat_density = scat_density
        self.phantom_bounds = phantom_bounds
        self.timestep = timestep
        self.rng_seed = rng_seed
        self.delta_xyz = delta_xyz

        #self.load_nodeIDcoords()
        #self.read_dispdat_header()
        #self.calc_n_scats()
        #self.create_scatterers()
        #self.rigid_translate_scatterers()


    def load_nodeIDcoords(self):
        """read in node IDs and x, y, z coordinates from nodes.dyn mesh file

        """
        try:
            from fem.mesh.fem_mesh import load_nodeIDs_coords
        except ImportError:
            print('ERROR: Problem importing fem.mesh.fem_mesh.load_nodeIDs_coords; check PYTHONPATH.')

        self.nodeIDcoords = load_nodeIDs_coords(self.nodesdynfile)


    def read_dispdat_header(self):
        """read in header from disp.dat.xz (or whatever disp.dat binary file)

        header:
            num_nodes
            num_dims
            num_timesteps
        """
        try:
            from fem.post.create_res_sim_mat import read_header
        except ImportError:
            print('ERROR: Problem importing fem.post.create_res_sim_mat.read_header; check PYTHONPATH.')

        self.dispdat_header = read_header(self.dispdatfile)

    def calc_n_scats(self):
        """" N (int) - number of scatterers in the model volume"""
        # Deal with None case in phantom bounds still!

        trackingvolume = np.abs(self.phantom_bounds[0][1] - self.phantom_bounds[0][0]) *\
            np.abs(self.phantom_bounds[1][1] - self.phantom_bounds[1][0]) *\
            np.abs(self.phantom_bounds[2][1] - self.phantom_bounds[2][0])

        return np.round(trackingvolume*self.scat_density , decimals = 6)


    def create_scatterers(self):
        """
        create scatterrers within phantom_bounds using explicitly-seeded RNG
        Using the explicit RNG seed ensures identical scatterer location in subsequent runs if needed.
        """
        # Deal with None case in phantom bounds still!

        np.random.seed(self.rng_seed)
        scatterers = np.random.random((self.calc_n_scats(), 3))

        scatterers[:, 0] = scatterers[:, 0] * (self.phantom_bounds[0][1] - self.phantom_bounds[0][0]) + \
            self.phantom_bounds[0][0]
        scatterers[:, 1] = scatterers[:, 1] * (self.phantom_bounds[1][1] - self.phantom_bounds[1][0]) + \
            self.phantom_bounds[0][0]
        scatterers[:, 2] = scatterers[:, 2] * (self.phantom_bounds[2][1] - self.phantom_bounds[2][0]) + \
            self.phantom_bounds[0][0]

        """
        === ORIGINAL MATLAB CODE ===
        XX rng(PPARAMS.seed);
        XX scatterers=rand(PPARAMS.N,3);
        scatterers(:,1) = scatterers(:,1) * (PPARAMS.xmax - PPARAMS.xmin) + PPARAMS.xmin;
        scatterers(:,2) = scatterers(:,2) * (PPARAMS.ymax - PPARAMS.ymin) + PPARAMS.ymin;
        scatterers(:,3) = scatterers(:,3) * (PPARAMS.zmax - PPARAMS.zmin) + PPARAMS.zmin;
       """
        return scatterers


    def rigid_translate_scatterers(self):
        """add rigid displacement to scatterers before adding FEM-displacements

        === ORIGINAL MATLAB CODE ===
        scatterers = scatterers + (ones(PPARAMS.N,1) * PPARAMS.delta);
        """
        scatterers = self.create_scatterers + (np.ones((self.calc_n_scats(), 1))* self.delta_xyz)
        return scatterers

    """
    def save_phantom(self):
        save phantom for specific timestep to HDF5 format file

       
        import h5py

        h5out = h5py.File('{}.mat'.format(self.phantomout, self.timestep), 'a')

        h5out.create_group('timestep{03d}'.format(self.timestep))
        h5out.attrs('delta_xyz') = self.delta_xyz
        h5out.attrs('units') = 'meters'
        h5out.create_dataset('positions', data=phantom.positions, dtype='float')
        h5out.create_dataset('amplitudes', data=phantom.amplitudes, dtype='float')

        h5out.close()


FD_RATIO=0.01;  % What to mutiply dyna units by (cm) to
			    % get field units (m), here 100cm*0.01=1m


if(exist(ZDISPFILE, 'file') == 0),
    error(sprintf('%s does not exist.', ZDISPFILE));
else
    zdisp_fid = fopen(ZDISPFILE, 'r');
end

word_size = 4;
header_bytes = 3*word_size;
first_timestep_words = NUM_NODES*NUM_DIMS;
first_timestep_bytes = NUM_NODES*(NUM_DIMS)*word_size
timestep_bytes = NUM_NODES*(NUM_DIMS-1)*word_size

% Get the displacement matricies
disp(sprintf('Extracting displacements for timestep %d...',t));
if (t == 1) || LEGACY_NODES
    
    % extract the zdisp values for the appropriate time step
    fseek(zdisp_fid,header_bytes+first_timestep_bytes*(t-1),-1);
    zdisp_slice = fread(zdisp_fid,first_timestep_words,'float32');
    zdisp_slice = double(reshape(zdisp_slice,NUM_NODES,NUM_DIMS));
    node_readout = zdisp_slice(:,1);
else
    
    % extract the zdisp values for the appropriate time step
    fseek(zdisp_fid,header_bytes+first_timestep_bytes+timestep_bytes*(t-2),-1);
    zdisp_slice = fread(zdisp_fid,NUM_NODES*(NUM_DIMS-1),'float32');
    zdisp_slice = double(reshape(zdisp_slice,NUM_NODES,(NUM_DIMS-1)));
    zdisp_slice = [node_readout zdisp_slice];
end

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
"""


    def my_interpn(self, x, y, z, data, pts):
        """3D interpolation

        :param x: np.ndarray vectors of x coordinates
        :param y: np.ndarray vectors of x coordinates
        :param z: np.ndarray vectors of x coordinates
        :param data: np.ndarray of all data, size dim(x),dim(y),dim(z)
        :param pts: np.ndarray of coordinates of interp locations
        :returns: interp points
        """
        import numpy as np
        from scipy.interpolate import RegularGridInterpolator

        my_interp = RegularGridInterpolator((x, y, z), data)
        return np.around(my_interp(pts), decimals=6)

""""
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
rng(PPARAMS.seed);
phantom.amplitude = PPARAMS.rand_scat_amp .* randn(size(scatterers,1),1);


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
"""


if __name__ == "__main__":
    main(None)
