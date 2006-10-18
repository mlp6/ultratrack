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

% Last Modified by GUIDE v2.5 04-Mar-2004 14:10:44

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

% Get inputs
handles.probe=varargin{1};
handles.beamset=varargin{2};
handles.tx=varargin{3};
handles.rx=varargin{4};
if nargin>7
    bpsettings=varargin{5};
else
    % if no input bpsettings:
    bpsettings.scanplane='xz';
    bpsettings.simtype='hptx';
    bpsettings.xmin = -0.002;
    bpsettings.xinc = 0.0001;
    bpsettings.xmax = 0.002;
    bpsettings.ymin=0;
    bpsettings.yinc=0.001;
    bpsettings.ymax=0;
    bpsettings.zmin=0.001;
    bpsettings.zinc=0.001;
    bpsettings.zmax=0.02;
    bpsettings.setnum=1;
    bpsettings.vectornum=round(handles.beamset(bpsettings.setnum).no_beams/2);
end;

handles.bpsettings=bpsettings;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject,handles);
% UIWAIT makes beamplotter wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = beamplotter_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
bpsettings.scanplane=handles.scanplane;
bpsettings.simtype=handles.simtype;
bpsettings.xmin=get(handles.xmin,'Value');
bpsettings.xinc=get(handles.xinc,'Value');
bpsettings.xmax=get(handles.xmax,'Value');
bpsettings.ymin=get(handles.ymin,'Value');
bpsettings.yinc=get(handles.yinc,'Value');
bpsettings.ymax=get(handles.ymax,'Value');
bpsettings.zmin=get(handles.zmin,'Value');
bpsettings.zinc=get(handles.zinc,'Value');
bpsettings.zmax=get(handles.zmax,'Value');
bpsettings.setnum=get(handles.setnum,'Value');
bpsettings.vectornum=get(handles.vectornum,'Value');
varargout{1} = bpsettings;
delete(handles.figure1);

% --- Executes on button press in radiobutton_xz.
function radiobutton_xz_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_xz
handles.scanplane='xz';
guidata(hObject,handles);
set(handles.radiobutton_xz,'Value',1);
set(handles.radiobutton_yz,'Value',0);
set(handles.radiobutton_xy,'Value',0);
set(handles.yinc,'Visible','off');
set(handles.ymax,'Visible','off');
set(handles.xinc,'Visible','on');
set(handles.xmax,'Visible','on');
set(handles.zinc,'Visible','on');
set(handles.zmax,'Visible','on');


% --- Executes on button press in radiobutton_yz.
function radiobutton_yz_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_yz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_yz
handles.scanplane='yz';
guidata(hObject,handles);
set(handles.radiobutton_xz,'Value',0);
set(handles.radiobutton_yz,'Value',1);
set(handles.radiobutton_xy,'Value',0);
set(handles.xinc,'Visible','off');
set(handles.xmax,'Visible','off');
set(handles.yinc,'Visible','on');
set(handles.ymax,'Visible','on');
set(handles.zinc,'Visible','on');
set(handles.zmax,'Visible','on');


% --- Executes on button press in radiobutton_xy.
function radiobutton_xy_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_xy
handles.scanplane='xy';
guidata(hObject,handles);
set(handles.radiobutton_xz,'Value',0);
set(handles.radiobutton_yz,'Value',0);
set(handles.radiobutton_xy,'Value',1);
set(handles.zinc,'Visible','off');
set(handles.zmax,'Visible','off');
set(handles.xinc,'Visible','on');
set(handles.xmax,'Visible','on');
set(handles.yinc,'Visible','on');
set(handles.ymax,'Visible','on');




% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set beamset number and vector number
nset=get(handles.setnum,'Value');
vector=get(handles.vectornum,'Value');

% Set beam
uf_set_beam(handles.tx,handles.rx,handles.probe,handles.beamset,nset,vector);

% Get values of plane coordinates
xmin=get(handles.xmin,'Value');
ymin=get(handles.ymin,'Value');
zmin=get(handles.zmin,'Value');
xinc=get(handles.xinc,'Value');
yinc=get(handles.yinc,'Value');
zinc=get(handles.zinc,'Value');
xmax=get(handles.xmax,'Value');
ymax=get(handles.ymax,'Value');
zmax=get(handles.zmax,'Value');

