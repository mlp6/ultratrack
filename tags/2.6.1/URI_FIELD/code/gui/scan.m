function varargout = scan(varargin)
% SCAN M-file for scan.fig
%      SCAN, by itself, creates a new SCAN or raises the existing
%      singleton*.
%
%      H = SCAN returns the handle to a new SCAN or the handle to
%      the existing singleton*.
%
%      SCAN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCAN.M with the given input arguments.
%
%      SCAN('Property','Value',...) creates a new SCAN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before scan_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to scan_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help scan

% Last Modified by GUIDE v2.5 16-Feb-2004 22:38:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @scan_OpeningFcn, ...
                   'gui_OutputFcn',  @scan_OutputFcn, ...
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


% --- Executes just before scan is made visible.
function scan_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to scan (see VARARGIN)

% Stick the inputs on the handles structure
handles.probe=varargin{1};
handles.beamset=varargin{2};
handles.tx=varargin{3};
handles.rx=varargin{4};
handles.phantom=varargin{5};

% Choose default command line output for sca
handles.output = hObject;

nsets=length(handles.beamset);
for n=1:nsets,
    s{n}=sprintf('%d: %c-mode, Tx Focus %1.1f cm',n,handles.beamset.type,handles.beamset.tx_focus_range*100);
end;
set(handles.beamset_list,'String',s);


% Update handles structure
guidata(hObject, handles);

% MAKE WINDOW MODAL!!


% UIWAIT makes scan wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = scan_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.rfdata;
varargout{2} = handles.t0;
delete(handles.figure1);


% --- Executes during object creation, after setting all properties.
function beamset_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beamset_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in beamset_list.
function beamset_list_Callback(hObject, eventdata, handles)
% hObject    handle to beamset_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns beamset_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from beamset_list


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.rf=[];
handles.t0=[];
guidata(hObject,handles);
uiresume(handles.figure1);


% --- Executes on button press in go.
function go_Callback(hObject, eventdata, handles)
% hObject    handle to go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nset=get(handles.beamset_list,'Value');


% if process in this Matlab,
if handles.calc_here,
    [rfdata,t0]=uf_scan(handles.probe,handles.beamset(nset),handles.tx,handles.rx,handles.phantom);
    scandisplay(handles.probe,handles.beamset,rfdata,t0);
    probe=handles.probe;
    beamset=handles.beamset;
    phantom=handles.phantom;
    uisave({'probe','beamset','phantom','rfdata','t0'});
    handles.rfdata=rfdata;
    handles.t0=t0;
    guidata(hObject,handles);
end;
uiresume(handles.figure1);
    

% --- Executes on button press in calc_here.
function calc_here_Callback(hObject, eventdata, handles)
% hObject    handle to calc_here (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of calc_here
set(handles.calc_here,'Value',1);
set(handles.calc_else,'Value',0);


% --- Executes on button press in calc_else.
function calc_else_Callback(hObject, eventdata, handles)
% hObject    handle to calc_else (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of calc_else
set(handles.calc_else,'Value',1);
set(handles.calc_here,'Value',0);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


