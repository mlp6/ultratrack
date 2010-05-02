function [pos, amp] = calc_diffuse(lambda,focalPoint,arraywidth,axres,scatdens, cystdiam, axroisz, latroisz);
% function to generate an array for input to calc scat - the 
% spatial locations are random, as are the amplitudes, and the 
% scatterer density is input, and using crude defs of res
% cell (lambda z/D, etc), I compute the total number of scatterers
% required, and then put them in a volume that is roisz^2
% centered on the focal point - the cyst is cystdiam in diam.

% create general scatterers
% seed the random num. generator
rand('state',sum(100*clock)) 

% compute res cell dimensions
latres=lambda*focalPoint(3)/arraywidth;
% assume a 4 cycle pulse as a ballpark
numResCells=(axroisz*latroisz)/(latres*axres);

% now we can compute total num. of scatterers req'd.
N=floor(scatdens*numResCells);
x=(rand(N,1)-.5)*latroisz; % center the lat. dim on 0
z=(rand(N,1)-.5)*axroisz;  % center the ax. dim on 0
y=zeros(size(x));

% amplitudes w/gaussian distrib.
amp=randn(N,1);
positions=[x y z];

% now go through and remove all points w/in cystdiam of center
[i j]=find(sqrt(x.^2+y.^2+z.^2)>(cystdiam/2));
pos=positions(i,:);
amp=amp(i);
