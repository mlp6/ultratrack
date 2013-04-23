function [geometry]=uf_txt_to_probe(filename);
%
% UF_TXT_TO_PROBE   Creates probe struct from probe text data file
%   function [probe]=uf_txt_to_probe(filename) returns a probe structure
%   that can be used for scan simulaton.  The string filename is the name
%   of a probe text file describing the geometric properties of the 
%   probe to be simulated.  The entries in the text file are in two
%   columns seperated by spaces, tabs, or an equal sign.  
%
%   Supported entries are
%       no_elements     Number of transducer elements
%       height          Elevational dimension of an individual element
%       width           Lateral dimension of an individual element
%       kerf            Space between elements
%       convex_radius   Radius of curlinear probe curvature (ignored for 
%                       other types) 
%       elv_focus       Depth of fixed focus supplied by transducer lens
%       probe_type      Types are 'linear','curvilinear', or 'phased'
%       no_sub_x        Number of mathematical elements per physical
%                       element, in lateral direction
%       no_sub_y        Same, elevational direction
%       f0              Transducer center frequency
%       bw              Fractional bandwidth, expressed as percentage of f0
%       phase           Phase of carrier relative to the pulse envelope
%       wavetype        'gaussian'
%
%   Other entries will be ignored with a warning.  Comments my be included
%   in the file by prefaceing with a % sign (Matlab style commenting)
%
% 10/21/2004, Stephen McAleavey, U. Rochester BME
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% updated to now also scan for no_elements_[x,y] and kerf_[x,y] for the matrix probes
% Mark Palmeri (mlp6@duke.edu), 2012-10-11
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This line reads the probe description file (not Siemens files, our own)
%The file is assumed to be contain parameters arranged in two columns, with
%the first col. being the parameter name and the second column the value.
%Comments may be inserted in the file in the matlab style (i.e. %=comment)
%spaces, tabs and equal signs may all be used to seperate columns.  See the
%case statement below for the parameter names 
[pparam,pvalue]=textread(filename,'%s %s %*[^\n]','commentstyle','matlab','whitespace','= \b\t');
% Deal with file-errors!!

% load geometry structure with data
for n=1:size(pparam,1),
    switch lower(pparam{n})
        case {'no_elements'} % Number of elements
            geometry.no_elements = str2num(pvalue{n});
        case {'no_elements_x'} % Number of elements
            geometry.no_elements_x = str2num(pvalue{n});
        case {'no_elements_y'} % Number of elements
            geometry.no_elements_y = str2num(pvalue{n});
        case {'height'} %element height (y direction) (meters)
            geometry.height = str2num(pvalue{n});
        case {'width'} %element width (x, lateral, direction) (meters)
            geometry.width = str2num(pvalue{n});
        case {'kerf'} %space between elements (meters)
            geometry.kerf = str2num(pvalue{n});
        case {'kerf_x'} %space between elements (meters)
            geometry.kerf_x = str2num(pvalue{n});
        case {'kerf_y'} %space between elements (meters)
            geometry.kerf_y = str2num(pvalue{n});
        case {'elv_focus'} %fixed elevation focus (meters)
            geometry.elv_focus = str2num(pvalue{n});
        case {'probe_type'} %linear, curvilinear, or phased
            geometry.probe_type = lower(pvalue{n});
        case {'image_mode'} %linear or phased
            geometry.image_mode = lower(pvalue{n});
        case {'convex_radius'}
            geometry.convex_radius = str2num(pvalue{n});
        case {'f0'} % Transducer center frequency, in Hertz
            geometry.impulse_response.f0 = str2num(pvalue{n});
        case {'bw'} % Bandwidth, in percent of center frequency
            geometry.impulse_response.bw = str2num(pvalue{n});
        case {'phase'} %Phase of carrier relative to envelope
            geometry.impulse_response.phase = str2num(pvalue{n});
        case {'wavetype'} %Envelope function for impulse response.  
            geometry.impulse_response.wavetype=lower(pvalue{n});
        case {'no_sub_x'} % Mathematical element subdivisions in x direction (see FieldII)
            geometry.no_sub_x = str2num(pvalue{n});
        case {'no_sub_y'} % Mathematical subdivisions in y direction
            geometry.no_sub_y = str2num(pvalue{n});
        otherwise % Announce and Ignore any other parameters
            disp(['Unknown parameter "' pparam{n} '" in probe file ' filename ' ignored']);
    end;
end;

if ~isfield(geometry,'no_elements_x') && isfield(geometry,'no_elements');
    geometry.no_elements_x = geometry.no_elements;
end
if ~isfield(geometry,'no_elements_y');
    geometry.no_elements_y = 1;
end
if ~isfield(geometry,'width_x') && isfield(geometry,'width');
    geometry.width_x = geometry.width;
end
if ~isfield(geometry,'kerf_x') && isfield(geometry,'kerf');
    geometry.kerf_x = geometry.kerf;
end
if ~isfield(geometry,'width_y') && isfield(geometry,'height');
    geometry.width_y = geometry.height;
end
if ~isfield(geometry,'kerf_y') && isfield(geometry,'kerf');
    geometry.kerf_y = geometry.kerf;
end
