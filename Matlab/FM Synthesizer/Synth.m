function varargout = Synth(varargin)
% SYNTH MATLAB code for Synth.fig
%      SYNTH, by itself, creates a new SYNTH or raises the existing
%      singleton*.
%
%      H = SYNTH returns the handle to a new SYNTH or the handle to
%      the existing singleton*.
%
%      SYNTH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SYNTH.M with the given input arguments.
%
%      SYNTH('Property','Value',...) creates a new SYNTH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Synth_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Synth_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Synth

% Last Modified by GUIDE v2.5 27-Jan-2015 18:22:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Synth_OpeningFcn, ...
                   'gui_OutputFcn',  @Synth_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Synth is made visible.
function Synth_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Synth (see VARARGIN)

% Choose default command line output for Synth
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Synth wait for user response (see UIRESUME)
% uiwait(handles.figure1);

attack_init = 0.1;
decay_init = 0;
sustain_init = 1;
release_init = 0.01;
slope_attack_init = 0.25;
slope_decay_init = 0.25;
slope_release_init = 0.25;


%%%%%%%%%%%%%%%%INICIALITZACIO%%%%%%%%%%%%%%%%%%%%%

set(handles.freq_in, 'String', '220' );
set(handles.Time_in, 'String', '3' );


set(handles.attack1, 'Value', attack_init);
set(handles.decay1, 'Value', decay_init);
set(handles.sustain1, 'Value', sustain_init);
set(handles.release1, 'Value', release_init );
set(handles.attack2, 'Value', attack_init);
set(handles.decay2, 'Value', decay_init);
set(handles.sustain2, 'Value', sustain_init);
set(handles.release2, 'Value', release_init );
set(handles.attack3, 'Value', attack_init);
set(handles.decay3, 'Value', decay_init);
set(handles.sustain3, 'Value', sustain_init);
set(handles.release3, 'Value', release_init );
set(handles.attack4, 'Value', attack_init);
set(handles.decay4, 'Value', decay_init);
set(handles.sustain4, 'Value', sustain_init);
set(handles.release4, 'Value', release_init );

set(handles.slope_attack1, 'Value', slope_attack_init);
set(handles.slope_decay1, 'Value', slope_decay_init);
set(handles.slope_release1, 'Value', slope_release_init );
set(handles.slope_attack2, 'Value', slope_attack_init);
set(handles.slope_decay2, 'Value', slope_decay_init);
set(handles.slope_release2, 'Value', slope_release_init );
set(handles.slope_attack3, 'Value', slope_attack_init);
set(handles.slope_decay3, 'Value', slope_decay_init);
set(handles.slope_release3, 'Value', slope_release_init );
set(handles.slope_attack4, 'Value', slope_attack_init);
set(handles.slope_decay4, 'Value', slope_decay_init);
set(handles.slope_release4, 'Value', slope_release_init );







play=0;
Refresh;
Envelope();





% --- Outputs from this function are returned to the command line.
function varargout = Synth_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function vol1_Callback(hObject, eventdata, handles)
% hObject    handle to vol1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Refresh;

% --- Executes during object creation, after setting all properties.
function vol1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vol1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function oct_sel1_Callback(hObject, eventdata, handles)
% hObject    handle to oct_sel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of oct_sel1 as text
%        str2double(get(hObject,'String')) returns contents of oct_sel1 as a double
Refresh;

% --- Executes during object creation, after setting all properties.
function oct_sel1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to oct_sel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in wave_sel_osc1.
function wave_sel_osc1_Callback(hObject, eventdata, handles)
% hObject    handle to wave_sel_osc1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns wave_sel_osc1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from wave_sel_osc1

Refresh;






% --- Executes during object creation, after setting all properties.
function wave_sel_osc1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wave_sel_osc1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Refresh;




% --- Executes on slider movement.
function vol2_Callback(hObject, eventdata, handles)
% hObject    handle to vol2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Refresh;