% Calculate profile
figure;
switch handles.scanplane,
    case {'xz'},
        x=xmin:xinc:xmax;
        z=zmin:zinc:zmax;
        y=ymin;
        if strcmp(handles.simtype,'hptx'),
            intensity=uf_beam_inten(handles.tx,x,y,z);
        elseif strcmp(handles.simtype,'hprx'),
            intensity=uf_beam_inten(handles.rx,x,y,z);
        else
            intensity=uf_beam_inten(handles.tx,handles.rx,x,y,z);
        end;
        plotit(x,y,z,intensity);
    case {'yz'},
        y=ymin:yinc:ymax;
        z=zmin:zinc:zmax;
        x=xmin;
        if strcmp(handles.simtype,'hptx'),
            intensity=uf_beam_inten(handles.tx,x,y,z);
        elseif strcmp(handles.simtype,'hprx'),
            intensity=uf_beam_inten(handles.rx,x,y,z);
        else
            intensity=uf_beam_inten(handles.tx,handles.rx,x,y,z);
        end;
        plotit(x,y,z,intensity);
    case {'xy'},
        x=xmin:xinc:xmax;
        y=ymin:yinc:ymax;
        z=zmin;
        if strcmp(handles.simtype,'hptx'),
            intensity=uf_beam_inten(handles.tx,x,y,z);
        elseif strcmp(handles.simtype,'hprx'),
            intensity=uf_beam_inten(handles.rx,x,y,z);
        else
            intensity=uf_beam_inten(handles.tx,handles.rx,x,y,z);
        end;
        plotit(x,y,z,intensity);
end;

    
function plotit(x,y,z,data)
% Plots 1 or 2 D data, orients properly 
dimvector=size(data);  % Vector of dimensions of data
if length(dimvector)==2 dimvector=[dimvector 1]; end;
a{1}=x;
a{2}=y;
a{3}=z;
labels=['x','y','z'];
num_non_singleton=sum(dimvector>1); % dimensionality of data, 1d, 2d or 3d
I=find(dimvector>1); % indecies of non-singleton dimensions
J=find(dimvector==1); % indicies of singleton dimensions
if num_non_singleton==1,
    % It's a line plot!
    plot(a{I},squeeze(data));
    xlabel(labels(I));
    title(['Beam Intensity at ' labels(J(1)) '=' num2str(a{J(1)}) ', ' labels(J(2)) '=' num2str(a{J(2)})]);
