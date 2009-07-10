function [pulse,varargout]=uf_ir(in,varargin);

%
% uf_txp - function to generate impulse response sequences
%
% pulse = uf_txp('impulse') 
%
%   - pulse is a single '1'
%
%
% pulse = uf_txp('gaussian',fs,f0,bw,phase);
% 
%   - pulse is a gaussian envelope wave sampled at fs Hertz,
%     with a center frequency of f0 Hertz, fractional bandwidth
%     (bw) and phase (phase) in degrees.
%


pulse=[];
t=[];


if ischar(in)
    fs = varargin{1};
    if ~(strcmp('impulse',lower(in)))
        f0 = varargin{2};
        bw = varargin{3};
        p = varargin{4};
        waveform=lower(in);
    end;
end;

if (isstruct(in))
    if isnumeric(in.impulse_response)
        pulse=in.impulse_response;
        t=1/in.field_sample_freq*(0:length(pulse)-1);
        waveform=[];
    end;

    if isstruct(in.impulse_response)
        fs=in.field_sample_freq;
        if ~(strcmp('impulse',lower(in.impulse_response.wavetype)))
            f0=in.impulse_response.f0;
            p=in.impulse_response.phase;
            bw=in.impulse_response.bw;
        end;
        waveform=lower(in.impulse_response.wavetype); % and you've just made waveform type char
    end;

end;

% so this executes if you supplied a structure or string
if ischar(waveform)    
    
    switch waveform
        case 'gaussian'
            T = gauspuls('cutoff', f0, bw/100, -6, -40); % duration of impulse response
            t = -T:1/fs:T; % time samples
            [yi,yq]=gauspuls(t, f0, bw/100); % it's a gaussian-windowed sinusoid
            pulse=yi*cos(p*pi/180)+yq*sin(p*pi/180);
        case 'impulse'
            t=0;
            pulse=1;        
    end;
end;

if nargout>1
    varargout{1}=t;
end;
