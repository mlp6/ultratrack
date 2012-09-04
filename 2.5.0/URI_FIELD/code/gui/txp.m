function varargout = txp(varargin)
% IR M-file for ir.fig
%      IR by itself, creates a new IR or raises the
%      existing singleton*.
%
%      H = IR returns the handle to a new IR or the handle to
%      the existing singleton*.
%
%      IR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IR.M with the given input arguments.
%
%      IR('Property','Value',...) creates a new IR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ir_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ir_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ir

% Last Modified by GUIDE v2.5 02-Mar-2004 18:30:08

%
%
%

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ir_OpeningFcn, ...
                   'gui_OutputFcn',  @ir_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before ir is made visible.
function ir_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ir (see VARARGIN)

% Choose default command line output for ir


handles.wavetypes = get(handles.waveformmenu,'String');
guidata(hObject,handles);

handles.probe=varargin{1};
if nargin>4,
    handles.tx_excitation=varargin{2};
    if isstruct(handles.tx_excitation)
        %disp('Structure given');
        wavetypeindex=strmatch(lower(handles.tx_excitation.wavetype),lower(handles.wavetypes));
        set(handles.waveformmenu,'Value',wavetypeindex);
        if isempty(strmatch('impulse',lower(handles.wavetypes(wavetypeindex))))
            %disp('Not impulse');
            set(handles.f0,'Value',handles.tx_excitation.f0);
            set(handles.num_cycles,'Value',handles.tx_excitation.num_cycles);
            set(handles.phase,'Value',handles.tx_excitation.phase);
            set(handles.f0,'String',num2str(handles.tx_excitation.f0));
            set(handles.num_cycles,'String',num2str(handles.tx_excitation.num_cycles));
            set(handles.phase,'String',num2str(handles.tx_excitation.phase));
        end;
        
    else % Not a struct but a fixed waveform, so put in dummies for variables
        %disp('Fixed waveform given');
        set(handles.f0,'Value',NaN);
        set(handles.num_cycles,'Value',NaN);
        set(handles.phase,'Value',0);
        set(handles.f0,'String','??');
        set(handles.num_cycles,'String','??');
        set(handles.phase,'String','0');
    end;
    
else % there was no waveform supplied at all, so put in defaults
    %disp('No waveform supplied');
    handles.tx_excitation=[];
    set(handles.f0,'Value',5e6);
    set(handles.num_cycles,'Value',1);
    set(handles.phase,'Value',0);
    set(handles.f0,'String','5e6');
    set(handles.num_cycles,'String','1');
    set(handles.phase,'String','0');

end;
guidata(hObject,handles);

    

% Update handles structure
guidata(hObject, handles);



% Determine the position of the dialog - centered on the callback figure
% if available, else, centered on the screen
FigPos=get(0,'DefaultFigurePosition');
OldUnits = get(hObject, 'Units');
set(hObject, 'Units', 'pixels');
OldPos = get(hObject,'Position');
FigWidth = OldPos(3);
FigHeight = OldPos(4);
if isempty(gcbf)
    ScreenUnits=get(0,'Units');
    set(0,'Units','pixels');
    ScreenSize=get(0,'ScreenSize');
    set(0,'Units',ScreenUnits);

    FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
    FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
else
    GCBFOldUnits = get(gcbf,'Units');
    set(gcbf,'Units','pixels');
    GCBFPos = get(gcbf,'Position');
    set(gcbf,'Units',GCBFOldUnits);
    FigPos(1:2) = [(GCBFPos(1) + GCBFPos(3) / 2) - FigWidth / 2, ...
                   (GCBFPos(2) + GCBFPos(4) / 2) - FigHeight / 2];
end
FigPos(3:4)=[FigWidth FigHeight];
set(hObject, 'Position', FigPos);
set(hObject, 'Units', OldUnits);

% Show a question icon from dialogicons.mat - variables questIconData
% and questIconMap
load dialogicons.mat

IconData=questIconData;
questIconMap(256,:) = get(handles.figure1, 'Color');
IconCMap=questIconMap;

Img=image(IconData, 'Parent', handles.axes1);
set(handles.figure1, 'Colormap', IconCMap);

set(handles.axes1, ...
    'Visible', 'off', ...
    'YDir'   , 'reverse'       , ...
    'XLim'   , get(Img,'XData'), ...
    'YLim'   , get(Img,'YData')  ...
    );

make_pulse(hObject,handles);

% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')

% UIWAIT makes ir wait for user response (see UIRESUME)
uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = ir_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
pulsedata.f0=get(handles.f0,'Value');
pulsedata.waveformmenu = get(handles.waveformmenu,'Value');
pulsedata.num_cycles = get(handles.num_cycles,'Value');
pulsedata.phase = get(handles.phase,'Value');
varargout{2}=pulsedata;


% The figure can be deleted now
delete(handles.figure1);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~strcmp('impulse',lower(handles.wavetypes{get(handles.waveformmenu,'Value')}))
    if (isnan(get(handles.f0,'Value')))
        questdlg('Specify frequency or click Cancel','','OK','OK');
        return;
    end;
    if (isnan(get(handles.num_cycles,'Value')))
        questdlg('Specify number of cycles or click Cancel','','OK','OK');
        return;
    end;
end;

