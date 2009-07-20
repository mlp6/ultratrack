function [p]=uf_phantom_struct(AxialMin,AxialSpan,AxialSpacing,LateralOffset,LateralSpan,LateralSpacing);
%
% [p]=uf_phantom_struct(AxialMin,AxialSpan,AxialSpacing,LateralOffset,LateralSpan,LateralSpacing);
% 
% Creates a rectangular grid-of-point-targets phantom.
%
% Called with:
%
% AxialMin is the distance from the transducer to 
% the nearest point in the axial direction.
%
% AxialSpan is the range axial distance from the 
% closest to the most distant scatterer
%
% AxialSpacing is the seperation between points in 
% the axial direction.
%
% LateralOffest is lateral distance between the 
% transducer center and the phantom center
%
% LateralSpan is the width of the phantom
%
% LateralSpacing is the separation between points in the lateral direction. 
%
% Returns structure p:
%
% p.position:  An Mx3 matrix of scatter positions.  
% Each row gives the position of a single scatterer 
% in the form [x y z].
%
% p.amplitude: An Mx1 matrix of point target amplitudes.

[z,x]=meshgrid(AxialMin:AxialSpacing:AxialSpan,[(-LateralSpan/2):LateralSpacing:(LateralSpan/2)]+LateralOffset);

x=x(:);
z=z(:);

p.position=[x zeros(size(x)) z];

p.amplitude=ones(size(x));