elseif num_non_singleton==2,
    % It's a 2D plot!
    imagesc(a{I(1)},a{I(2)},squeeze(data)');
    axis image;
    xlabel(labels(I(1)));
    ylabel(labels(I(2)));
    title(['Beam Intensity at ' labels(J) '=' num2str(a{J})]);
else
    disp('No support yet for 3D volumes.  Sorry!');
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

% Erase when done
%xmin=str2double(get(hObject,'String'));
%setappdata(gcbf,'xmin',xmin);
proc_input(hObject,handles,-1,1);


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

%Erase
%setappdata(gcbf,'xmax',str2double(get(hObject,'String')));
proc_input(hObject,handles,-1,1);



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

%Erase
%setappdata(gcbf,'ymin',str2double(get(hObject,'String')));
proc_input(hObject,handles,-1,1);


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

% Erase
%setappdata(gcbf,'zmin',str2double(get(hObject,'String')));
proc_input(hObject,handles,0,1);


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

% Erase
%xinc=str2double(get(hObject,'String'));
%setappdata(gcbf,'xinc',xinc);
proc_input(hObject,handles,0,1);


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

% Erase
%setappdata(gcbf,'yinc',str2double(get(hObject,'String')));
proc_input(hObject,handles,0,1);


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

% Erase
% setappdata(gcbf,'zinc',str2double(get(hObject,'String')));
proc_input(hObject,handles,0,1);



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

%Erase setappdata(gcbf,'ymax',str2double(get(hObject,'String')));
proc_input(hObject,handles,-1,1);


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

% Erase setappdata(gcbf,'zmax',str2double(get(hObject,'String')));
proc_input(hObject,handles,-1,1);


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


function initialize_gui(hObject,handles)
handles.scanplane=handles.bpsettings.scanplane;
handles.simtype=handles.bpsettings.simtype;;
guidata(hObject,handles);
eventdata=[];

%callback for scanplane
if strcmp(handles.scanplane,'xy')
    radiobutton_xy_Callback(hObject, eventdata, handles);
elseif strcmp(handles.scanplane,'yz')
    radiobutton_yz_Callback(hObject, eventdata, handles);
else
    radiobutton_xz_Callback(hObject, eventdata, handles);
end;

%callback for simtype
if strcmp(handles.simtype,'hptx')
    radiobutton4_Callback(hObject, eventdata, handles);
elseif strcmp(handles.simtype,'hprx')
    radiobutton5_Callback(hObject, eventdata, handles);
else
    radiobutton6_Callback(hObject, eventdata, handles);
end;
set(handles.xmin,'String',num2str(handles.bpsettings.xmin));xmin_Callback(handles.xmin,eventdata,handles);
set(handles.xinc,'String',num2str(handles.bpsettings.xinc));xinc_Callback(handles.xinc,eventdata,handles);
set(handles.xmax,'String',num2str(handles.bpsettings.xmax));xmax_Callback(handles.xmax,eventdata,handles);
set(handles.ymin,'String',num2str(handles.bpsettings.ymin));ymin_Callback(handles.ymin,eventdata,handles);
set(handles.yinc,'String',num2str(handles.bpsettings.yinc));yinc_Callback(handles.yinc,eventdata,handles);
set(handles.ymax,'String',num2str(handles.bpsettings.ymax));ymax_Callback(handles.ymax,eventdata,handles);
set(handles.zmin,'String',num2str(handles.bpsettings.zmin));zmin_Callback(handles.zmin,eventdata,handles);
set(handles.zinc,'String',num2str(handles.bpsettings.zinc));zinc_Callback(handles.zinc,eventdata,handles);
set(handles.zmax,'String',num2str(handles.bpsettings.zmax));zmax_Callback(handles.zmax,eventdata,handles);

%Setup setnumber and vectornumber controls
set(handles.setnum,'String',1:length(handles.beamset));
if handles.bpsettings.setnum>length(handles.beamset)
    handles.bpsettings.setnum=1;
end;
set(handles.setnum,'Value',handles.bpsettings.setnum);

set(handles.vectornum,'String',1:handles.beamset(1).no_beams);
if handles.bpsettings.vectornum>handles.beamset(handles.bpsettings.setnum).no_beams,
    handles.bpsettings.vectornum=round(handles.beamset(handles.bpsettings.setnum).no_beams/2);
end;
set(handles.vectornum,'Value',handles.bpsettings.vectornum);

%callbacks for setnum & vectornum
setnum_Callback(handles.setnum, eventdata, handles)
vectornum_Callback(handles.vectornum, eventdata, handles)


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4
handles.simtype='hptx';
guidata(hObject,handles);
set(handles.radiobutton4,'Value',1);
set(handles.radiobutton5,'Value',0);
set(handles.radiobutton6,'Value',0);




% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5
handles.simtype='hprx';
guidata(hObject,handles);
set(handles.radiobutton4,'Value',0);
set(handles.radiobutton5,'Value',1);
set(handles.radiobutton6,'Value',0);



% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6
handles.simtype='hhp';
guidata(hObject,handles);
set(handles.radiobutton4,'Value',0);
set(handles.radiobutton5,'Value',0);
set(handles.radiobutton6,'Value',1);




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
vector=get(hObject,'Value');
nset=get(handles.setnum,'Value');
focus_x=handles.beamset(nset).tx_focus_range*sin(handles.beamset(nset).direction(vector))+handles.beamset(nset).origin(vector,1);
focus_y=0;
focus_z=handles.beamset(nset).tx_focus_range*cos(handles.beamset(nset).direction(vector));
set(handles.tx_focus_x,'String',sprintf('%1.3e',focus_x));
set(handles.tx_focus_y,'String',sprintf('%1.3e',focus_y));
set(handles.tx_focus_z,'String',sprintf('%1.3e',focus_z));

if (handles.beamset(nset).is_dyn_focus),  % If dynamic receive focus mode
    set(handles.rx_focus_x,'String','dynamic');
    set(handles.rx_focus_y,'String','dynamic');
    set(handles.rx_focus_z,'String','dynamic');

else % otherwise setup the fixed receive focus:
    focus_x=handles.beamset(set).rx_focus_range*sin(handles.beamset(set).direction(vector))+handles.beamset(set).origin(vector,1);
    focus_y=0;
    focus_z=handles.beamset(set).rx_focus_range*cos(handles.beamset(set).direction(vector));
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
n=get(hObject,'Value');
s=[handles.beamset(n).type 'mode'];
s={ ['    Mode:' handles.beamset(n).type] 
    ['Tx F/num:' num2str(handles.beamset(n).tx_f_num)]
    [' Tx Apod:' num2str(handles.beamset(n).tx_apod_type)]};
set(handles.setinfo,'String',s);

vector=get(handles.vectornum,'Value');
nset=get(handles.setnum,'Value');
focus_x=handles.beamset(nset).tx_focus_range*sin(handles.beamset(nset).direction(vector))+handles.beamset(nset).origin(vector,1);
focus_y=0;
focus_z=handles.beamset(nset).tx_focus_range*cos(handles.beamset(nset).direction(vector));
set(handles.tx_focus_x,'String',sprintf('%1.3e',focus_x));
set(handles.tx_focus_y,'String',sprintf('%1.3e',focus_y));
set(handles.tx_focus_z,'String',sprintf('%1.3e',focus_z));

if (handles.beamset(nset).is_dyn_focus),  % If dynamic receive focus mode
    set(handles.rx_focus_x,'String','dynamic');
    set(handles.rx_focus_y,'String','dynamic');
    set(handles.rx_focus_z,'String','dynamic');

else % otherwise setup the fixed receive focus:
    focus_x=handles.beamset(set).rx_focus_range*sin(handles.beamset(set).direction(vector))+handles.beamset(set).origin(vector,1);
    focus_y=0;
    focus_z=handles.beamset(set).rx_focus_range*cos(handles.beamset(set).direction(vector));
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


% --- Executes on button press in exitbutton.
function exitbutton_Callback(hObject, eventdata, handles)
% hObject    handle to exitbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiresume(handles.figure1);
