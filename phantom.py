import numpy as np
import h5py
from scipy.interpolate import RegularGridInterpolator

def main(timesteps):
    # for t in timesteps:
    p = Phantom()
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

        self.nodeIDcoords = None
        self.dispdat_header = None
        self.n_scats = None
        self.scatterers = None
        self.translate_scatterers = None

        self.load_nodeIDcoords()
        self.read_dispdat_header()
        self.calc_n_scats()
        self.create_scatterers()
        self.rigid_translate_scatterers()

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
        """" N (int) - number of scatterers in the model volume

        """
        i = 0
        minmaxs = [min(self.nodeIDcoords['x']), max(self.nodeIDcoords['x']),
                   min(self.nodeIDcoords['y']), max(self.nodeIDcoords['y']),
                   min(self.nodeIDcoords['z']), max(self.nodeIDcoords['z'])]
        lims = list()

        # Deal with None cases
        for item in self.phantom_bounds:
            for num in item:
                if num is None:
                    lims.append(minmaxs[i])
                else:
                    lims.append(num)
                i = i + 1

        tracking_volume = np.abs(lims[1] - lims[0]) *\
            np.abs(lims[3] - lims[2]) *\
            np.abs(lims[5] - lims[4])

        self.minmaxs = minmaxs
        self.lims = lims
        self.n_scats = int(np.round(tracking_volume*self.scat_density , decimals = 6))

    def create_scatterers(self):
        """
        create scatterrers within phantom_bounds using explicitly-seeded RNG
        Using the explicit RNG seed ensures identical scatterer location in subsequent runs if needed.

        """

        np.random.seed(self.rng_seed)
        scatterers = np.random.random((self.n_scats, 3))
        lims = self.lims

        scatterers[:, 0] = scatterers[:, 0] * (lims[1] - lims[0]) + lims[0]
        scatterers[:, 1] = scatterers[:, 1] * (lims[3] - lims[2]) + lims[2]
        scatterers[:, 2] = scatterers[:, 2] * (lims[5] - lims[4]) + lims[4]
        self.scatterers = scatterers

    def rigid_translate_scatterers(self):
        """" Moves scatterers according to delta_xyz

                """
        self.translate_scatterers = np.random.random((self.n_scats, 3))
        self.translate_scatterers[:, 0] = self.scatterers[:, 0] + (np.ones(self.n_scats) * self.delta_xyz[0])
        self.translate_scatterers[:, 1] = self.scatterers[:, 1] + (np.ones(self.n_scats) * self.delta_xyz[1])
        self.translate_scatterers[:, 2] = self.scatterers[:, 2] + (np.ones(self.n_scats) * self.delta_xyz[2])

    def save_phantom(self):
        """save phantom for specific timestep to HDF5 format file

        """

        h5out = h5py.File('{}.mat'.format(self.phantomout, self.timestep), 'a')
        h5out.attrs()

        h5out.create_group('timestep{03d}'.format(self.timestep))
        h5out.attrs.__setitem__('delta_xyz', self.delta_xyz)
        h5out.attrs.__setitem__('units', 'meters')

        # What data should be stored in save_phantom? Positions and amplitudes? Come back to this later
        # h5out.create_dataset('positions', data=phantom.positions, dtype='float')
        # h5out.create_dataset('amplitudes', data=phantom.amplitudes, dtype='float')

        h5out.close()

    def make_dispdata(self):
        try:
            from fem.post.create_res_sim_mat import create_zdisp
        except ImportError:
            print('ERROR: Problem importing fem.post.create_res_sim_mat.read_header; check PYTHONPATH.')

        #? create_zdisp(self.nodeIDcoords['id'], )
    """
    
    Make [dx dy dz] matrices of the displacement of all of the nodes with the create_res_sym.py and create_z_disp from
    fem path
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
    

    """


if __name__ == "__main__":
    main(None)
