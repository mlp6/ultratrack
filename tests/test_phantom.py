"""test_phantom.py
"""

from ultratrack.phantom import Phantom
import numpy as np
import os

myPath = os.path.dirname(os.path.abspath(__file__))
nodefile = '%s/nodes2.dyn' % myPath
dispfile = '%s/disp.dat.xz' % myPath
nodoutfile = '%s/nodout2' % myPath

# Make disp.dat.xz file
from fem.post.create_disp_dat import create_dat, parse_line
create_dat(dispout="disp.dat.xz", nodout="nodout")

# Make instance of Phantom class
p = Phantom(scat_density=10,nodesdynfile=nodefile, dispdatfile = dispfile, delta_xyz = (10, 5, 100), nodout= nodoutfile)

def test_mytest():
    print(p.sdispdat)
    pass

def test_load_nodeIDcoords():
    assert p.nodeIDcoords != None
    assert len(p.nodeIDcoords['x']) == len(p.nodeIDcoords['y'])
    assert p.nodeIDcoords[0][1] == -1


def test_read_dispdat_header():
    assert p.dispdat_header != None


def test_calc_n_scats():
    assert p.n_scats == 10


def test_create_scatterers():
    assert len(p.scatterers) != None


def test_rigid_translate_scatterers():
    assert len(p.translate_scatterers) != None
    assert p.translate_scatterers[0][0] == p.scatterers[0][0] + p.delta_xyz[0]


def test_make_dispdata():
    assert len(p.dispdat) != None


def test_make_interp():
    assert len(p.sdispdat) != None
