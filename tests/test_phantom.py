from phantom import Phantom
import numpy as np

def main():
    p = Phantom(scat_density=1, phantom_bounds=((0, 5), (0, 5), (0, 5)))
    test_createscatterers(p)
    test_calcnscats(p)
    test_interpn(p)
    pass


def test_createscatterers(p):
    scatterers = p.create_scatterers()
    assert np.all(scatterers[:, 0]) < p.phantom_bounds[0][1]


def test_calcnscats(p):
    assert p.calc_n_scats() == 125


def test_interpn(p):
    test_zerotest(p)
    test_onestest(p)
    test_lineartest(p)


def f1(x, y, z):
    # Zero matrix data
    return 0*x + 0*y + 0*z


def f2(x, y, z):
    # Ones matrix data
    return 0*x + 0*y + 0*z + 1


def f3(x, y, z):
    # Linear data
    return x + y + z


def test_zerotest(p):
    x = np.linspace(-2, 2, 5)
    y = np.linspace(-2, 2, 5)
    z = np.linspace(-2, 2, 5)

    data = f1(*np.meshgrid(x, y, z, indexing='ij', sparse=True))
    pts = np.array([[1, 0, 0], [0.5, 0.5, 0.5], [-1.5, 0.3, 1.7]])

    # print(my_interpn(x, y, z, data, pts))
    assert p.my_interpn(x, y, z, data, pts)[0] == 0
    assert p.my_interpn(x, y, z, data, pts)[1] == 0
    assert p.my_interpn(x, y, z, data, pts)[2] == 0


def test_onestest(p):
    x = np.linspace(-2, 2, 5)
    y = np.linspace(-2, 2, 5)
    z = np.linspace(-2, 2, 5)

    data = f2(*np.meshgrid(x, y, z, indexing='ij', sparse=True))
    pts = np.array([[1, 0, 0], [0.5, 0.5, 0.5], [-1.5, 0.3, 1.7]])

    # print(my_interpn(x, y, z, data, pts))
    assert p.my_interpn(x, y, z, data, pts)[0] == 1
    assert p.my_interpn(x, y, z, data, pts)[1] == 1
    assert p.my_interpn(x, y, z, data, pts)[2] == 1


def test_lineartest(p):
    x = np.linspace(-2, 100, 5)
    y = np.linspace(-2, 2, 5)
    z = np.linspace(-2, 2, 5)

    data = f3(*np.meshgrid(x, y, z, indexing='ij', sparse=True))
    pts = np.array([[1, 0, 0], [0.5, 0.5, 0.5], [-1.5, 0.3, 1.7]])

    # print(my_interpn(x, y, z, data, pts))
    assert p.my_interpn(x, y, z, data, pts)[0] == 1
    assert p.my_interpn(x, y, z, data, pts)[1] == 1.5
    assert p.my_interpn(x, y, z, data, pts)[2] == 0.5


if __name__ == "__main__":
    main()