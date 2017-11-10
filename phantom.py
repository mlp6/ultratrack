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
        Y - lateral dimension (0 -> positive for quarter symmetry)
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
    :param nodout: nodout file
    """

    def __init__(self, nodesdynfile="nodes.dyn", dispdatfile="disp.dat.xz", phantomout="phantoms",
                 scat_density=20, phantom_bounds=((None, None), (None, None), (None, None)), timestep=1,
                 rng_seed=0, delta_xyz=(0, 0, 0), nodout="nodout"):
        self.nodesdynfile = nodesdynfile
        self.dispdatfile = dispdatfile
        self.phantomout = phantomout
        self.scat_density = scat_density
        self.phantom_bounds = phantom_bounds
        self.timestep = timestep
        self.rng_seed = rng_seed
        self.delta_xyz = delta_xyz
        self.nodout = nodout

        self.nodeIDcoords = None
        self.dispdat_header = None
        self.minmaxs = None
        self.lims = None
        self.n_scats = None
        self.scatterers = None
        self.translate_scatterers = None
        self.dispdat = None
        self.sdispdat = None

        self.load_nodeIDcoords()
        self.read_dispdat_header()
        self.calc_n_scats()
        self.create_scatterers()
        self.rigid_translate_scatterers()
        self.make_dispdata()
        self.make_interp()


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
        """create scatterrers within phantom_bounds using explicitly-seeded RNG
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
        """create displacement data in [dx, dy, dz] format

        """
        try:
            from fem.post.create_disp_dat import parse_line
        except ImportError:
            print('ERROR: Problem importing fem.post.create_disp_dat.parse_line; check PYTHONPATH.')

        nodout = open(self.nodout, "r")
        n = nodout.readlines()
        raw_data = []

        # TODO: make dynamic text read in
        for i in range(8, 18):
            line = n[i]
            raw_data.append(parse_line(line))

        dispdata_complete = []

        disp_iter = iter(raw_data)
        for node in self.nodeIDcoords:
            if any(item[0] for item in raw_data == node['id']):
                thisdisp = next(disp_iter)
                dispdata_complete.append([thisdisp[1], thisdisp[2], thisdisp[3]])
            else:
                dispdata_complete.append([0, 0, 0])

        self.dispdat = dispdata_complete

    def make_interp(self):
        """3D interpolation

        """

        xinterp = np.interp([item[0] for item in self.scatterers], self.nodeIDcoords['x'], [item[0] for item in self.dispdat])
        yinterp = np.interp([item[1] for item in self.scatterers], self.nodeIDcoords['y'], [item[1] for item in self.dispdat])
        zinterp = np.interp([item[2] for item in self.scatterers], self.nodeIDcoords['x'], [item[2] for item in self.dispdat])

        self.sdispdat = []
        for i in range(len(xinterp)):
            self.sdispdat.append([xinterp[i], yinterp[i], zinterp[i]])


if __name__ == "__main__":
    main(None)
