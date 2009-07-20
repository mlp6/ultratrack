function varargout = atten(varargin)
% ATTEN M-file for atten.fig
%      ATTEN, by itself, creates a new ATTEN or raises the existing
%      singleton*.
%
%      H = ATTEN returns the handle to a new ATTEN or the handle to
%      the existing singleton*.
%
%      ATTEN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ATTEN.M with the given input arguments.
%
%      ATTEN('Property','Value',...) creates a new ATTEN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before atten_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to atten_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help atten

% Last Modified by GUIDE v2.5 02-Mar-2004 19:37:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @atten_OpeningFcn, ...
                   'gui_OutputFcn',  @atten_OutputFcn, ...
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


% --- Executes just before atten is made visible.
function atten_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to atten (see VARARGIN)

if nargin>4,
    set(handles.atten_coef,'String',num2str(varargin{1}));
    set(handles.atten_f0,'String',num2str(varargin{2}));
    set(handles.atten_coef,'Value',varargin{1});
    set(handles.atten_f0,'Value',varargin{2});
end;



% Choose default command line output for atten
handles.output = hObject;

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


% Make GUI modal
set(handles.figure1,'WindowStyle','modal')


% UIWAIT makes atten wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = atten_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output.atten_coef;
varargout{2} = handles.output.atten_f0;
delete(handles.figure1);

% --- Executes during object creation, after setting all properties.
function atten_coef_CreateFcn(hObject, eventdata, handles)
% hObject    handle to atten_coef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function atten_coef_Callback(hObject, eventdata, handles)
% hObject    handle to atten_coef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of atten_coef as text
%        str2double(get(hObject,'String')) returns contents of atten_coef as a double
proc_input(hObject,handles,0,10);


% --- Executes during object creation, after setting all properties.
function atten_f0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to atten_f0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function atten_f0_Callback(hObject, eventdata, handles)
% hObject    handle to atten_f0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of atten_f0 as text
%        str2double(get(hObject,'String')) returns contents of atten_f0 as a double


proc_input(hObject,handles,5e5,50e6);


% --- Executes on button press in cancelbutton.
function cancelbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.atten_coef=[];
handles.output.atten_f0=[];
guidata(hObject,handles);
uiresume(handles.figure1);


% --- Executes on button press in okbutton.
function okbutton_Callback(hObject, eventdata, handles)
% hObject    handle to okbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output.atten_coef = get(handles.atten_coef,'Value');
handles.output.atten_f0 = get(handles.atten_f0,'Value');
guidata(hObject,handles);
uiresume(handles.figure1);

