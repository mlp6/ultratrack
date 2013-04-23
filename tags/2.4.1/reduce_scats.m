function [phantom]=reduce_scats(phantom,scan_lat_pos,search_radius)
% function [phantom]=reduce_scats(phantom,scan_lat_pos,search_radius)
%
% INPUTS:   phantom (struct) - includes phantom.positions (m)
%           scan_lat_pos (single) - scan lateral position (m)
%           search_radius (single) - largest -6 dB radius in the DOF (m)
%
% OUTPUTS:  newphantom (struct) - same as the input, but only with entries
%                              that fall w/i the search radius
%
% Called from uf_scan.m
%
% Mark Palmeri (2010-04-30)

% compute the radius from the ROE axis of symmetry (x = y = 0) for all scatterers
%disp('---------- reduce_scats.m output ----------');
%disp(sprintf('Search Radius: %.2f mm',search_radius*1e3));
%disp(sprintf('Lateral Position: %.2f mm',scan_lat_pos*1e3));
phantom_radii = sqrt((phantom.position(:,1)-scan_lat_pos).^2 + phantom.position(:,2).^2);

keepers = find(phantom_radii <= search_radius);
phantom.position = phantom.position(keepers,:);
phantom.amplitude = phantom.amplitude(keepers,:);

%disp(sprintf('Scatterer Ratio: %.2f',length(keepers)/length(phantom_radii)));
%disp(sprintf('Lateral Range: %.3f - %.3f mm',min(phantom.position(:,1))*1e3,max(phantom.position(:,1))*1e3));
%disp('-------------------------------------------');
