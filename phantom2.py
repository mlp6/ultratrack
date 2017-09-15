def my_interpn(x, y, z, data, pts):
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

