function [pulse,varargout]=uf_txp(waveform,varargin);

%
% uf_txp - function to generate impulse response sequences
%
% pulse = uf_txp('impulse') 
%
%   - pulse is a single '1'
%
%
% pulse = uf_txp('sin',fs,f0,num_cycles,phase); 
% pulse = uf_txp('square',fs,f0,num_cycles,phase);
% 
%   - pulse is a sin or square wave sampled at fs Hertz,
%     with a center frequency of f0 Hertz, number of cycles
%     (num_cycles) and phase (phase) in degrees.
%
%   The number of cycles by be fractional, e.g. 1.5.  
%

%f0,num_cycles,phase

pulse=[];
t=[];

if isnumeric(waveform)
    pulse=waveform;
    t=1/varargin{1}*(0:length(pulse)-1);
end;

if ischar(waveform)
    fs = varargin{1};
    if ~(strcmp('impulse',lower(waveform)))
        f0 = varargin{2};
        num_cycles = varargin{3};
        p = varargin{4};
    end;
end;

if isstruct(waveform)
    fs=varargin{1};
    if ~(strcmp('impulse',lower(waveform.wavetype)))
        f0=waveform.f0;
        p=waveform.phase;
        num_cycles=waveform.num_cycles;
    end;
    waveform=waveform.wavetype; % and you've just made waveform type char
end;


% so this executes if you supplied a structure or string
if ischar(waveform)    
    
    waveform=lower(waveform);

    switch waveform
        case 'square'
            t=1/fs*(0:fs*num_cycles/f0-1);
            pulse=square(2*pi*f0*t+p*pi/180);
        case 'sin'
            t=1/fs*(0:fs*num_cycles/f0-1);
            pulse=sin(2*pi*f0*t+p*pi/180);
        case 'impulse'
            t=0;
            pulse=1;        
    end;
end;

if nargout>1
    varargout{1}=t;
end;
