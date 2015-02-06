Modulation_gain = 5;


t=0:0.01:18.86;
play=1;


%%%%%%%%%%%%%%%%OSCILLATOR 1%%%%%%%%%%%%%%%%%%%%
phase1= 2*pi*get(handles.phase1,'Value');
oct1 = str2double(get(handles.oct_sel1,'String'));
axes(handles.axes1);
wave_select1= (get(handles.wave_sel_osc1,'Value'));
Volume1= (get(handles.vol1,'Value'));


switch wave_select1
    
    case 1
        plot (sin(t));
    case 2       
        plot (sawtooth(t, 0.5));
    case 3
        plot (sawtooth(t));

    otherwise
        plot (square(t));
end;
axis off;
%%%%%%%%%%%%%%%%%%OSCILLATOR 2%%%%%%%%%%%%%%%%

phase2= 2*pi*get(handles.phase2,'Value');
oct2= str2double(get(handles.oct_sel2,'String'));
B2= Modulation_gain*(get(handles.vol2,'Value'));
axes(handles.axes2);

wave_select2= (get(handles.wave_sel_osc2,'Value'));
switch wave_select2
    
    case 1
        plot (sin(t));
    case 2       
        plot (sawtooth(t, 0.5));
    case 3
        plot (sawtooth(t));

    otherwise
        plot (square(t));
end;
axis off;

%%%%%%%%%%%%%%%%%%OSCILLATOR 3%%%%%%%%%%%%%%%%%%%%%%%

phase3= 2*pi*get(handles.phase3,'Value');
oct3= str2double(get(handles.oct_sel3,'String'));
B3= Modulation_gain*(get(handles.vol3,'Value'));
axes(handles.axes3);

wave_select3= (get(handles.wave_sel_osc3,'Value'));
switch wave_select3
    
    case 1
        plot (sin(t));
    case 2       
        plot (sawtooth(t, 0.5));
    case 3
        plot (sawtooth(t));

    otherwise
        plot (square(t));
end;
axis off;

%%%%%%%%%%%%%%%%%%OSCILLATOR 4%%%%%%%%%%%%%%%%%%%%%%%

phase4= 2*pi*get(handles.phase4,'Value');
oct4= str2double(get(handles.oct_sel4,'String'));
B4= Modulation_gain*(get(handles.vol4,'Value'));
axes(handles.axes4);
wave_select4= (get(handles.wave_sel_osc4,'Value'));
switch wave_select4
    
    case 1
        plot (sin(t));
    case 2       
        plot (sawtooth(t, 0.5));
    case 3
        plot (sawtooth(t));

    otherwise
        plot (square(t));
end;
axis off;




%%%%%%%%%%%%%%%CALCULATE WAVEFORM%%%%%%%%%%%%%%%%%
L=0:0.01:1000;

 switch wave_select4    
    case 1
       wave4 = sin(oct4*2.*pi.*L + phase4);
    case 2       
       wave4 = sawtooth(oct4*2.*pi.*L + phase4, 0.5 );
    case 3
       wave4 = sawtooth(oct4*2.*pi.*L + phase4);

    otherwise
       wave4 = square(oct4*2*pi.*L  +  phase4);
end;

 switch wave_select2    
    case 1
       wave3 = sin(oct3*2.*pi.*L + B4*wave4 + phase3);
    case 2       
       wave3 = sawtooth(oct3*2.*pi.*L + B4*wave4+ phase2, 0.5 );
    case 3
       wave3 = sawtooth(oct3*2.*pi.*L +B4*wave4 + phase3);

    otherwise
       wave3 = square(oct3*2.*pi.*L + B4*wave4+  phase3);
end;

 switch wave_select2    
    case 1
       wave2 = sin(oct2*2.*pi.*L + B3*wave3 + phase2);
    case 2       
       wave2 = sawtooth(oct2*2.*pi.*L + B3*wave3+ phase2, 0.5 );
    case 3
       wave2 = sawtooth(oct2*2.*pi.*L + B3*wave3 + phase2);

    otherwise
       wave2 = square(oct2*2.*pi.*L + B3*wave3 +  phase2);
end;

switch wave_select1

    case 1
       wave1 = sin(oct1*2*pi.*L + B2*wave2 +  phase1);
    case 2       
       wave1 = sawtooth(oct1*2*pi.*L + B2*wave2+  phase1, 0.5);
    case 3
       wave1 = sawtooth(oct1*2*pi.*L + B2*wave2+  phase1);

    otherwise
       wave1 = square(oct1*2*pi.*L + B2*wave2+  phase1);
end;

%PRINT SIGNAL
    axes(handles.chart);
    plot(wave1(1:314));
%PRINT SPECTRUM
     
axes(handles.spectrum_axes);
Spectrum = abs(fft (wave1));
semilogx(Spectrum(1:round(length(Spectrum)/2)));
m=max(Spectrum(1:round(length(Spectrum)/2)));
axis([900 100000 0 m]);




