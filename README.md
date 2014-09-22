Ultrasonic Tracking Simulation Tools
====================================

Field II ultrasonic displacement tracking code using FEM displacement fields.
The 3D nodal displacement data from the FEM sims are used to translate a volume
of acoustic scattereres, and synthetic RF data is generated for each time step
using the transducer parameters defined in \texttt{ultratrack\_driver.m}.

Please considering citing this work if you use this code in your work: 

*Palmeri ML, McAleavey SA, Trahey GE, Nightingale KR. "Ultrasonic Tracking of
Acoustic Radiation Force-Induced Displacements in Homogeneous Media," IEEE
UFFC, 53(7): 1300-1313, 2006.*

Installation
============
 * Add the ultratrack repository your Matlab path.  One approach is to add the
   following to ```$HOME/matlab/startup.m```:
   ```
   addpath('PATH/TO/GIT/CLONED/ultratrack');
   ```
 * There is a ```probes``` submodule available to restricted institutions.  If
   you do not have access to that repository, then you can use
   ```field/linear.m``` and ```field/curvilinear.m``` as starting points to
   define transducers.  If you do have access, then you can initialize the
   submodule using ```git submodule init``` followed by ```git submodule
   update```.

Testing
=======

Coming soon
