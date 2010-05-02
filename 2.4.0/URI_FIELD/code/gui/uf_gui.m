function varargout = uf_gui(varargin)
% UF_GUI M-file for uf_gui.fig
%      UF_GUI, by itself, creates a new UF_GUI or raises the existing
%      singleton*.
%
%      H = UF_GUI returns the handle to a new UF_GUI or the handle to
%      the existing singleton*.
%
%      UF_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UF_GUI.M with the given input arguments.
%
%      UF_GUI('Property','Value',...) creates a new UF_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before uf_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to uf_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help uf_gui

% Last Modified by GUIDE v2.5 03-Mar-2004 14:28:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uf_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @uf_gui_OutputFcn, ...
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


% --- Executes just before uf_gui is made visible.
function uf_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to uf_gui (see VARARGIN)

% Choose default command line output for uf_gui
handles.output = hObject;

% Try to start field
try
    field_init(0);
catch
    s=lasterr;
    if strcmp(s(1:39),'Field error: Field already initialized.')
        disp('Field already initialized!');
    else
        disp('Error while trying to start Field II!!');
        disp('Make sure Field II is in your Matlab path');
        %delete(handles.figure1);
        %guidata(handles.hObject);
        error('Couldn''t start Field');
    end;
end;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes uf_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = uf_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function openuri_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[rf,head]=readFile;
if (isempty(head)), 
    return;
end;
[probe,beamset]=uf_parameters(head);
if isempty(probe),
    disp('No probe data loaded');
    return;
end;
if isempty(beamset),
    disp('No beamset data loaded');
    return;
end;
handles.probe=probe;
handles.beamset=beamset;
s=sprintf('%d element %s array',probe.no_elements,probe.probe_type);
set(handles.probe_stat,'String',s);
n=length(beamset);
if (n>1),
    s=sprintf('%d beamsets',n);
else;
    s='1 beamset';
end;
set(handles.beamset_stat,'String',s);
set(handles.sim_menu,'Enable','on');
if (isfield(handles,'tx')),
    xdc_free(handles.tx);
    xdc_free(handles.rx);
end;
[handles.tx,handles.rx]=uf_make_xdc(probe);
guidata(hObject,handles);

% --------------------------------------------------------------------
function savem_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,pathname]=uiputfile('*.mat');
if filename==0,
    return;
end;

count=0;
if isfield(handles,'probe') 
    probe=handles.probe;
    count=count+1;
    vars{count}='probe'; 
end;
if isfield(handles,'beamset') 
    beamset=handles.beamset;
    count=count+1;
    vars{count}='beamset';
end;
if isfield(handles,'phantom') 
    phantom=handles.phantom;
    count=count+1;
    vars{count}='phantom';
end;

if isfield(handles,'atten_coef')
    atten_coef=handles.atten_coef;
    atten_f0=handles.atten_f0;
    vars{count+1}='atten_coef';
    vars{count+2}='atten_f0';
    count=count+2;    
end;


if count==0 
    questdlg('Nothing to save!','','OK','OK');
    return;
end;

save(strcat(pathname,filename),vars{1});    

for n=2:count,
    save('-append',strcat(pathname,filename),vars{n});
end;


% --------------------------------------------------------------------
function quit_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end
field_end;
delete(handles.figure1);

% --------------------------------------------------------------------
function sim_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% TURN ON/OFF ALL SIMULATION OPTIONS BASED ON AVAILABILITY OF DATA

if (isfield(handles,'probe') & isfield(handles,'beamset'))
    % Enable sims requiring probe and beamset
    set(handles.sim_beamplot,'Enable','on');
else
    set(handles.sim_beamplot,'Enable','off');
end;
    
if (isfield(handles,'probe') & isfield(handles,'beamset') & isfield(handles,'phantom'))
    %Enable sims requireing probe and beamset and phantom 
    set(handles.sim_scan,'Enable','on');
else
    set(handles.sim_scan,'Enable','off');

end;




% --------------------------------------------------------------------
function sim_beamplot_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'bpsettings')
    handles.bpsettings=beamplotter(handles.probe,handles.beamset,handles.tx,handles.rx,handles.bpsettings);
else
    handles.bpsettings=beamplotter(handles.probe,handles.beamset,handles.tx,handles.rx);
end;
guidata(hObject,handles);

% --------------------------------------------------------------------
function sim_scan_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
scan(handles.probe,handles.beamset,handles.tx,handles.rx,handles.phantom);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'probe'),
    p=probe_editor(handles.probe);
else
    p=probe_editor;
end;
if isempty(p),
    return;
end;
handles.probe=p;
s=sprintf('%d element %s array',p.no_elements,p.probe_type);
set(handles.probe_stat,'String',s);

if (isfield(handles,'tx')),
    xdc_free(handles.tx);
    xdc_free(handles.rx);
end;
[handles.tx,handles.rx]=uf_make_xdc(handles.probe);
guidata(hObject,handles);


% --------------------------------------------------------------------
function my_help_Callback(hObject, eventdata, handles)
% hObject    handle to my_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function doc_Callback(hObject, eventdata, handles)
% hObject    handle to doc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s=which('URI_Field_tools_manual.pdf');
if isempty(s)
    disp('URI_Field_tools_manual.pdf isn''t in the Matlab path!');
    return;
