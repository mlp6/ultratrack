function varargout = beamseteditor(varargin)
% BEAMSETEDITOR M-file for beamseteditor.fig
%      BEAMSETEDITOR, by itself, creates a new BEAMSETEDITOR or raises the existing
%      singleton*.
%
%      H = BEAMSETEDITOR returns the handle to a new BEAMSETEDITOR or the handle to
%      the existing singleton*.
%
%      BEAMSETEDITOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BEAMSETEDITOR.M with the given input arguments.
%
%      BEAMSETEDITOR('Property','Value',...) creates a new BEAMSETEDITOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before beamseteditor_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to beamseteditor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help beamseteditor

% Last Modified by GUIDE v2.5 23-Feb-2004 19:42:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @beamseteditor_OpeningFcn, ...
                   'gui_OutputFcn',  @beamseteditor_OutputFcn, ...
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


% --- Executes just before beamseteditor is made visible.
function beamseteditor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to beamseteditor (see VARARGIN)

% Choose default command line output for beamseteditor
handles.output = [];

%default data
    handles.defaultbeamset.type='B';
    handles.defaultbeamset.no_beams=1;
    handles.defaultbeamset.origin=[0 0];
    handles.defaultbeamset.direction=0;
    handles.defaultbeamset.tx_focus_range=0.05;
    handles.defaultbeamset.tx_f_num=4;
    handles.defaultbeamset.tx_freq=5e6;
    handles.defaultbeamset.tx_num_cycles=1;                
    %handles.defaultbeamset.prf=0;
    handles.defaultbeamset.tx_apod_type=1;
    handles.defaultbeamset.tx_excitation=1;
    handles.defaultbeamset.is_dyn_focus=1;
    handles.defaultbeamset.rx_focus_range=0;
    handles.defaultbeamset.rx_apod_type=1;
    handles.defaultbeamset.rx_f_num=1;
    handles.defaultbeamset.aperture_growth=1;
    %handles.defaultbeamset.apex: [1.9100 0];
    %steering_angle: 0


% Probe data structure is a required input
handles.probe=varargin{1};
    
if nargin>4, % If there's an input use it
    handles.beamset=varargin{2};
    handles.output=varargin{2};

else % Otherwise set defaults
    setnum=get(handles.beamsetnolist,'Value');
    handles.beamset(setnum)=handles.defaultbeamset;
end;