% --- Executes during object creation, after setting all properties.
function vol2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vol2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function oct_sel2_Callback(hObject, eventdata, handles)
% hObject    handle to oct_sel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of oct_sel2 as text
%        str2double(get(hObject,'String')) returns contents of oct_sel2 as a double
Refresh;


% --- Executes during object creation, after setting all properties.
function oct_sel2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to oct_sel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in wave_sel_osc2.
function wave_sel_osc2_Callback(hObject, eventdata, handles)
% hObject    handle to wave_sel_osc2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns wave_sel_osc2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from wave_sel_osc2
Refresh;


% --- Executes during object creation, after setting all properties.
function wave_sel_osc2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wave_sel_osc2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function freq_in_Callback(hObject, eventdata, handles)
% hObject    handle to freq_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of freq_in as text
%        str2double(get(hObject,'String')) returns contents of freq_in as a double
Refresh;


% --- Executes during object creation, after setting all properties.
function freq_in_CreateFcn(hObject, eventdata, handles)
% hObject    handle to freq_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function phase1_Callback(hObject, eventdata, handles)
% hObject    handle to phase1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Refresh;

% --- Executes during object creation, after setting all properties.
function phase1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phase1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function phase2_Callback(hObject, eventdata, handles)
% hObject    handle to phase2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Refresh;


% --- Executes during object creation, after setting all properties.
function phase2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phase2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Refresh;
Sound;



function Time_in_Callback(hObject, eventdata, handles)
% hObject    handle to Time_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Time_in as text
%        str2double(get(hObject,'String')) returns contents of Time_in as a double
Refresh;


% --- Executes during object creation, after setting all properties.
function Time_in_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Time_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function vol3_Callback(hObject, eventdata, handles)
Refresh();



% --- Executes during object creation, after setting all properties.
function vol3_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function oct_sel3_Callback(hObject, eventdata, handles)
Refresh();

function oct_sel3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to oct_sel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in wave_sel_osc3.
function wave_sel_osc3_Callback(hObject, eventdata, handles)
Refresh();



% --- Executes during object creation, after setting all properties.
function wave_sel_osc3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wave_sel_osc3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function phase3_Callback(hObject, eventdata, handles)
Refresh();

function phase3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phase3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function vol4_Callback(hObject, eventdata, handles)
% hObject    handle to vol4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Refresh();

% --- Executes during object creation, after setting all properties.
function vol4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vol4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function oct_sel4_Callback(hObject, eventdata, handles)
Refresh();


% --- Executes during object creation, after setting all properties.
function oct_sel4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to oct_sel4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in wave_sel_osc4.
function wave_sel_osc4_Callback(hObject, eventdata, handles)
Refresh();


% --- Executes during object creation, after setting all properties.
function wave_sel_osc4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wave_sel_osc4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function phase4_Callback(hObject, eventdata, handles)
Refresh();

function phase4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phase4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function attack1_Callback(hObject, eventdata, handles)
% hObject    handle to attack1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Envelope();


% --- Executes during object creation, after setting all properties.
function attack1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to attack1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function decay1_Callback(hObject, eventdata, handles)
% hObject    handle to decay1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Envelope();


% --- Executes during object creation, after setting all properties.
function decay1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to decay1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sustain1_Callback(hObject, eventdata, handles)
% hObject    handle to sustain1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Envelope();


% --- Executes during object creation, after setting all properties.
function sustain1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sustain1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function release1_Callback(hObject, eventdata, handles)
% hObject    handle to release1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Envelope();

% --- Executes during object creation, after setting all properties.
function release1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to release1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function attack4_Callback(hObject, eventdata, handles)
% hObject    handle to attack4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function attack4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to attack4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function decay4_Callback(hObject, eventdata, handles)
% hObject    handle to decay4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function decay4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to decay4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sustain4_Callback(hObject, eventdata, handles)
% hObject    handle to sustain4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sustain4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sustain4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function release4_Callback(hObject, eventdata, handles)
% hObject    handle to release4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function release4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to release4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function attack3_Callback(hObject, eventdata, handles)
% hObject    handle to attack3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function attack3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to attack3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function decay3_Callback(hObject, eventdata, handles)
% hObject    handle to decay3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function decay3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to decay3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sustain3_Callback(hObject, eventdata, handles)
% hObject    handle to sustain3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Envelope();


