# Separate Phantom2 Class script, will eventually be integrated with phantom.py

import numpy as np
from scipy.interpolate import RegularGridInterpolator


def my_interpn(x, y, z, data, pts):
    # Input x, y, z - all np.ndarray vectors of xyz coordinates
    # Input data - a np.ndarray of all data, size dim(x),dim(y),dim(z)
    # Input pts - a np.ndarray of coordinates of interp locations

    my_interp = RegularGridInterpolator((x, y, z), data)
    return np.around(my_interp(pts), decimals=6)
