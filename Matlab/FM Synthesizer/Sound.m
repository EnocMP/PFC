t=0:0.01:18.86;
play=1;
Envelope();

%OSCILLATOR 1
phase1= 2*pi*get(handles.phase1,'Value');
oct1 = str2double(get(handles.oct_sel1,'String'));
wave_select1= (get(handles.wave_sel_osc1,'Value'));


%OSCILLATOR 2
phase2= 2*pi*get(handles.phase2,'Value');
oct2= str2double(get(handles.oct_sel2,'String'));
B2= Modulation_gain*(get(handles.vol2,'Value'));
wave_select2= (get(handles.wave_sel_osc2,'Value'));

%OSCILLATOR 3
phase3= 2*pi*get(handles.phase3,'Value');
oct3= str2double(get(handles.oct_sel3,'String'));
B3= Modulation_gain*(get(handles.vol3,'Value'));
wave_select3= (get(handles.wave_sel_osc3,'Value'));

%OSCILLATOR 4
phase4= 2*pi*get(handles.phase4,'Value');
oct4= str2double(get(handles.oct_sel4,'String'));
B4= Modulation_gain*(get(handles.vol4,'Value'));
wave_select4= (get(handles.wave_sel_osc4,'Value'));

%Frequency
freq_in =str2double(get(handles.freq_in,'String'));
time    =str2double(get(handles.Time_in,'String'));
fs=44100;
%t=0:1/fs:time;
Envelope();

t= 1:length(envelope1);
t = t/fs;


switch wave_select4    
    case 1
       wave4 = sin(freq_in*oct4*2.*pi.*t + phase4);
    case 2       
       wave4 = sawtooth(freq_in*oct4*2.*pi.*t + phase4, 0.5 );
    case 3
       wave4 = sawtooth(freq_in*oct4*2.*pi.*t + phase4);

    otherwise
       wave4 = square(freq_in*oct4*2*pi.*t  +  phase4);
end;

 switch wave_select2    
    case 1
       wave3 = sin(freq_in*oct3*2.*pi.*t + B4*wave4 + phase3);
    case 2       
       wave3 = sawtooth(freq_in*oct3*2.*pi.*t + B4*wave4+ phase2, 0.5 );
    case 3
       wave3 = sawtooth(freq_in*oct3*2.*pi.*t +B4*wave4 + phase3);

    otherwise
       wave3 = square(freq_in*oct3*2.*pi.*t + B4*wave4+  phase3);
end;


 switch wave_select2    
    case 1
       wave2 = sin(freq_in*oct2*2.*pi.*t + B3*wave3 + phase2);
    case 2       
       wave2 = sawtooth(freq_in*oct2*2.*pi.*t + B3*wave3+ phase2, 0.5 );
    case 3
       wave2 = sawtooth(freq_in*oct2*2.*pi.*t + B3*wave3 + phase2);

    otherwise
       wave2 = square(freq_in*oct2*2.*pi.*t + B3*wave3 +  phase2);
end;
wave2=wave2.*envelope2;
switch wave_select1

    case 1
       wave1 = sin(freq_in*oct1*2*pi.*t + B2*wave2 +  phase1);
    case 2       
       wave1 = sawtooth(freq_in*oct1*2*pi.*t + B2*wave2+  phase1, 0.5);
    case 3
       wave1 = sawtooth(freq_in*oct1*2*pi.*t + B2*wave2+  phase1);

    otherwise
       wave1 = square(freq_in*oct1*2*pi.*t + B2*wave2+  phase1);
end;


fs = 44100; % Hz
f = 440; % Hz
%t=0:1/fs:time;
%wave1 = square(freq_in*oct1*2*pi*t );%+ B*wave2+  phase1);

final_wave = wave1.*envelope1;
sound(final_wave,fs,16);