handles.tx_excitation.f0=get(handles.f0,'Value');
handles.tx_excitation.num_cycles=get(handles.num_cycles,'Value');
handles.tx_excitation.phase=get(handles.phase,'Value');
handles.tx_excitation.wavetype=handles.wavetypes{get(handles.waveformmenu,'Value')};

handles.output = handles.tx_excitation;

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = handles.tx_excitation;

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(handles.figure1, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(handles.figure1);
else
    % The GUI is no longer waiting, just close it
    delete(handles.figure1);
end


% --- Executes on key press over figure1 with no controls selected.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check for "enter" or "escape"
if isequal(get(hObject,'CurrentKey'),'escape')
    % User said no by hitting escape
    handles.output = 'No';
    
    % Update handles structure
    guidata(hObject, handles);
    
    uiresume(handles.figure1);
end    
    
if isequal(get(hObject,'CurrentKey'),'return')
    uiresume(handles.figure1);
end    


% --- Executes during object creation, after setting all properties.
function f0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function f0_Callback(hObject, eventdata, handles)
% hObject    handle to f0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f0 as text
%        str2double(get(hObject,'String')) returns contents of f0 as a double
proc_input(hObject,handles,500e3,handles.probe.field_sample_freq/2);
make_pulse(hObject,handles);


% --- Executes during object creation, after setting all properties.
function num_cycles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_cycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function num_cycles_Callback(hObject, eventdata, handles)
% hObject    handle to num_cycles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_cycles as text
%        str2double(get(hObject,'String')) returns contents of num_cycles as a double
proc_input(hObject,handles,0.5,100);
make_pulse(hObject,handles);

% --- Executes during object creation, after setting all properties.
function phase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function phase_Callback(hObject, eventdata, handles)
% hObject    handle to phase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of phase as text
%        str2double(get(hObject,'String')) returns contents of phase as a double
proc_input(hObject,handles,0,360);
make_pulse(hObject,handles);


function make_pulse(hObject,handles)

f0= get(handles.f0,'Value');
fs= handles.probe.field_sample_freq;
num_cycles= get(handles.num_cycles,'Value');
p=get(handles.phase,'Value');
contents=get(handles.waveformmenu,'String');
s=contents{get(handles.waveformmenu,'Value')};

[pulse,t] = uf_txp(s,fs,f0,num_cycles,p);


switch s
    case 'Square'
        set(handles.f0,'Enable','On');
        set(handles.num_cycles,'Enable','On');
        set(handles.phase,'Enable','On');
    case 'Sin'
        set(handles.f0,'Enable','On');
        set(handles.num_cycles,'Enable','On');
        set(handles.phase,'Enable','On');
    case 'Impulse'
        set(handles.f0,'Enable','Off');
        set(handles.num_cycles,'Enable','Off');
        set(handles.phase,'Enable','Off');
        
end;



axes(handles.axes1);
if ~isempty(handles.tx_excitation),
    
    [oldpulse,oldt]=uf_txp(handles.tx_excitation,handles.probe.field_sample_freq);
    if get(handles.displaymode,'Value'),
        % Frequency domain display
        [s,f]=dbfft(oldpulse,handles.probe.field_sample_freq);
        h1(1)=plot(f,s,'r');
        hold on;
        [s,f]=dbfft(pulse,handles.probe.field_sample_freq);
        h2(1)=plot(f,s);hold off;
    else
        % Time domain display
        h1=stem(oldt,oldpulse,'filled','r');
        hold on;
        h2=stem(t,pulse,'b');
        axis([-1/fs 1/fs+max(max(t),max(oldt)) -1.1 1.1]);
        hold off;
    end;
    legend([h1(1), h2(1)],{'Current','Proposed'})
else
    stem(t,pulse,'filled');
end;
handles.new_pulse=pulse;
guidata(hObject, handles);








% --- Executes during object creation, after setting all properties.
function waveformmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to waveformmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
wavetypes={'Square','Sin','Impulse'};

set(hObject,'String',wavetypes);
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



% --- Executes on selection change in waveformmenu.
function waveformmenu_Callback(hObject, eventdata, handles)
% hObject    handle to waveformmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns waveformmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from waveformmenu
make_pulse(hObject,handles);

function proc_input(hObject,handles,lowlimit,highlimit)
a=str2double(get(hObject,'String'));
if isnan(a),
    set(hObject,'String',num2str(get(hObject,'Value')));
    return;
end;
if a<lowlimit,
    a=lowlimit;
end;
if a>highlimit
    a=highlimit;
end;
set(hObject,'Value',a);
set(hObject,'String',num2str(a));


% --- Executes on button press in displaymode.
function displaymode_Callback(hObject, eventdata, handles)
% hObject    handle to displaymode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of displaymode

if get(handles.displaymode,'Value')
    set(handles.displaymode,'String','Frequency');
else
    set(handles.displaymode,'String','Time');
end;
    

make_pulse(hObject,handles);








function [s,f]=dbfft(n,fs)
    % Computes the magnitude of assumed real signal n
    n=fft([n zeros(1,max(256-length(n),4*length(n)))]);
    k=1:(round(length(n)/2));f=fs*(k-1)/length(n);
    n=max(n,eps);
    s=20*log10(abs(n(k))/max(abs(n(k))));
    s=max(s,-120);












