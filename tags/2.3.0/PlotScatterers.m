function []=PlotScatteres(TimeStep,ScalingFactor);
%function []=PlotScatteres(TimeStep,ScalingFactor);
%
% Plot the deformed scatterer fields that using the FEM output.
% This function assumes that the files phantom###.mat are
% available in the CWD.
%
% INPUTS:
% TimeStep (integer) - what time step do you want to look at
% (based on the FEM d3plot time interval)
% ScalingFactor (float) - value to scale the z-deformations by in
% the deformation plots
%
% OUTPUTS:  None by default.
%
% Mark 07/05/05
%

% first, we need to load in the reference frame, which is
% always named phantom001.mat.  we'll also check to make sure
% that file is available
if(exist('phantom001.mat') ~= 0),
	load phantom001.mat;
else,
	disp('PROBLEM - phantom001.mat does not exist');
	disp('FIX - to work in the directory containing the phantom###.mat files');
	return;
end;

% the phantom###.mat files contain a structure called phantom,
% that has a variable position within it that contains the x,y,z
% coordinates in Field II convention (x = lateral, y =
% elevation, z = axial)
Xref = phantom.position(:,1);
Yref = phantom.position(:,2);
Zref = phantom.position(:,3);

% next, load in the new scatterer position for the desired time
% step (as specified by the TimeStep input)
%
% to do this, we need to tell matlab how many 0's to prepend to
% the specified TimeStep since the phantom file always use 3
% digits to specify the phantom files
if(TimeStep < 10),
		FileName = sprintf('phantom00%i.mat',TimeStep);
elseif(TimeStep < 100),
		FileName = sprintf('phantom0%i.mat',TimeStep);
else,
		FileName = sprintf('phantom%i.mat',TimeStep);
end;	

% check to make sure the desired time step exists, and if so,
% load it in!
if(exist(FileName)~=0),
	load(FileName);
else,
	disp(sprintf('PROBLEM - %s does not exist',FileName));
	return;
end;

% assign the deformed scatterer positions to new vectors to
% compare with the reference
X = phantom.position(:,1);
Y = phantom.position(:,2);
Z = phantom.position(:,3);

% plot the deformed scatterer positions relative to the
% reference scatterer positions
figure;
plot3(Xref,-Yref,-Zref,'o');
hold on
% scale the deformation of the scatteres in the z-dimension by
% the user-specified value
h=plot3(X,-Y,-Z-(abs(Z-Zref)*ScalingFactor),'rx');

% plot only the z-displacements w/o any scaling
figure;
plot3(Xref,Yref,Z-Zref,'rx');
