from setuptools import setup
import sys

if sys.version_info.major != 3 or (sys.version_info.major == 3 and
                                   sys.version_info.minor < 5):
    sys.exit('You must use python >=3.5')

setup(
    name='fem',
    packages=['ultratrack'],
    package_dir={'ultratrack': '.'},
    version='2.8.0',
    license='Apache v2.0',
    author='Mark Palmeri',
    author_email='mlp6@duke.edu',
    description='UltraTrack',
    keywords=['arfi', 'swei', 'fem', 'ultrasound'],
    long_description=open('README.md').read(),
    url='https://github.com/mlp6/ultratrack',
    download_url='https://github.com/mlp6/ultratrack/archive/v2.8.0.tar.gz',
    classifiers=[],
    install_requires=['h5py', 'ipython', 'jupyter', 'matplotlib', 'numpy',
                      'pytest', 'pytest-pep8', 'scipy', 'sphinx'],
)
