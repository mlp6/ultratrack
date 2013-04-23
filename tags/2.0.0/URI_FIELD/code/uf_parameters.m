function[geometry,beam]=uf_parameters(fh,varargin)
% [probe, beamset]=uf_parameters(head)
% creates probe and beamset data structures for use by the
% URI-Field tools.  head is a URI header, created by the readFile
% command from the URI-OPT (UC Davis)
% 
% [probe, beamset]=uf_parameters(head,fs)
% is an optional argument for setting the sampling frequency
% used by Field II to fs Hertz.  
%


% mlp6 3/2/99
% 7/24/03 bjf updated for use with URI field_sims.m, Thanks Mark
% 12/15/03 sam  MODIFICATION IN PROGRESS


%
% CONSTANTS
%
MAX_NUM_SETS=8;
FIELD_SAMPLE_FREQ=100e6;  % 100MHz for simulations
c = 1540; % assumed Speed of Sound in m/s

%
% MAYBE CHANGE FIELD SAMPLE FREQUENCY
%

if (nargin>=2)
	if strcmp(varargin{1},'fs')
		FIELD_SAMPLE_FREQ=varargin{2};
		end;
	if FIELD_SAMPLE_FREQ<100e6
		disp('Warning, low Field II sampling frequency selected');
		end;
	end;
												
%
% SAMPLING FREQUENCIES FOR FIELD AND URI
%
geometry.field_sample_freq=FIELD_SAMPLE_FREQ;
geometry.uri_sample_freq=fh.strf.SamplingRate;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TRANSDUCER GEOMETRY INFORMATION (PROBE)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set dummy values to parameters that could be unassigned
%probeid = 0;
convex_radius = 0;
angle_rad = 0;

% This next line gets the probe file name.  From the inside out, 
%fh.rfam.ProbeName is the probe name from the URI file header,
% lower makes it all lowercase, the sscanf function chops off trailing
% spaces, the strcat function appends '.txt', and the which command
% converts the filename to the complete path filename, so that textread
% will be happy (textread needs the complete path, or for the file to be in
% the present working directory).  
probefilename=which(strcat(sscanf(lower(fh.rfam.ProbeName),'%s'),'.txt'));

%Abort if there's no such file
if isempty(probefilename),
    error(['Can''t find a probe file for ' fh.rfam.ProbeName]);
end;

%This line reads the probe description file (not Siemens files, our own)
%The file is assumed to be contain parameters arranged in two columns, with
%the first col. being the parameter name and the second column the value.
%Comments may be inserted in the file in the matlab style (i.e. %=comment)
%spaces, tabs and equal signs may all be used to seperate columns.  See the
%case statement below for the parameter names 
[pparam,pvalue]=textread(probefilename,'%s %s %*[^\n]','commentstyle','matlab','whitespace','= \b\t');
% Deal with file-errors!!

% load geometry structure with data
for n=1:size(pparam,1),
    switch lower(pparam{n})
        case {'no_elements'} % Number of elements
            geometry.no_elements = str2num(pvalue{n});
        case {'height'} %element height (y direction) (meters)
            geometry.height = str2num(pvalue{n});
        case {'width'} %element width (x, lateral, direction) (meters)
            geometry.width = str2num(pvalue{n});
        case {'kerf'} %space between elements (meters)
            geometry.kerf = str2num(pvalue{n});
        case {'elv_focus'} %fixed elevation focus (meters)
            geometry.elv_focus = str2num(pvalue{n});
        case {'probe_type'} %linear, curvilinear, or phased
            geometry.probe_type = lower(pvalue{n});
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
            disp(['Unknown parameter "' pparam{n} '" in probe file ' probefilename ' ignored']);
    end;
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BEAM SET INFORMATION  (PULSE SEQUENCE)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% URI coordinate system: x=lateral, y=axial, z=elevation, origin,i.e.(0,0,0)=lower left corner of aperture
% Field II coodinate system: x=lateral, y=elevation, z=axial, origin= center of aperture
%

%
% Offsets to take URI coordinates to Field coordinates
offset_X=(geometry.width+geometry.kerf)*geometry.no_elements/2;
offset_Z=geometry.height/2;

sets=unique(fh.rfbd.Set); % List of the distinct set numbers

for n=1:length(sets),
     q=find(fh.rfbd.Set==sets(n));
     
     beam(n).type=fh.rfbd.Mode(q(1));
     beam(n).no_beams=length(q);
     
     beam(n).origin=[(fh.rfbd.PositionX(q)')/1000-offset_X; (fh.rfbd.PositionZ(q)')/1000-offset_Z]'; %Beam origin
     beam(n).direction=[fh.rfbd.ThetaRad(q)];  %Beam direction, radians?
 
    
     beam(n).tx_focus_range=fh.rfsd(sets(n)+1).TxFocusRangeCm/100;  % transmit focus range(m)
     beam(n).tx_f_num=fh.rfsd(sets(n)+1).TxFNum;  % Transmit beam f/number
     beam(n).prf=fh.rfsd(sets(n)+1).PrfHz ; % Pulse repitition frequency  (Hz)
     beam(n).tx_apod_type=fh.rfsd(sets(n)+1).TxApodization; % Transmit apodization type

beam(n).tx_excitation.f0=fh.rfsd(sets(n)+1).TxFrequencyMhz;
beam(n).tx_excitation.num_cycles=fh.rfsd(sets(n)+1).NumTxCycles;
beam(n).tx_excitation.phase=0;
beam(n).tx_excitation.wavetype='Square';


     beam(n).is_dyn_focus=fh.rfsd(sets(n)+1).IsDynamicFocusEn; % 1=Dynamic Rx Focus enabled, 0=not
     beam(n).rx_focus_range= fh.rfsd(sets(n)+1).RxFocusRangeCm/100;  % (m) zero means dynamic focus
     beam(n).rx_apod_type= fh.rfsd(sets(n)+1).RxApodization;
	beam(n).rx_f_num=fh.rfsd(sets(n)+1).RxFNum;
	beam(n).aperture_growth=fh.rfsd(sets(n)+1).IsAperGrowthEn;

	

     if (beam(n).type == 'B'),
     	beam(n).apex=[fh.rfbm.ApexLateralCm  fh.rfbm.ApexVerticalCm]; % COMPENSATE FOR URI/FIELD ORIGIN DIFFERENCE?
	beam(n).steering_angle=fh.rfbm.SteeringAngleRad;
	end;
     
     if (beam(n).type == 'C'),
        beam(n).apex=[fh.rfco.ApexLateralCm  fh.rfco.ApexVerticalCm]; % COMPENSATE FOR URI/FIELD ORIGIN DIFFERENCE?
        beam(n).steering_angle=fh.rfco.SteeringAngleRad;
	end;

end; % for n
 