end;
switch (computer)
    case {'MAC'}
        s=['open ' s];
        system(s);
    case {'GLNX86'}
        s=['xpdf ' s ' &'];
        system(s);
    case {'PCWIN'}
        s=['start acroread ' s ];
        system(s);
end;


% --------------------------------------------------------------------
function openm_Callback(hObject, eventdata, handles)
% hObject    handle to openm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile('*.mat');
if filename==0,
    return;
end;
s=load(strcat(pathname,filename));

if isfield(s,'probe') 
    handles.probe=s.probe; 
    q=sprintf('%d element %s array',handles.probe.no_elements,handles.probe.probe_type);
    set(handles.probe_stat,'String',q);
end;
if isfield(s,'beamset') 
    handles.beamset=s.beamset;
    if length(handles.beamset)==1;
        set(handles.beamset_stat,'String','1 beamset');
    else
        q=sprintf('%d beamsets',length(handles.beamset));
        set(handles.probe_stat,'String',q);
    end;
end;
if isfield(s,'phantom') 
    handles.phantom=s.phantom;
    set(handles.phantom_stat,'String','Phantom loaded');
end;
if isfield(s,'atten_coef')
    handles.atten_coef=s.atten_coef;
    handles.atten_f0=s.atten_f0;
    guidata(hObject,handles);
    set_field_attenuation(hObject,handles);
end;
guidata(hObject,handles);






% --- Executes on mouse press over figure background.
function figure1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isfield(handles,'probe')
    questdlg('You must specify a probe first','','OK','OK');
    return;
end;

% Call the beamset editor
if isfield(handles,'beamset')
    beamset=beamseteditor(handles.probe,handles.beamset);
else
    beamset=beamseteditor(handles.probe);
end;

% If we got a phantom back from the editor, put it on the handles 
% update the status indicator and update the handles.
if (~isempty(beamset))
    handles.beamset=beamset;
    guidata(hObject,handles);
    if length(beamset)>1,
        set(handles.beamset_stat,'String',[num2str(length(beamset)) ' beamsets']);
    else
        set(handles.beamset_stat,'String','1 beamset');
    end;
end;



% --------------------------------------------------------------------
function slack_Callback(hObject, eventdata, handles)
% hObject    handle to slack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch (computer)
    case {'MAC'}
        %system('open /Applications/Safari.app');
        system('open http://dukemil.egr.duke.edu/~sam/uri/');
    case {'GLNX86'}
        system('mozilla http://dukemil.egr.duke.edu/~sam/uri/ &');
        
    case {'PCWIN'}
        system('start iexplore http://dukemil.egr.duke.edu/~sam/uri/');
end;


% --- Executes on button press in p_points_check.
function p_points_check_Callback(hObject, eventdata, handles)
% hObject    handle to p_points_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of p_points_check


% --- Executes on button press in p_diffuse_check.
function p_diffuse_check_Callback(hObject, eventdata, handles)
% hObject    handle to p_diffuse_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of p_diffuse_check


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in p_points_setting.
function p_points_setting_Callback(hObject, eventdata, handles)
% hObject    handle to p_points_setting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in phan_ed_button.
function phan_ed_button_Callback(hObject, eventdata, handles)
% hObject    handle to phan_ed_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Call the phantom editor
phantom=phantom_editor;

% If we got a phantom back from the editor, put it on the handles 
% update the status indicator and update the handles.
if (~isempty(phantom))
    handles.phantom=phantom;
    guidata(hObject,handles);
    set(handles.phantom_stat,'String','Editor Phantom');
end;



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function clearall_Callback(hObject, eventdata, handles)
% hObject    handle to clearall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selection = questdlg('Clear Probe, Beamset and Phantom?','','Yes','No','No');
if strcmp(selection,'No')
    return;
end

if isfield(handles,'beamset') handles=rmfield(handles,'beamset'); end;
if isfield(handles,'phantom') handles=rmfield(handles,'phantom'); end
if isfield(handles,'probe') handles=rmfield(handles,'probe'); end;

guidata(hObject,handles);

set(handles.probe_stat,'String','No Probe');
set(handles.beamset_stat,'String','No Beamset');
set(handles.phantom_stat,'String','No Phantom');


% --------------------------------------------------------------------
function set_atten_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'atten_coef'),
    [coef,f0]=atten(handles.atten_coef,handles.atten_f0);
else
    [coef,f0]=atten;
end;

if isempty(coef)
    return;
else
    handles.atten_coef=coef;
    handles.atten_f0=f0;
    guidata(hObject,handles);
    set_field_attenuation(hObject,handles);
end;


function set_field_attenuation(hObject,handles)
% Sets attenuation in Field_II sims.  If coef is zero, attenuation is
% turned off.  coef is the attenuation coeffcient in dB/cm/MHz, f0 is the
% frequency about which the attenuation is estimated, in Hz
if handles.atten_coef==0,
    set_field('use_att',0);
    set(handles.atten_annunciator,'String','No attenuation');

else
    set_field ('att',handles.atten_coef*100*handles.atten_f0/1e6);
    set_field ('Freq_att',handles.atten_coef*100/1e6);
    set_field ('att_f0',handles.atten_f0);
    set_field ('use_att',1);
    set(handles.atten_annunciator,'String',[num2str(handles.atten_coef) ' dB/cm/MHz']);    
end;