% --- Executes during object creation, after setting all properties.
function sustain3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sustain3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function release3_Callback(hObject, eventdata, handles)
% hObject    handle to release3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Envelope();


% --- Executes during object creation, after setting all properties.
function release3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to release3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function attack2_Callback(hObject, eventdata, handles)
% hObject    handle to attack2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Envelope();

% --- Executes during object creation, after setting all properties.
function attack2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to attack2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function decay2_Callback(hObject, eventdata, handles)
% hObject    handle to decay2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Envelope();


% --- Executes during object creation, after setting all properties.
function decay2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to decay2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sustain2_Callback(hObject, eventdata, handles)
% hObject    handle to sustain2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Envelope();


% --- Executes during object creation, after setting all properties.
function sustain2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sustain2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function release2_Callback(hObject, eventdata, handles)
% hObject    handle to release2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Envelope();


% --- Executes during object creation, after setting all properties.
function release2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to release2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slope_attack1_Callback(hObject, eventdata, handles)
% hObject    handle to slope_attack1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Envelope();

% --- Executes during object creation, after setting all properties.
function slope_attack1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slope_attack1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Decay2_Callback(hObject, eventdata, handles)
% hObject    handle to decay2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Envelope();


% --- Executes during object creation, after setting all properties.
function Decay2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to decay2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slope_attack2_Callback(hObject, eventdata, handles)
% hObject    handle to slope_attack2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Envelope();


% --- Executes during object creation, after setting all properties.
function slope_attack2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slope_attack2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slope_decay2_Callback(hObject, eventdata, handles)
% hObject    handle to slope_decay2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Envelope();


% --- Executes during object creation, after setting all properties.
function slope_decay2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slope_decay2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slope_release2_Callback(hObject, eventdata, handles)
% hObject    handle to slope_release2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Envelope();


% --- Executes during object creation, after setting all properties.
function slope_release2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slope_release2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slope_decay1_Callback(hObject, eventdata, handles)
% hObject    handle to slope_decay1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Envelope();


% --- Executes during object creation, after setting all properties.
function slope_decay1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slope_decay1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slope_release1_Callback(hObject, eventdata, handles)
% hObject    handle to slope_release1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Envelope();

% --- Executes during object creation, after setting all properties.
function slope_release1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slope_release1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.

function slope_attack4_Callback(hObject, eventdata, handles)
% hObject    handle to slope_attack4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Envelope();


% --- Executes during object creation, after setting all properties.
function slope_attack4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slope_attack4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slope_decay4_Callback(hObject, eventdata, handles)
% hObject    handle to slope_decay4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Envelope();


% --- Executes during object creation, after setting all properties.
function slope_decay4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slope_decay4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slope_release4_Callback(hObject, eventdata, handles)
% hObject    handle to slope_release4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Envelope();


% --- Executes during object creation, after setting all properties.
function slope_release4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slope_release4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




function slope_attack3_Callback(hObject, eventdata, handles)
% hObject    handle to slope_attack3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Envelope();


% --- Executes during object creation, after setting all properties.
function slope_attack3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slope_attack3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slope_decay3_Callback(hObject, eventdata, handles)
% hObject    handle to slope_decay3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Envelope();


% --- Executes during object creation, after setting all properties.
function slope_decay3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slope_decay3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slope_release3_Callback(hObject, eventdata, handles)
% hObject    handle to slope_release3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Envelope();

% --- Executes during object creation, after setting all properties.
function slope_release3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slope_release3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on scroll wheel click while the figure is in focus.
function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)