guidata(hObject,handles);
setup_beamset(hObject,handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes beamseteditor wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = beamseteditor_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(handles.figure1);



% --- Executes during object creation, after setting all properties.
function beamtype_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beamtype_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
set(hObject,'String',{'B-mode','C-mode','D-mode','M-mode'});


function beamtype_menu_Callback(hObject, eventdata, handles)
% hObject    handle to beamtype_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of beamtype_menu as text
%        str2double(get(hObject,'String')) returns contents of beamtype_menu as a double


% --- Executes during object creation, after setting all properties.
function beams_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function beams_Callback(hObject, eventdata, handles)
% hObject    handle to beams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of beams as text
%        str2double(get(hObject,'String')) returns contents of beams as a double
setnum=get(handles.beamsetnolist,'Value');
n=get(hObject,'Value');
set(handles.origin_x,'String',sprintf('%1.3e',handles.beamset(setnum).origin(n,1)));
set(handles.origin_z,'String',sprintf('%1.3e',handles.beamset(setnum).origin(n,2)));
set(handles.theta,'String',sprintf('%1.3e',handles.beamset(setnum).direction(n,1)));




% --- Executes during object creation, after setting all properties.
function origin_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to origin_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in origin_x.
function origin_x_Callback(hObject, eventdata, handles)
% hObject    handle to origin_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns origin_x contents as cell array
%        contents{get(hObject,'Value')} returns selected item from origin_x
setnum=get(handles.beamsetnolist,'Value');
proc_input(hObject,handles,-inf,inf);
n=get(handles.beams,'Value');
handles.beamset(setnum).origin(n,1)=get(hObject,'Value');
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function theta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in theta.
function theta_Callback(hObject, eventdata, handles)
% hObject    handle to theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns theta contents as cell array
%        contents{get(hObject,'Value')} returns selected item from theta
setnum=get(handles.beamsetnolist,'Value');
proc_input(hObject,handles,-90,90);
n=get(handles.beams,'Value');
handles.beamset(setnum).direction(n,1)=get(hObject,'Value');
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function tx_shading_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tx_shading (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
set(hObject,'String',{'Rect','Hann'});



function tx_shading_Callback(hObject, eventdata, handles)
% hObject    handle to tx_shading (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tx_shading as text
%        str2double(get(hObject,'String')) returns contents of tx_shading as a double
setnum=get(handles.beamsetnolist,'Value');
handles.beamset(setnum).tx_apod_type=get(hObject,'Value')-1;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function tx_focus_range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tx_focus_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function tx_focus_range_Callback(hObject, eventdata, handles)
% hObject    handle to tx_focus_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tx_focus_range as text
%        str2double(get(hObject,'String')) returns contents of tx_focus_range as a double
setnum=get(handles.beamsetnolist,'Value');
proc_input(hObject,handles,0,inf);
handles.beamset(setnum).tx_focus_range=get(hObject,'Value');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function tx_f_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tx_f_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function tx_f_number_Callback(hObject, eventdata, handles)
% hObject    handle to tx_f_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tx_f_number as text
%        str2double(get(hObject,'String')) returns contents of tx_f_number as a double
setnum=get(handles.beamsetnolist,'Value');
proc_input(hObject,handles,0,inf);
handles.beamset(setnum).tx_f_num=get(hObject,'Value');
guidata(hObject,handles);




% --- Executes during object creation, after setting all properties.
function rx_focus_range_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rx_focus_range_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function rx_focus_range_edit_Callback(hObject, eventdata, handles)
% hObject    handle to rx_focus_range_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rx_focus_range_edit as text
%        str2double(get(hObject,'String')) returns contents of rx_focus_range_edit as a double
setnum=get(handles.beamsetnolist,'Value');
proc_input(hObject,handles,0,inf)
handles.beamset(setnum).rx_focus_range=get(hObject,'Value')
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function rx_f_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rx_f_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function rx_f_num_Callback(hObject, eventdata, handles)
% hObject    handle to rx_f_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rx_f_num as text
%        str2double(get(hObject,'String')) returns contents of rx_f_num as a double
setnum=get(handles.beamsetnolist,'Value');
proc_input(hObject,handles,0,inf)
handles.beamset(setnum).rx_f_num=get(hObject,'Value')
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes on button press in dyn_focus_checkbox.
function dyn_focus_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to dyn_focus_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dyn_focus_checkbox
setnum=get(handles.beamsetnolist,'Value');
if get(hObject,'Value'),
    set(handles.rx_focus_range_edit,'Enable','Off');
else
    set(handles.rx_focus_range_edit,'Enable','On');
end;
handles.beamset(setnum).is_dyn_focus=get(hObject,'Value');
guidata(hObject,handles);


    

% --- Executes on button press in dyn_apod_toggle.
function dyn_apod_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to dyn_apod_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dyn_apod_toggle
setnum=get(handles.beamsetnolist,'Value');
if get(hObject,'Value'),
    set(handles.dyn_apod_toggle,'String','Dynamic');
    set(handles.rx_f_num_label,'String','F Number');
else
    set(handles.dyn_apod_toggle,'String','Fixed');
    set(handles.rx_f_num_label,'String','# Elements');
end;
setnum=get(handles.beamsetnolist,'Value');
handles.beamset(setnum).aperture_growth=get(hObject,'Value');
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function rx_shading_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rx_shading (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
set(hObject,'String',{'Rect','Hann'});



% --- Executes on selection change in rx_shading.
function rx_shading_Callback(hObject, eventdata, handles)
% hObject    handle to rx_shading (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns rx_shading contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rx_shading
setnum=get(handles.beamsetnolist,'Value');
handles.beamset(setnum).rx_apod_type=get(hObject,'Value')-1;
guidata(hObject,handles);







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

function setup_beamset(hObject,handles)
setnum=get(handles.beamsetnolist,'Value');
set(handles.beamsetnolist,'String',1:length(handles.beamset));

set(handles.tx_focus_range,'String',num2str(handles.beamset(setnum).tx_focus_range));
set(handles.beamtype_menu,'String',handles.beamset(setnum).type);
set(handles.beams,'String',1:handles.beamset(setnum).no_beams);
set(handles.origin_x,'String', sprintf('%1.3e',handles.beamset(setnum).origin(1,1)) );
set(handles.origin_z,'String', sprintf('%1.3e',handles.beamset(setnum).origin(1,2)) );
set(handles.theta,'String',sprintf('%1.3e',handles.beamset(setnum).direction(1,1))  );
set(handles.tx_f_number,'String',handles.beamset(setnum).tx_f_num);
%handles.new_beamset(setnum).prf: 
set(handles.tx_shading,'Value',handles.beamset(setnum).tx_apod_type+1);
%handles.new_beamset(setnum).tx_excitation: [1 1 1 1 1 1 -1 -1 -1 -1 -1 -1]
set(handles.dyn_focus_checkbox,'Value',handles.beamset(setnum).is_dyn_focus);
set(handles.rx_focus_range_edit,'String',handles.beamset(setnum).rx_focus_range);
if handles.beamset(setnum).is_dyn_focus,
    set(handles.rx_focus_range_edit,'Enable','Off');
else
    set(handles.rx_focus_range_edit,'Enable','On');
end;
set(handles.rx_shading,'Value',handles.beamset(setnum).rx_apod_type+1);
set(handles.rx_f_num,'String',handles.beamset(setnum).rx_f_num);
set(handles.dyn_apod_toggle,'Value',handles.beamset(setnum).aperture_growth);

if get(handles.dyn_apod_toggle,'Value'),
    set(handles.dyn_apod_toggle,'String','Dynamic');
    set(handles.rx_f_num_label,'String','F Number');
else
    set(handles.dyn_apod_toggle,'String','Fixed');
    set(handles.rx_f_num_label,'String','# Elements');
end;



%handles.new_beamset(setnum).apex: [1.9100 0]
%handles.new_beamset(setnum).steering_angle: 0


% --- Executes during object creation, after setting all properties.
function origin_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to origin_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function origin_z_Callback(hObject, eventdata, handles)
% hObject    handle to origin_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of origin_z as text
%        str2double(get(hObject,'String')) returns contents of origin_z as a double
setnum=get(handles.beamsetnolist,'Value');
proc_input(hObject,handles,-inf,inf);
n=get(handles.beams,'Value');
handles.beamset(setnum).origin(n,2)=get(hObject,'Value');
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function dyn_apod_toggle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dyn_apod_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in okbutton.
function okbutton_Callback(hObject, eventdata, handles)
% hObject    handle to okbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output=handles.beamset;
guidata(hObject,handles);
uiresume(handles.figure1);


% --- Executes on button press in cancelbuton.
function cancelbuton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelbuton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiresume(handles.figure1);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setnum=get(handles.beamsetnolist,'Value');

n=get(handles.beams,'Value');
set(handles.beams,'String',1:handles.beamset(setnum).no_beams+1);
set(handles.beams,'Value',n+1);
handles.beamset(setnum).origin=[handles.beamset(setnum).origin(1:n,:);zeros(1,size(handles.beamset(setnum).origin,2));handles.beamset(setnum).origin(n+1:end,:)];
handles.beamset(setnum).direction=[handles.beamset(setnum).direction(1:n,:);zeros(1,size(handles.beamset(setnum).direction,2));handles.beamset(setnum).direction(n+1:end,:)];
set(handles.origin_x,'String',sprintf('%1.3e',handles.beamset(setnum).origin(n+1,1)));
set(handles.origin_z,'String',sprintf('%1.3e',handles.beamset(setnum).origin(n+1,2)));
set(handles.theta,'String',sprintf('%1.3e',handles.beamset(setnum).direction(n+1,1)));

handles.beamset(setnum).no_beams=handles.beamset(setnum).no_beams+1;
guidata(hObject,handles);




% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setnum=get(handles.beamsetnolist,'Value');

[origin,direction]=uf_range;
m=size(origin,1);

n=get(handles.beams,'Value');
set(handles.beams,'String',1:handles.beamset(setnum).no_beams+m);
set(handles.beams,'Value',n+m);
handles.beamset(setnum).origin=[handles.beamset(setnum).origin(1:n,:);origin;handles.beamset(setnum).origin(n+1:end,:)];
handles.beamset(setnum).direction=[handles.beamset(setnum).direction(1:n,:);direction;handles.beamset(setnum).direction(n+1:end,:)];
set(handles.origin_x,'String',sprintf('%1.3e',handles.beamset(setnum).origin(n+m,1)));
set(handles.origin_z,'String',sprintf('%1.3e',handles.beamset(setnum).origin(n+m,2)));
set(handles.theta,'String',sprintf('%1.3e',handles.beamset(setnum).direction(n+m,1)));

handles.beamset(setnum).no_beams=handles.beamset(setnum).no_beams+m;
guidata(hObject,handles);



% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setnum=get(handles.beamsetnolist,'Value');

% Don't let 'em delete the last beam- there should always be at least one!!
if (handles.beamset(setnum).no_beams>1),
    n=get(handles.beams,'Value');
    handles.beamset(setnum).origin=[handles.beamset(setnum).origin(1:n-1,:);handles.beamset(setnum).origin(n+1:end,:)];
    handles.beamset(setnum).direction=[handles.beamset(setnum).direction(1:n-1,:);handles.beamset(setnum).direction(n+1:end,:)];
    n=max(n-1,1);
    set(handles.beams,'String',1:handles.beamset(setnum).no_beams-1);
    set(handles.beams,'Value',n);
    set(handles.origin_x,'String',sprintf('%1.3e',handles.beamset(setnum).origin(n,1)));
    set(handles.origin_z,'String',sprintf('%1.3e',handles.beamset(setnum).origin(n,2)));
    set(handles.theta,'String',sprintf('%1.3e',handles.beamset(setnum).direction(n,1)));
    handles.beamset(setnum).no_beams=handles.beamset(setnum).no_beams-1;
    guidata(hObject,handles);
end;


% --- Executes during object creation, after setting all properties.
function beamsetnolist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beamsetnolist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in beamsetnolist.
function beamsetnolist_Callback(hObject, eventdata, handles)
% hObject    handle to beamsetnolist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns beamsetnolist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from beamsetnolist

% Update display of all values!

setup_beamset(hObject,handles);


% --- Executes on button press in addsetbutton.
function addsetbutton_Callback(hObject, eventdata, handles)
% hObject    handle to addsetbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nextset=length(handles.beamset)+1;
set(handles.beamsetnolist,'String',1:nextset);
set(handles.beamsetnolist,'Value',nextset);
% Copy beamset data from next to last  set
handles.beamset(nextset)=handles.beamset(nextset-1);
% continue
guidata(hObject,handles);


% --- Executes on button press in delsetbutton.
function delsetbutton_Callback(hObject, eventdata, handles)
% hObject    handle to delsetbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setnum=get(handles.beamsetnolist,'Value');

% Don't let 'em delete the last set - there should always be at least one!!
if (length(handles.beamset)>1),
    handles.beamset=[handles.beamset(1:setnum-1) handles.beamset(setnum+1:end)];
    set(handles.beamsetnolist,'String',1:length(handles.beamset));
    set(handles.beamsetnolist,'Value',max(1,setnum-1));
    guidata(hObject,handles);
end;


% --- Executes on button press in plot_tx_pulse.
function plot_tx_pulse_Callback(hObject, eventdata, handles)
% hObject    handle to plot_tx_pulse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure
setnum=get(handles.beamsetnolist,'Value');
[pulse,t]=uf_txp(handles.beamset(setnum).tx_excitation,handles.probe.field_sample_freq);
stem(t,pulse);
xlabel('Time (seconds)');
title('Transmit Excitation');
figure(handles.figure1);


% --- Executes on button press in set_tx_pulse.
function set_tx_pulse_Callback(hObject, eventdata, handles)
% hObject    handle to set_tx_pulse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setnum=get(handles.beamsetnolist,'Value');
handles.beamset(setnum).tx_excitation=txp(handles.probe,handles.beamset(setnum).tx_excitation);
guidata(hObject,handles);


