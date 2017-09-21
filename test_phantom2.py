def main():
    test_zerotest()
    test_onestest()
    test_lineartest()


def f1(x, y, z):
    # Zero matrix data
    return 0*x + 0*y + 0*z


def f2(x, y, z):
    # Ones matrix data
    return 0*x + 0*y + 0*z + 1


def f3(x, y, z):
    # Linear data
    return x + y + z


def test_zerotest():
    import numpy as np
    from phantom2 import my_interpn
    x = np.linspace(-2, 2, 5)
    y = np.linspace(-2, 2, 5)
    z = np.linspace(-2, 2, 5)

    data = f1(*np.meshgrid(x, y, z, indexing='ij', sparse=True))
    pts = np.array([[1, 0, 0], [0.5, 0.5, 0.5], [-1.5, 0.3, 1.7]])

    # print(my_interpn(x, y, z, data, pts))
    assert my_interpn(x, y, z, data, pts)[0] == 0
    assert my_interpn(x, y, z, data, pts)[1] == 0
    assert my_interpn(x, y, z, data, pts)[2] == 0


def test_onestest():
    import numpy as np
    from phantom2 import my_interpn
    x = np.linspace(-2, 2, 5)
    y = np.linspace(-2, 2, 5)
    z = np.linspace(-2, 2, 5)

    data = f2(*np.meshgrid(x, y, z, indexing='ij', sparse=True))
    pts = np.array([[1, 0, 0], [0.5, 0.5, 0.5], [-1.5, 0.3, 1.7]])

    # print(my_interpn(x, y, z, data, pts))
    assert my_interpn(x, y, z, data, pts)[0] == 1
    assert my_interpn(x, y, z, data, pts)[1] == 1
    assert my_interpn(x, y, z, data, pts)[2] == 1


def test_lineartest():
    import numpy as np
    from phantom2 import my_interpn
    x = np.linspace(-2, 100, 5)
    y = np.linspace(-2, 2, 5)
    z = np.linspace(-2, 2, 5)

    data = f3(*np.meshgrid(x, y, z, indexing='ij', sparse=True))
    pts = np.array([[1, 0, 0], [0.5, 0.5, 0.5], [-1.5, 0.3, 1.7]])

    # print(my_interpn(x, y, z, data, pts))
    assert my_interpn(x, y, z, data, pts)[0] == 1
    assert my_interpn(x, y, z, data, pts)[1] == 1.5
    assert my_interpn(x, y, z, data, pts)[2] == 0.5


if __name__ == "__main__":
    main()
