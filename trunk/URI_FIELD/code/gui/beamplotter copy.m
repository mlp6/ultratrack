function varargout = beamplotter(varargin)
% BEAMPLOTTER M-file for beamplotter.fig
%      BEAMPLOTTER, by itself, creates a new BEAMPLOTTER or raises the existing
%      singleton*.
%
%      H = BEAMPLOTTER returns the handle to a new BEAMPLOTTER or the handle to
%      the existing singleton*.
%
%      BEAMPLOTTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BEAMPLOTTER.M with the given input arguments.
%
%      BEAMPLOTTER('Property','Value',...) creates a new BEAMPLOTTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before beamplotter_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to beamplotter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help beamplotter

% Last Modified by GUIDE v2.5 10-Feb-2004 19:40:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @beamplotter_OpeningFcn, ...
                   'gui_OutputFcn',  @beamplotter_OutputFcn, ...
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


% --- Executes just before beamplotter is made visible.
function beamplotter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to beamplotter (see VARARGIN)

% Choose default command line output for beamplotter
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

probe=varargin{1};
beamset=varargin{2};
tx=varargin{3};
rx=varargin{4};
%beamset.no_beams=256;
%beamset.type='B'
%beamset.tx_f_num=1.8;
setappdata(hObject,'beamset',beamset);
setappdata(hObject,'probe',probe);
setappdata(hObject,'tx',tx);
setappdata(hObject,'rx',rx);
initialize_gui(hObject,handles,probe,beamset);
% UIWAIT makes beamplotter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = beamplotter_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in radiobutton_xz.
function radiobutton_xz_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_xz
setappdata(gcbf,'scanplane','xz');
set(handles.radiobutton_xz,'Value',1);
set(handles.radiobutton_yz,'Value',0);
set(handles.radiobutton_xy,'Value',0);
set(handles.yinc,'String','');set(handles.yinc,'Enable','inactive');
set(handles.ymax,'String','');set(handles.ymax,'Enable','inactive');
set(handles.xinc,'String',getappdata(gcbf,'xinc'));set(handles.xinc,'Enable','on');
set(handles.xmax,'String',getappdata(gcbf,'xmax'));set(handles.xmax,'Enable','on');
set(handles.zinc,'String',getappdata(gcbf,'zinc'));set(handles.zinc,'Enable','on');
set(handles.zmax,'String',getappdata(gcbf,'zmax'));set(handles.zmax,'Enable','on');



% --- Executes on button press in radiobutton_yz.
function radiobutton_yz_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_yz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_yz
setappdata(gcbf,'scanplane','yz');
set(handles.radiobutton_xz,'Value',0);
set(handles.radiobutton_yz,'Value',1);
set(handles.radiobutton_xy,'Value',0);
set(handles.xinc,'String','');set(handles.xinc,'Enable','inactive');
set(handles.xmax,'String','');set(handles.xmax,'Enable','inactive');
set(handles.yinc,'String',getappdata(gcbf,'yinc'));set(handles.yinc,'Enable','on');
set(handles.ymax,'String',getappdata(gcbf,'ymax'));set(handles.ymax,'Enable','on');
set(handles.zinc,'String',getappdata(gcbf,'zinc'));set(handles.zinc,'Enable','on');
set(handles.zmax,'String',getappdata(gcbf,'zmax'));set(handles.zmax,'Enable','on');




% --- Executes on button press in radiobutton_xy.
function radiobutton_xy_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_xy
setappdata(gcbf,'scanplane','xy');
set(handles.radiobutton_xz,'Value',0);
set(handles.radiobutton_yz,'Value',0);
set(handles.radiobutton_xy,'Value',1);
set(handles.zinc,'String','');set(handles.zinc,'Enable','inactive');
set(handles.zmax,'String','');set(handles.zmax,'Enable','inactive');
set(handles.xinc,'String',getappdata(gcbf,'xinc'));set(handles.xinc,'Enable','on');
set(handles.xmax,'String',getappdata(gcbf,'xmax'));set(handles.xmax,'Enable','on');
set(handles.yinc,'String',getappdata(gcbf,'yinc'));set(handles.yinc,'Enable','on');
set(handles.ymax,'String',getappdata(gcbf,'ymax'));set(handles.ymax,'Enable','on');




% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=getappdata(gcbf);
% Set beamset number and vector number
nset=get(handles.setnum,'Value');
vector=get(handles.vectornum,'Value');
% Set beam
data.beamset(nset);
uf_set_beam(data.tx,data.rx,data.probe,data.beamset,nset,vector);

% Calculate profile


figure;
if strcmp(data.simtype,'hptx'),
    switch data.scanplane
        case {'xz'}
            x=data.xmin:data.xinc:data.xmax;
            z=data.zmin:data.zinc:data.zmax;
            y=data.ymin;
            intensity=uf_beam_inten(data.tx,x,y,z);
            if (length(x)==1),
                plot(z,squeeze(intensity));
                xlabel('z');
                title(['Tx Beam Intensity at x=' num2str(x) ', y=' num2str(y)]);
            elseif (length(z)==1),
                plot(x,squeeze(intensity));
                xlabel('x');
                title(['Tx Beam Intensity at y=' num2str(y) ', z=' num2str(z)]);
            else
                imagesc(x,z,squeeze(intensity)');axis image;
                xlabel('x');ylabel('z');
                title(['Tx Beam Intensity at y=' num2str(y)]);

            end;
            
            
        case {'yz'}
            y=data.ymin:data.yinc:data.ymax;
            z=data.zmin:data.zinc:data.zmax;
            x=data.xmin;
            intensity=uf_beam_inten(data.tx,x,y,z);
            imagesc(y,z,squeeze(intensity)');axis image;
            xlabel('y');ylabel('z');   
            title('Tx Beam Intensity');
        case {'xy'}
            x=data.xmin:data.xinc:data.xmax;
            y=data.ymin:data.yinc:data.ymax;
            z=data.zmin;
            intensity=uf_beam_inten(data.tx,x,y,z);
            imagesc(x,y,squeeze(intensity)');axis image;
            xlabel('x');ylabel('y');   
            title('Tx Beam Intensity');
    end;
end;

if strcmp(data.simtype,'hprx'),
    switch data.scanplane
        case {'xz'}
            x=data.xmin:data.xinc:data.xmax;
            z=data.zmin:data.zinc:data.zmax;
            y=data.ymin;
            intensity=uf_beam_inten(data.rx,x,y,z);
            imagesc(x,z,squeeze(intensity)');axis image;
            xlabel('x');ylabel('z');
            title('Rx Beam Intensity');
        case {'yz'}
            y=data.ymin:data.yinc:data.ymax;
            z=data.zmin:data.zinc:data.zmax;
            x=data.xmin;
            intensity=uf_beam_inten(data.rx,x,y,z);
            imagesc(y,z,squeeze(intensity)');axis image;
            xlabel('y');ylabel('z');   
            title('Rx Beam Intensity');
        case {'xy'}
            x=data.xmin:data.xinc:data.xmax;
            y=data.ymin:data.yinc:data.ymax;
            z=data.zmin;
            intensity=uf_beam_inten(data.rx,x,y,z);
            imagesc(x,y,squeeze(intensity)');axis image;
            xlabel('x');ylabel('y');   
            title('Rx Beam Intensity');
    end;
end;
    



% --- Executes during object creation, after setting all properties.
function xmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




function xmin_Callback(hObject, eventdata, handles)
% hObject    handle to xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xmin as text
%        str2double(get(hObject,'String')) returns contents of xmin as a double
xmin=str2double(get(hObject,'String'));
setappdata(gcbf,'xmin',xmin);



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


% --- Executes during object creation, after setting all properties.
function radiobutton_xz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Value',1);



% --- Executes during object creation, after setting all properties.
function xmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function xmax_Callback(hObject, eventdata, handles)
% hObject    handle to xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xmax as text
%        str2double(get(hObject,'String')) returns contents of xmax as a double
setappdata(gcbf,'xmax',str2double(get(hObject,'String')));


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xmax as text
%        str2double(get(hObject,'String')) returns contents of xmax as a double


% --- Executes during object creation, after setting all properties.
function xstep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function xstep_Callback(hObject, eventdata, handles)
% hObject    handle to xstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xstep as text
%        str2double(get(hObject,'String')) returns contents of xstep as a double


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
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


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


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xmin as text
%        str2double(get(hObject,'String')) returns contents of xmin as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


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
function ymin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ymin_Callback(hObject, eventdata, handles)
% hObject    handle to ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ymin as text
%        str2double(get(hObject,'String')) returns contents of ymin as a double
setappdata(gcbf,'ymin',str2double(get(hObject,'String')));


% --- Executes during object creation, after setting all properties.
function zmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function zmin_Callback(hObject, eventdata, handles)
% hObject    handle to zmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zmin as text
%        str2double(get(hObject,'String')) returns contents of zmin as a double
setappdata(gcbf,'zmin',str2double(get(hObject,'String')));


% --- Executes during object creation, after setting all properties.
function xinc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xinc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function xinc_Callback(hObject, eventdata, handles)
% hObject    handle to xinc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xinc as text
%        str2double(get(hObject,'String')) returns contents of xinc as a double
xinc=str2double(get(hObject,'String'));
setappdata(gcbf,'xinc',xinc);


% --- Executes during object creation, after setting all properties.
function yinc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yinc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function yinc_Callback(hObject, eventdata, handles)
% hObject    handle to yinc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yinc as text
%        str2double(get(hObject,'String')) returns contents of yinc as a double
setappdata(gcbf,'yinc',str2double(get(hObject,'String')));


% --- Executes during object creation, after setting all properties.
function zinc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zinc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function zinc_Callback(hObject, eventdata, handles)
% hObject    handle to zinc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zinc as text
%        str2double(get(hObject,'String')) returns contents of zinc as a double
setappdata(gcbf,'zinc',str2double(get(hObject,'String')));


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xmax as text
%        str2double(get(hObject,'String')) returns contents of xmax as a double


% --- Executes during object creation, after setting all properties.
function ymax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ymax_Callback(hObject, eventdata, handles)
% hObject    handle to ymax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ymax as text
%        str2double(get(hObject,'String')) returns contents of ymax as a double
setappdata(gcbf,'ymax',str2double(get(hObject,'String')));


% --- Executes during object creation, after setting all properties.
function zmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function zmax_Callback(hObject, eventdata, handles)
% hObject    handle to zmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zmax as text
%        str2double(get(hObject,'String')) returns contents of zmax as a double
setappdata(gcbf,'zmax',str2double(get(hObject,'String')));


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over xmin.
function xmin_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


function initialize_gui(fig_handle,handles,probe,beamset)
%Start up in xz mode, so disable y increment and max, set xz button
setappdata(fig_handle,'scanplane','xz');
xmin = -0.002;
xinc = 0.0001;
xmax = 0.002;
ymin=0;
yinc=0.001;
ymax=0;
zmin=0.001;
zinc=0.001;
zmax=0.02;
setappdata(fig_handle, 'xmin', xmin);
setappdata(fig_handle, 'xinc', xinc);
setappdata(fig_handle, 'xmax', xmax);
setappdata(fig_handle, 'ymin', ymin);
setappdata(fig_handle, 'yinc', yinc);
setappdata(fig_handle, 'ymax', ymax);
setappdata(fig_handle, 'zmin', zmin);
setappdata(fig_handle, 'zinc', zinc);
setappdata(fig_handle, 'zmax', zmax);

set(handles.xmin, 'String', xmin);
set(handles.xinc, 'String', xinc);
set(handles.xmax, 'String', xmax);
set(handles.ymin, 'String', ymin);
set(handles.yinc,'String','');set(handles.yinc,'Enable','inactive');
set(handles.ymax,'String','');set(handles.ymax,'Enable','inactive');
set(handles.zmin, 'String', zmin);
set(handles.zinc, 'String', zinc);
set(handles.zmax, 'String', zmax);

setappdata(fig_handle,'simtype','hptx');
set(handles.radiobutton4,'Value',1);

set(handles.setnum,'String',1:length(beamset));
set(handles.setnum,'Value',1);

set(handles.vectornum,'String',1:beamset(1).no_beams);
set(handles.vectornum,'Value',round(beamset(1).no_beams/2));

vector=round(beamset(1).no_beams/2);
nset=get(handles.setnum,'Value');
focus_x=beamset(nset).tx_focus_range*sin(beamset(nset).direction(vector))+beamset(nset).origin(vector,1);
focus_y=0;
focus_z=beamset(nset).tx_focus_range*cos(beamset(nset).direction(vector));
set(handles.tx_focus_x,'String',sprintf('%1.3e',focus_x));
set(handles.tx_focus_y,'String',sprintf('%1.3e',focus_y));
set(handles.tx_focus_z,'String',sprintf('%1.3e',focus_z));

if (beamset(nset).is_dyn_focus),  % If dynamic receive focus mode
    set(handles.rx_focus_x,'String','dynamic');
    set(handles.rx_focus_y,'String','dynamic');
    set(handles.rx_focus_z,'String','dynamic');

else % otherwise setup the fixed receive focus:
    focus_x=beamset(set).rx_focus_range*sin(beamset(set).direction(vector))+beamset(set).origin(vector,1);
    focus_y=0;
    focus_z=beamset(set).rx_focus_range*cos(beamset(set).direction(vector));
    xdc_focus(Tx,0,[focus_x focus_y focus_z]); % Receive fixed focal point
    set(handles.rx_focus_x,'String',sprintf('%1.3e',focus_x));
    set(handles.rx_focus_y,'String',sprintf('%1.3e',focus_y));
    set(handles.rx_focus_z,'String',sprintf('%1.3e',focus_z));    
end; %end if


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4
setappdata(gcbf,'simtype','hptx');
set(handles.radiobutton4,'Value',1);
set(handles.radiobutton5,'Value',0);
set(handles.radiobutton6,'Value',0);




% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5
setappdata(gcbf,'simtype','hprx');
set(handles.radiobutton4,'Value',0);
set(handles.radiobutton5,'Value',1);
set(handles.radiobutton6,'Value',0);



% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6
setappdata(gcbf,'simtype','hhp');
set(handles.radiobutton4,'Value',0);
set(handles.radiobutton5,'Value',0);
set(handles.radiobutton6,'Value',1);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
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
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function vectornum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vectornum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in vectornum.
function vectornum_Callback(hObject, eventdata, handles)
% hObject    handle to vectornum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns vectornum contents as cell array
%        contents{get(hObject,'Value')} returns selected item from vectornum

% Figure out new tx & rx foci
beamset=getappdata(gcbf,'beamset');
probe=getappdata(gcbf,'probe');
vector=get(hObject,'Value');
nset=get(handles.setnum,'Value');
focus_x=beamset(nset).tx_focus_range*sin(beamset(nset).direction(vector))+beamset(nset).origin(vector,1);
focus_y=0;
focus_z=beamset(nset).tx_focus_range*cos(beamset(nset).direction(vector));
set(handles.tx_focus_x,'String',sprintf('%1.3e',focus_x));
set(handles.tx_focus_y,'String',sprintf('%1.3e',focus_y));
set(handles.tx_focus_z,'String',sprintf('%1.3e',focus_z));

if (beamset(nset).is_dyn_focus),  % If dynamic receive focus mode
    set(handles.rx_focus_x,'String','dynamic');
    set(handles.rx_focus_y,'String','dynamic');
    set(handles.rx_focus_z,'String','dynamic');

else % otherwise setup the fixed receive focus:
    focus_x=beamset(set).rx_focus_range*sin(beamset(set).direction(vector))+beamset(set).origin(vector,1);
    focus_y=0;
    focus_z=beamset(set).rx_focus_range*cos(beamset(set).direction(vector));
    xdc_focus(Tx,0,[focus_x focus_y focus_z]); % Receive fixed focal point
    set(handles.rx_focus_x,'String',sprintf('%1.3e',focus_x));
    set(handles.rx_focus_y,'String',sprintf('%1.3e',focus_y));
    set(handles.rx_focus_z,'String',sprintf('%1.3e',focus_z));    
end; %end if





% --- Executes during object creation, after setting all properties.
function setnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in setnum.
function setnum_Callback(hObject, eventdata, handles)
% hObject    handle to setnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns setnum contents as cell array
%        contents{get(hObject,'Value')} returns selected item from setnum
beamset=getappdata(gcbf,'beamset');
n=get(hObject,'Value');
s=[beamset(n).type 'mode'];
s={ ['    Mode:' beamset(n).type] 
    ['Tx F/num:' num2str(beamset(n).tx_f_num)]
    [' Tx Apod:' num2str(beamset(n).tx_apod_type)]};
set(handles.setinfo,'String',s);

beamset=getappdata(gcbf,'beamset');
probe=getappdata(gcbf,'probe');
vector=get(handles.vectornum,'Value');
nset=get(handles.setnum,'Value')
focus_x=beamset(nset).tx_focus_range*sin(beamset(nset).direction(vector))+beamset(nset).origin(vector,1);
focus_y=0;
focus_z=beamset(nset).tx_focus_range*cos(beamset(nset).direction(vector));
set(handles.tx_focus_x,'String',sprintf('%1.3e',focus_x));
set(handles.tx_focus_y,'String',sprintf('%1.3e',focus_y));
set(handles.tx_focus_z,'String',sprintf('%1.3e',focus_z));

if (beamset(nset).is_dyn_focus),  % If dynamic receive focus mode
    set(handles.rx_focus_x,'String','dynamic');
    set(handles.rx_focus_y,'String','dynamic');
    set(handles.rx_focus_z,'String','dynamic');

else % otherwise setup the fixed receive focus:
    focus_x=beamset(set).rx_focus_range*sin(beamset(set).direction(vector))+beamset(set).origin(vector,1);
    focus_y=0;
    focus_z=beamset(set).rx_focus_range*cos(beamset(set).direction(vector));
    xdc_focus(Tx,0,[focus_x focus_y focus_z]); % Receive fixed focal point
    set(handles.rx_focus_x,'String',sprintf('%1.3e',focus_x));
    set(handles.rx_focus_y,'String',sprintf('%1.3e',focus_y));
    set(handles.rx_focus_z,'String',sprintf('%1.3e',focus_z));    
end; %end if



% --- Executes during object creation, after setting all properties.
function setinfo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setinfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function setinfo_Callback(hObject, eventdata, handles)
% hObject    handle to setinfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of setinfo as text
%        str2double(get(hObject,'String')) returns contents of setinfo as a double


% --- Executes during object creation, after setting all properties.
function tx_focus_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tx_focus_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function tx_focus_z_Callback(hObject, eventdata, handles)
% hObject    handle to tx_focus_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tx_focus_z as text
%        str2double(get(hObject,'String')) returns contents of tx_focus_z as a double


% --- Executes during object creation, after setting all properties.
function tx_focus_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tx_focus_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function tx_focus_y_Callback(hObject, eventdata, handles)
% hObject    handle to tx_focus_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tx_focus_y as text
%        str2double(get(hObject,'String')) returns contents of tx_focus_y as a double


% --- Executes during object creation, after setting all properties.
function tx_focus_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tx_focus_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function tx_focus_x_Callback(hObject, eventdata, handles)
% hObject    handle to tx_focus_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tx_focus_x as text
%        str2double(get(hObject,'String')) returns contents of tx_focus_x as a double


% --- Executes during object creation, after setting all properties.
function rx_focus_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rx_focus_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function rx_focus_z_Callback(hObject, eventdata, handles)
% hObject    handle to rx_focus_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rx_focus_z as text
%        str2double(get(hObject,'String')) returns contents of rx_focus_z as a double


% --- Executes during object creation, after setting all properties.
function rx_focus_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rx_focus_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function rx_focus_y_Callback(hObject, eventdata, handles)
% hObject    handle to rx_focus_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rx_focus_y as text
%        str2double(get(hObject,'String')) returns contents of rx_focus_y as a double


% --- Executes during object creation, after setting all properties.
function rx_focus_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rx_focus_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function rx_focus_x_Callback(hObject, eventdata, handles)
% hObject    handle to rx_focus_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rx_focus_x as text
%        str2double(get(hObject,'String')) returns contents of rx_focus_x as a double


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over ymin.
function ymin_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


