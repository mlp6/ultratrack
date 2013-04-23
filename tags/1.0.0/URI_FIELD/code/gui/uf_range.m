function varargout = uf_range(varargin)
% UF_RANGE M-file for uf_range.fig
%      UF_RANGE, by itself, creates a new UF_RANGE or raises the existing
%      singleton*.
%
%      H = UF_RANGE returns the handle to a new UF_RANGE or the handle to
%      the existing singleton*.
%
%      UF_RANGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UF_RANGE.M with the given input arguments.
%
%      UF_RANGE('Property','Value',...) creates a new UF_RANGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before uf_range_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to uf_range_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help uf_range

% Last Modified by GUIDE v2.5 23-Feb-2004 13:56:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uf_range_OpeningFcn, ...
                   'gui_OutputFcn',  @uf_range_OutputFcn, ...
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


% --- Executes just before uf_range is made visible.
function uf_range_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to uf_range (see VARARGIN)

% Choose default command line output for uf_range
handles.origin = [];
handles.direction=[];
% Update handles structure
guidata(hObject, handles);

% Make window modal
set(handles.figure1,'WindowStyle','modal')

% UIWAIT makes uf_range wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = uf_range_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.origin;
varargout{2} = handles.direction;
delete(handles.figure1);

% --- Executes during object creation, after setting all properties.
function nobeams_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nobeams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function nobeams_Callback(hObject, eventdata, handles)
% hObject    handle to nobeams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nobeams as text
%        str2double(get(hObject,'String')) returns contents of nobeams as a double
proc_input(hObject,handles,1,inf)

% --- Executes during object creation, after setting all properties.
function startx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function startx_Callback(hObject, eventdata, handles)
% hObject    handle to startx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startx as text
%        str2double(get(hObject,'String')) returns contents of startx as a double
proc_input(hObject,handles,-inf,inf)

% --- Executes during object creation, after setting all properties.
function startz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function startz_Callback(hObject, eventdata, handles)
% hObject    handle to startz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startz as text
%        str2double(get(hObject,'String')) returns contents of startz as a double
proc_input(hObject,handles,-inf,inf)

% --- Executes during object creation, after setting all properties.
function incx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to incx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function incx_Callback(hObject, eventdata, handles)
% hObject    handle to incx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of incx as text
%        str2double(get(hObject,'String')) returns contents of incx as a double
proc_input(hObject,handles,0,inf)

% --- Executes during object creation, after setting all properties.
function incz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to incz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function incz_Callback(hObject, eventdata, handles)
% hObject    handle to incz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of incz as text
%        str2double(get(hObject,'String')) returns contents of incz as a double
proc_input(hObject,handles,0,inf)

% --- Executes during object creation, after setting all properties.
function starttheta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to starttheta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function starttheta_Callback(hObject, eventdata, handles)
% hObject    handle to starttheta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of starttheta as text
%        str2double(get(hObject,'String')) returns contents of starttheta as a double
proc_input(hObject,handles,-90,90)

% --- Executes during object creation, after setting all properties.
function inctheta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inctheta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function inctheta_Callback(hObject, eventdata, handles)
% hObject    handle to inctheta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inctheta as text
%        str2double(get(hObject,'String')) returns contents of inctheta as a double
proc_input(hObject,handles,0,inf)

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x=(0:get(handles.nobeams,'Value')-1)';
z=x;
theta=x;

x=(x*get(handles.incx,'Value'))+get(handles.startx,'Value');
z=(z*get(handles.incz,'Value'))+get(handles.startz,'Value');
theta=(theta*get(handles.inctheta,'Value'))+get(handles.starttheta,'Value');

handles.origin=[x z];
handles.direction=theta;

guidata(hObject,handles);
uiresume(handles.figure1);

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
