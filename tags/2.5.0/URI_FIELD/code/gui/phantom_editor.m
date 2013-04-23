function varargout = phantom_editor(varargin)
% PHANTOM_EDITOR M-file for phantom_editor.fig
%      PHANTOM_EDITOR, by itself, creates a new PHANTOM_EDITOR or raises the existing
%      singleton*.
%
%      H = PHANTOM_EDITOR returns the handle to a new PHANTOM_EDITOR or the handle to
%      the existing singleton*.
%
%      PHANTOM_EDITOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PHANTOM_EDITOR.M with the given input arguments.
%
%      PHANTOM_EDITOR('Property','Value',...) creates a new PHANTOM_EDITOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before phantom_editor_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to phantom_editor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help phantom_editor

% Last Modified by GUIDE v2.5 13-Feb-2004 16:56:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @phantom_editor_OpeningFcn, ...
                   'gui_OutputFcn',  @phantom_editor_OutputFcn, ...
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


% --- Executes just before phantom_editor is made visible.
function phantom_editor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to phantom_editor (see VARARGIN)

% Choose default command line output for phantom_editor
handles.output = hObject;

% Make the GUI modal - User only interacts w/ this window until it's closed
set(handles.figure1,'WindowStyle','modal')

% Open a figure for displaying the phantom build up
handles.plot_fig=figure;

% Update handles structure
guidata(hObject, handles);
plot_phantom(hObject,handles);

% UIWAIT makes phantom_editor wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = phantom_editor_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

delete(handles.figure1);

% --- Executes during object creation, after setting all properties.
function pt_axial_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pt_axial_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function pt_axial_number_Callback(hObject, eventdata, handles)
% hObject    handle to pt_axial_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pt_axial_number as text
%        str2double(get(hObject,'String')) returns contents of pt_axial_number as a double
    
proc_input(hObject,handles,1,100);    
plot_phantom(hObject,handles);


% --- Executes during object creation, after setting all properties.
function pt_axial_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pt_axial_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function pt_axial_start_Callback(hObject, eventdata, handles)
% hObject    handle to pt_axial_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pt_axial_start as text
%        str2double(get(hObject,'String')) returns contents of pt_axial_start as a double
proc_input(hObject,handles,1e-6,0.2);
plot_phantom(hObject,handles);


