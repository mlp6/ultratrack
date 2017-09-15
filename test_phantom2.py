# Test cases to test phantom2.py

import numpy as np
from phantom2 import my_interpn


def f1(x, y, z):
    # Zero matrix data
    return 0*x + 0*y + 0*z


def f2(x, y, z):
    # Ones matrix data
    return 0*x + 0*y + 0*z + 1


def f3(x, y, z):
    # Linear data
    return x + y + z


def test_1():
    x = np.linspace(-2, 2, 5)
    y = np.linspace(-2, 2, 5)
    z = np.linspace(-2, 2, 5)

    data = f1(*np.meshgrid(x, y, z, indexing='ij', sparse=True))
    pts = np.array([[1, 0, 0], [0.5, 0.5, 0.5], [-1.5, 0.3, 1.7]])

    # print(my_interpn(x, y, z, data, pts))
    assert my_interpn(x, y, z, data, pts)[0] == 0
    assert my_interpn(x, y, z, data, pts)[1] == 0
    assert my_interpn(x, y, z, data, pts)[2] == 0
    print("Test1 pass")

def test_2():
    x = np.linspace(-2, 2, 5)
    y = np.linspace(-2, 2, 5)
    z = np.linspace(-2, 2, 5)

    data = f2(*np.meshgrid(x, y, z, indexing='ij', sparse=True))
    pts = np.array([[1, 0, 0], [0.5, 0.5, 0.5], [-1.5, 0.3, 1.7]])

    # print(my_interpn(x, y, z, data, pts))
    assert my_interpn(x, y, z, data, pts)[0] == 1
    assert my_interpn(x, y, z, data, pts)[1] == 1
    assert my_interpn(x, y, z, data, pts)[2] == 1
    print("Test2 pass")


def test_3():
    x = np.linspace(-2, 100, 5)
    y = np.linspace(-2, 2, 5)
    z = np.linspace(-2, 2, 5)

    data = f3(*np.meshgrid(x, y, z, indexing='ij', sparse=True))
    pts = np.array([[1, 0, 0], [0.5, 0.5, 0.5], [-1.5, 0.3, 1.7]])

    # print(my_interpn(x, y, z, data, pts))
    assert my_interpn(x, y, z, data, pts)[0] == 1
    assert my_interpn(x, y, z, data, pts)[1] == 1.5
    assert my_interpn(x, y, z, data, pts)[2] == 0.5
    print("Test3 pass")

test_1()
test_2()
test_3()