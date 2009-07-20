function varargout = ir(varargin)
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

% Last Modified by GUIDE v2.5 01-Mar-2004 21:05:30

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

handles.probe=varargin{1};
guidata(hObject,handles);

if isstruct(handles.probe.impulse_response)
    %disp('Structure given');
    if isempty(strmatch('impulse',lower(handles.probe.impulse_response.wavetype)));
        %disp('Not impulse');
        set(handles.f0,'Value',handles.probe.impulse_response.f0);
        set(handles.bw,'Value',handles.probe.impulse_response.bw);
        set(handles.phase,'Value',handles.probe.impulse_response.phase);
        set(handles.f0,'String',num2str(handles.probe.impulse_response.f0));
        set(handles.bw,'String',num2str(handles.probe.impulse_response.bw));
        set(handles.phase,'String',num2str(handles.probe.impulse_response.phase));
    end;
        
else  %Not a struct but a fixed waveform, so put in dummies for variables
    %disp('Fixed waveform given');
    set(handles.f0,'Value',NaN);
    set(handles.bw,'Value',NaN);
    set(handles.phase,'Value',0);
    set(handles.f0,'String','??');
    set(handles.bw,'String','??');
    set(handles.phase,'String','0');
end;


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


% The figure can be deleted now
delete(handles.figure1);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isnan(get(handles.f0,'Value'))
    disp('Not OK!  No f0!');
    return;
end;

if isnan(get(handles.bw,'Value'));
    disp('Not OK! No bandwidth!');
    return;
end;


handles.probe.impulse_response.f0=get(handles.f0,'Value');
handles.probe.impulse_response.bw=get(handles.bw,'Value');
handles.probe.impulse_response.phase=get(handles.phase,'Value');
handles.probe.impulse_response.wavetype='gaussian';
handles.output = handles.probe;

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

handles.output = handles.probe;

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
function bw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function bw_Callback(hObject, eventdata, handles)
% hObject    handle to bw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bw as text
%        str2double(get(hObject,'String')) returns contents of bw as a double
proc_input(hObject,handles,0.1,1000);
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
bw= get(handles.bw,'Value');
p=  get(handles.phase,'Value');

[pulse,t]=uf_ir('gaussian',fs,f0,bw,p);
[oldpulse,oldt]=uf_ir(handles.probe);

if get(handles.displaymode,'Value')
    % Frequency Display mode
    %   Make sure we have at lest 256 pts to FFT
    Pulse=fft([pulse zeros(1,max(256-length(pulse),0))]);
    Oldpulse=fft([oldpulse zeros(1,max(256-length(oldpulse),0))]);
    n1=1:(round(length(Pulse)/2));f1=handles.probe.field_sample_freq*n1/length(Pulse);
    n2=1:(round(length(Oldpulse)/2));f2=handles.probe.field_sample_freq*n2/length(Oldpulse);
    F1=20*log10(abs(Pulse(n1))/max(abs(Pulse(n1))));
    F2=20*log10(abs(Oldpulse(n2))/max(abs(Oldpulse(n2))));
    axes(handles.axes1);
    h1=plot(f2,F2,'r--');
    hold on;
    h2=plot(f1,F1);
else
    % Time display mode
    axes(handles.axes1);
    h1=stem(oldt,oldpulse,'filled','r');
    hold on;
    h2=stem(t,pulse);
    axis([-1/fs+min(min(t),min(oldt)) 1/fs+max(max(t),max(oldt)) -1.1 1.1]);
end;

hold off;
legend([h1(1), h2(1)],{'Current','Proposed'});




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

% THIS VALUE IS INSPECTED WHEN PLOTTING
guidata(hObject,handles);
if get(hObject,'Value'),
    set(hObject,'String','Frequency');
else
    set(hObject,'String','Time');
end;
make_pulse(hObject,handles);

