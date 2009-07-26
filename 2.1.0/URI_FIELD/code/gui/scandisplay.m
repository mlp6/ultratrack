function varargout = scandisplay(varargin)
% SCANDISPLAY M-file for scandisplay.fig
%      SCANDISPLAY, by itself, creates a new SCANDISPLAY or raises the existing
%      singleton*.
%
%      H = SCANDISPLAY returns the handle to a new SCANDISPLAY or the handle to
%      the existing singleton*.
%
%      SCANDISPLAY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCANDISPLAY.M with the given input arguments.
%
%      SCANDISPLAY('Property','Value',...) creates a new SCANDISPLAY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before scandisplay_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to scandisplay_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help scandisplay

% Last Modified by GUIDE v2.5 16-Feb-2004 18:23:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @scandisplay_OpeningFcn, ...
                   'gui_OutputFcn',  @scandisplay_OutputFcn, ...
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


% --- Executes just before scandisplay is made visible.
function scandisplay_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to scandisplay (see VARARGIN)

% Choose default command line output for scandisplay
handles.output = hObject;
handles.probe=varargin{1};
handles.beamset=varargin{2};
handles.rf=varargin{3};
handles.t0=varargin{4};
[handles.envdb,handles.ax,handles.lat]=uf_scan_convert(uf_envelope(handles.rf),handles.probe,handles.beamset,handles.t0);



% Update handles structure
guidata(hObject, handles);
disp_scan(hObject,handles);

% UIWAIT makes scandisplay wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = scandisplay_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

set(handles.dyn_range,'Value',round(120-100*get(handles.slider2,'Value')));
set(handles.dyn_range,'String',round(120-100*get(handles.slider2,'Value')));
disp_scan(hObject,handles);


% --- Executes when figure1 window is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function disp_scan(hObject,handles)
dynrange=get(handles.dyn_range,'Value');
axes(handles.axes2);
imagesc(handles.lat,handles.ax,handles.envdb,[-dynrange 0]);
xlabel('x');ylabel('z');colormap(gray);
figure(handles.figure1);
axis image;


% --- Executes during object creation, after setting all properties.
function dyn_range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dyn_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function dyn_range_Callback(hObject, eventdata, handles)
% hObject    handle to dyn_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dyn_range as text
%        str2double(get(hObject,'String')) returns contents of dyn_range as a double

proc_input(hObject,handles,3,200);
a=get(handles.dyn_range,'Value');
if a<20 a=20; end;
if a>120 a=120; end;
set(handles.slider2,'Value',1-(a-20)/100);
disp_scan(hObject,handles);




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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in printbutton.
function printbutton_Callback(hObject, eventdata, handles)
% hObject    handle to printbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%h=figure;colormap(gray);
%set(handles.axes2,'Parent',h);
printdlg(handles.figure1);
%set(handles.axes2,'Parent',handles.figure1);
%close(h);
%figure(handles.figure1);


