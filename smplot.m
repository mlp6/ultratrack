function smplot(phantom1,phantom2,gain);
%
% SMPLOT
% 
% Plots 3d line segments in space representing scatterer motion
% usage
%
% Usage smplot(phantom1,phantom2,gain);
%
% where phantom1 and phantom2 are two uri/field phantom structures.
% GAIN is how much to magnify the scatterer motion
%
% the result is a 3D plot of the motion of each scatterer.  Note that
% scatterers with very small motion may not appear in the plot.  More 
% gain helps with this.  
%


delta=phantom2.position-phantom1.position;
x=phantom1.position(:,1);
y=phantom1.position(:,2);
z=phantom1.position(:,3);

dx=delta(:,1);
dy=delta(:,2);
dz=delta(:,3);

plot3([x';x'+gain*dx'],[y';y'+gain*dy'],[z';z'+gain*dz'],'k');
axis ij;
xlabel('x');ylabel('y');zlabel('z');

