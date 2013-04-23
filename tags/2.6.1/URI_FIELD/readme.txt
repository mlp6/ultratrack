
URI/Field II README.TXT

If you're reading this, you've succeeded in unziping the URI/Field II files.  
Now what?

Your best bet is to look over the manual, URI_Field_tools_manual.pdf, in the 
newly created documentation directory.  The manual explains what URI/Field II 
is about, how to install it, how to use it, and gives an explaination of all 
the Matlab command-line code.   


If you won't read the manual, then here's what you need to do:

Make sure you have Field II and the UC Davis URI-OPT installed.  At last check,
these were avaiable from 
http://www.es.oersted.dtu.dk/staff/jaj/field/ (Field II) 
and 
http://www.bme.ucdavis.edu/URI (URI-OPT).  
Be sure the directories where these files are located are in the Matlab path.  
Type help addpath in Matlab if you need help.  

Add the URI/Field II directory (probably the one where you found this file) 
to the Matlab path.  You can do that with the line 
addpath(genpath(PATHNAME)); 
in Matlab.  If you put this line in your startup.m file you won't have to 
remember to do it every time you start Matlab.  

In Matlab, type uf_gui and hit enter.  You should see the URI/Field II window.  
If not, be sure that Field II is installed and in the Matlab path.  Make sure
that URI/Field II is in the path (including subdirectories, which the 
addpath(genpath(PATHNAME)) would have included).  

Read over the file scan_demo.m.  This shows how to use the command line tools 
to perform a simple scan simulation.  

Now go read the manual. 


