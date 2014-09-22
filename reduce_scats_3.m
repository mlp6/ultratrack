function [phantom]=reduce_scats_3(phantom, tx, rx, minDB, gridspacing)
% function [phantom]=reduce_scats_3(phantom, tx, rx, minDB, gridspacing))
%
% Uses a coarse simulated grid of test points to calculate the two-way beam
% profile, and returns the phantom structure with only the points expected
% to have a significant contribution on the current beam
%
% INPUTS:   phantom (struct) - includes phantom.positions (m)
%           tx, rx pointers to Transmit and Receive apertures
%           minDB - minimum dB level for including scatterers (negative)
%           gridspacing [x y z] spacing of test points for performing
%           interpolation
%
% OUTPUTS:  newphantom (struct) - same as the input, but only with entries
%                              that fall w/i the tx-rx beam
%
% Called from uf_scan.m
%
% Mark Palmeri (2010-04-30)

% compute the radius from the ROE axis of symmetry (x = y = 0) for all
% scatterers

% Peter Hollender (2012.11.14)
% Added TX and RX simulation via calc_scat to get a low-res estimate of the
% transmit-receive beam profile from the sum of the envelope calculated for
% a scatterer at each grid position. Once the profile is calculated,
% nearest neighbor 3D interpolation estimates the contribution of each
% scatterer, and uses the cutoff to eliminate insignificant points.

debug_fig = 0;

if ~exist('gridspacing','var')
    gridspacing = [1e-3 1e-3 1e-3];
end
if ~exist('minDB','var')
    minDB = -20;
end

fprintf('Reducing Scatter Field to %0.0f dB limit...', minDB);

latmin = phantom.PPARAMS.ymin*1e-2; % X-Y SWAPPED per DYNA specification
latmax = phantom.PPARAMS.ymax*1e-2;
elevmin = phantom.PPARAMS.xmin*1e-2;
elevmax = phantom.PPARAMS.xmax*1e-2;
axmin = phantom.PPARAMS.zmin*1e-2;
axmax = phantom.PPARAMS.zmax*1e-2;

x = latmin:gridspacing(1):latmax;
y = elevmin:gridspacing(2):elevmax;
z = axmin:gridspacing(3):axmax;

% center points on range
x = x-mean(x) + 0.5*(latmin+latmax);
y = y-mean(y) + 0.5*(elevmin+elevmax);
z = z-mean(z) + 0.5*(axmin+axmax);

[Z X Y] = ndgrid(-1*z,x,y);
V = 0*X;
for i = 1:length(X(:));
[v, starttime] = calc_scat(tx,rx,[X(i) Y(i) Z(i)],1);
V(i) = sum(abs(hilbert(v))); %A rough estimate of scatterer contribution - probably could be improved
end

V = convn(V,ones(3,3,3)./9,'same');
V = db(V./max(V(:)));

 P = [2 1 3];
   X = permute(X, P);
   Y = permute(Y, P);
   Z = permute(Z, P);
   V = permute(V, P);

V1 = interp3(Z,X,Y,V,double(phantom.position(:,3)),double(phantom.position(:,1)),double(phantom.position(:,2)),'nearest');

keepers = V1>minDB | phantom.amplitude>1;

fprintf('done (%0.1f%% reduction)\n', 100*(1-length(keepers)/length(phantom.amplitude)));

if debug_fig
    figure(5);
    cla
    plot3(1e3*phantom.position(:,1),1e3*phantom.position(:,2),1e3*phantom.position(:,3),'r.','Markersize',1)
end

phantom.position = phantom.position(keepers,:);
phantom.amplitude = phantom.amplitude(keepers,:);

if debug_fig
    hold on
    plot3(1e3*(phantom.position(:,1)),...
        1e3*phantom.position(:,2),...
        1e3*phantom.position(:,3),'b.')
    xlabel('x (mm)')
    ylabel('y (mm)')
    zlabel('z (mm)')
    axis equal
    axis ij
    axis(1e3*[latmin latmax elevmin elevmax -1*axmax -1*axmin]);
    drawnow
    hold off
end
