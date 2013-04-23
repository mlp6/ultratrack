function [out,ax,lat] = scan_convert(in,geometry,beamset,start_time)
%
% [out,ax,lat] = scan_convert(in,geometry,beamset,start_time)
%
% Converts A-line data and geometric information to a 
% scan-converted image
%
% start_time is a scalar (returned for example by uf_time_eq)
% which denotes the time corresponding to the rf first sample.
%
% To display a scan-converted image
%  
% 	imagesc(lat,ax,out);axis image; colormap(gray);
% 

% Version 0.91
% 7/23/03  Stephen McAleavey, Duke University BME
% 1/14/04  Stephen McAleavey - Adapted for URI

fs=geometry.field_sample_freq;
c=1540;



% If phased array scan...
if (strcmp(geometry.probe_type,'phased'))
% puts a border around the data equal to the min value of 
% the image data.  This is done so the scan-converted image 
% will be black outside of the sector - points in the output
% image outside the sector map to the closest point in the 
% input data, which will be this black border
min_in=min(in(:));
in=[min_in*ones(1,size(in,2));in;min_in*ones(1,size(in,2))];
in=[min_in*ones(size(in,1),1) in min_in*ones(size(in,1),1)];

% Conversions to radians and meters
apex=beamset.apex(2)/100;
min_phi=min(beamset.direction);
span_phi=max(beamset.direction)-min_phi;
max_phi=max(abs([min_phi,min_phi+span_phi]));

samples_per_aline=size(in,1); 	% Number of samples in an A-line
num_a_lines=size(in,2);		% Number of A-lines

%
% Set scan conversion pitch
%
inc=0.0001;

%
% Determine bounding box for scan data
%
x_min=-cos(max_phi)*apex;
x_max=samples_per_aline*(c/2)/fs-apex;
y_min=x_max*sin(min_phi);
y_max=x_max*sin(min_phi+span_phi);

% Create a grid of points in the output format
% x,y is output coordinate system
[x,y]=meshgrid(x_min:inc:x_max,y_min:inc:y_max);

% Find these points in the 'ducer r-theata (polar) system 
r=sqrt(x.^2+y.^2);
phi=atan2(y,x);
% Turns distances into times to determine correct a-line sample
% turns angle into appropriate scan line
u=( -start_time + (r+apex./cos(phi))/(c/2) )*fs;
v=((phi-min_phi)/span_phi)*(num_a_lines-1)+1;

% Limits to make sure you're in the input data
% note that points outside the actual input data get mapped
% to those border pixels created earlier
u=max(1,u);
u=min(u,samples_per_aline);
v=max(1,v);
v=min(v,num_a_lines);
u=floor(u);
v=floor(v);

% Allocate a little memory
out=zeros(size(u));

% Build the output image
for m=1:size(u,1);
	for n=1:size(u,2),
		out(m,n)=in(u(m,n),v(m,n));
		end;
	end;
out=out';
%imagesc(out);axis image;
% Make up lateral/axial coordinate vectors for imagesc
lat=(y_min:inc:y_max)*100;
ax=((x_min:inc:x_max)+apex)*100;
end; % if 'phased'




% If curvilinear array scan...
if (strcmp(geometry.probe_type,'curvilinear'))
% puts a border around the data equal to the min value of 
% the image data.  This is done so the scan-converted image 
% will be black outside of the sector - points in the output
% image outside the sector map to the closest point in the 
% input data, which will be this black border
min_in=min(in(:));
in=[min_in*ones(1,size(in,2));in;min_in*ones(1,size(in,2))];
in=[min_in*ones(size(in,1),1) in min_in*ones(size(in,1),1)];

% Conversions to radians and meters
apex=beamset.apex(2)/100;
min_phi=min(beamset.direction);
span_phi=max(beamset.direction)-min_phi;
max_phi=max(abs([min_phi,min_phi+span_phi]));

samples_per_aline=size(in,1); 	% Number of samples in an A-line
num_a_lines=size(in,2);		% Number of A-lines

%
% Set scan conversion pitch
%
inc=0.0002;

%
% Determine bounding box for scan data
%
x_min=-cos(max_phi)*apex;
x_max=samples_per_aline*(c/2)/fs-apex;
y_min=x_max*sin(min_phi);
y_max=x_max*sin(min_phi+span_phi);

% Create a grid of points in the output format
% x,y is output coordinate system
[x,y]=meshgrid(x_min:inc:x_max,y_min:inc:y_max);

% Find these points in the 'ducer r-theata (polar) system 
r=sqrt(x.^2+y.^2);
phi=atan2(y,x);
% Turns distances into times to determine correct a-line sample
% turns angle into appropriate scan line
u=( -start_time + (r+apex)/(c/2) )*fs;
v=((phi-min_phi)/span_phi)*(num_a_lines-1)+1;

% Limits to make sure you're in the input data
% note that points outside the actual input data get mapped
% to those border pixels created earlier
u=max(1,u);
u=min(u,samples_per_aline);
v=max(1,v);
v=min(v,num_a_lines);
u=floor(u);
v=floor(v);

% Allocate a little memory
out=zeros(size(u));

% Build the output image
for m=1:size(u,1);
	for n=1:size(u,2),
		out(m,n)=in(u(m,n),v(m,n));
		end;
	end;
out=out';
%imagesc(out);axis image;
% Make up lateral/axial coordinate vectors for imagesc
lat=(y_min:inc:y_max)*100;
ax=((x_min:inc:x_max)+apex)*100;
end; % if 'curvilinear'



%if linear array
% NEED TO ADD CODE FOR PARALLELOGRAM SCANNING!!!
if (strcmp(geometry.probe_type,'linear'))
lat=beamset.origin(:,1)*100;
ax=(c/2)*(start_time+(1:size(in,1))/fs)*100;
out=in;

end;	