% --- Executes during object creation, after setting all properties.
function pt_axial_space_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pt_axial_space (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function pt_axial_space_Callback(hObject, eventdata, handles)
% hObject    handle to pt_axial_space (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pt_axial_space as text
%        str2double(get(hObject,'String')) returns contents of pt_axial_space as a double
proc_input(hObject,handles,1e-6,0.2);
plot_phantom(hObject,handles);


% --- Executes during object creation, after setting all properties.
function pt_lateral_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pt_lateral_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function pt_lateral_number_Callback(hObject, eventdata, handles)
% hObject    handle to pt_lateral_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pt_lateral_number as text
%        str2double(get(hObject,'String')) returns contents of pt_lateral_number as a double
proc_input(hObject,handles,1,100);
plot_phantom(hObject,handles);


% --- Executes during object creation, after setting all properties.
function pt_lateral_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pt_lateral_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function pt_lateral_offset_Callback(hObject, eventdata, handles)
% hObject    handle to pt_lateral_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pt_lateral_offset as text
%        str2double(get(hObject,'String')) returns contents of pt_lateral_offset as a double
proc_input(hObject,handles,-0.1,0.1);
plot_phantom(hObject,handles);


% --- Executes during object creation, after setting all properties.
function pt_lateral_space_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pt_lateral_space (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function pt_lateral_space_Callback(hObject, eventdata, handles)
% hObject    handle to pt_lateral_space (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pt_lateral_space as text
%        str2double(get(hObject,'String')) returns contents of pt_lateral_space as a double
proc_input(hObject,handles,1e-6,0.2);
plot_phantom(hObject,handles);


% --- Executes during object creation, after setting all properties.
function pt_amplitude_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pt_amplitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function pt_amplitude_Callback(hObject, eventdata, handles)
% hObject    handle to pt_amplitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pt_amplitude as text
%        str2double(get(hObject,'String')) returns contents of pt_amplitude as a double
proc_input(hObject,handles,-inf,inf);

% --- Executes on button press in pt_enable.
function pt_enable_Callback(hObject, eventdata, handles)
% hObject    handle to pt_enable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pt_enable


% --- Executes on button press in diff_enable.
function diff_enable_Callback(hObject, eventdata, handles)
% hObject    handle to diff_enable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of diff_enable


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function diff_ax_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diff_ax_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function diff_ax_start_Callback(hObject, eventdata, handles)
% hObject    handle to diff_ax_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of diff_ax_start as text
%        str2double(get(hObject,'String')) returns contents of diff_ax_start as a double


% --- Executes during object creation, after setting all properties.
function diff_ax_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diff_ax_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function diff_ax_end_Callback(hObject, eventdata, handles)
% hObject    handle to diff_ax_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of diff_ax_end as text
%        str2double(get(hObject,'String')) returns contents of diff_ax_end as a double


% --- Executes during object creation, after setting all properties.
function diff_lat_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diff_lat_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function diff_lat_start_Callback(hObject, eventdata, handles)
% hObject    handle to diff_lat_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of diff_lat_start as text
%        str2double(get(hObject,'String')) returns contents of diff_lat_start as a double


% --- Executes during object creation, after setting all properties.
function diff_lat_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diff_lat_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function diff_lat_end_Callback(hObject, eventdata, handles)
% hObject    handle to diff_lat_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of diff_lat_end as text
%        str2double(get(hObject,'String')) returns contents of diff_lat_end as a double


% --- Executes during object creation, after setting all properties.
function diff_elv_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diff_elv_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function diff_elv_start_Callback(hObject, eventdata, handles)
% hObject    handle to diff_elv_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of diff_elv_start as text
%        str2double(get(hObject,'String')) returns contents of diff_elv_start as a double


% --- Executes during object creation, after setting all properties.
function diff_elv_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diff_elv_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function diff_elv_end_Callback(hObject, eventdata, handles)
% hObject    handle to diff_elv_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of diff_elv_end as text
%        str2double(get(hObject,'String')) returns contents of diff_elv_end as a double


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes on button press in lesion_enable.
function lesion_enable_Callback(hObject, eventdata, handles)
% hObject    handle to lesion_enable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lesion_enable


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Plots phantom

function plot_phantom(hObject, handles);
figure(handles.plot_fig);
p=make_point_targets(hObject,handles);
plot(p.position(:,1),p.position(:,3),'r*');
axis image;
if (min(p.position(:,1))==max(p.position(:,1)))
    if (min(p.position(:,3))~=max(p.position(:,3)))
        axis([[-0.001 0.001]+min(p.position(:,1)) min(p.position(:,3)) max(p.position(:,3)) ]);
    end;
end;
if (min(p.position(:,3))==max(p.position(:,3)))
    if (min(p.position(:,1))~=max(p.position(:,1)))
        axis([min(p.position(:,1)) max(p.position(:,1)) [-0.001 0.001]+min(p.position(:,3))]);
    end;
end;
axis ij;
set(handles.plot_fig,'Name','Phantom');
set(handles.plot_fig,'NumberTitle','off');
title('Phantom');
xlabel('x (meters)');
ylabel('z (meters)');
figure(handles.figure1);

function p=make_point_targets(hObject, handles)
ax_no=str2double(get(handles.pt_axial_number,'String'));
lat_no=str2double(get(handles.pt_lateral_number,'String'));
ax_min=str2double(get(handles.pt_axial_start,'String'));;
ax_space=str2double(get(handles.pt_axial_space,'String'));;
lat_offset=str2double(get(handles.pt_lateral_offset,'String'));
lat_space=str2double(get(handles.pt_lateral_space,'String'));
count=0;
for m=1:ax_no,
    for n=1:lat_no,
        count=count+1;
        p.position(count,:)=[lat_space*((n-1)-(lat_no-1)/2)+lat_offset 0 (m-1)*ax_space+ax_min];
        p.amplitude(count,1)=str2double(get(handles.pt_amplitude,'String'));
    end;
end;
        
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




% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes on button press in cancel_pushbutton.
function cancel_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Return empty vector for cancel
handles.output=[];  
% Update handles
guidata(hObject,handles);
% Start UI back up to exit.
uiresume(handles.figure1);


% --- Executes on button press in ok_pushbutton.
function ok_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to ok_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Dummy variable to concatenate on
phantom.position=[];
phantom.amplitude=[];

% Assemble the phantom

% First point targets
if (get(handles.pt_enable,'Value')),
    p=make_point_targets(hObject,handles);
    phantom.position =[phantom.position; p.position ];
    phantom.amplitude=[phantom.amplitude;p.amplitude];
end;

% Place it on handles.output & update handles

handles.output=phantom;
guidata(hObject,handles);
uiresume(handles.figure1);

