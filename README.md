Ultrasonic Tracking Simulation Tools
====================================
[Field II](http://field-ii.dk) ultrasonic displacement tracking code using FEM
displacement fields.  The 3D nodal displacement data from the FEM sims are used
to translate a volume of acoustic scattereres, and synthetic RF data is
generated for each time step using the transducer parameters defined in
[driver.m](driver.m).

Please consider citing this work if you use this code in your work: 

[Palmeri ML, McAleavey SA, Trahey GE, Nightingale KR. "Ultrasonic Tracking of
Acoustic Radiation Force-Induced Displacements in Homogeneous Media," IEEE
UFFC, 53(7): 1300-1313, 2006.](http://www.ncbi.nlm.nih.gov/pubmed/16889337)

Installation
============
 * Add the ultratrack repository your Matlab path.  One approach is to add the
   following to ```$HOME/matlab/startup.m```:

   ```
   addpath('PATH/TO/GIT/CLONED/ultratrack');
   ```

* Siemens proprietary probe definitions can be cloned from the
  access-restricted repository: https://gitlab.oit.duke.edu/ultrasound/probes

   
   If you do have access, then you can initialize the submodule using:
   
   + ```git submodule init``` 
   + ```git submodule update```

Usage
=====
[ultra_driver.m](ultra_driver.m) is an example driver script for 1:1 scanning
with a linear array.

Testing
=======

Coming soon
