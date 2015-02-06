
%http://www.mathworks.es/es/help/dsp/ug/define-basic-system-objects-1.html
%http://www.mathworks.es/es/help/dsp/ref/dsp.audioplayer-class.html#bsfxujo-2_2

%Global variables
samples = str2double(get(handles.samples_in,'String')); 
fs = 44100;

%audio player object declaration
hap = dsp.AudioPlayer('SampleRate',fs);
hap.QueueDuration = 0.1;
% hap.BufferSizeSource = 'Property';
% hap.BufferSize = 8192;


i=0;
play = get(handles.Play,'Value'); %get the frequency

while  play > 0
    play = get(handles.Play,'Value'); %get the value of the push button

    freq_in = 440 * get(handles.slider1,'Value')+220; %get the frequency
    set(handles.text_freq,'String', num2str(freq_in)); %set frequency text box

    Mod = 1 * get(handles.slider2,'Value'); %get the Modulation coefficient
    set(handles.text_mod,'String', num2str(Mod)); %set Modulation coefficient text box

    i=i+1;
    phase_offset= i*samples/fs;  %calculation of the phase increment
    
    audio=step(SineModObject,freq_in, phase_offset, samples, Mod); %sine object returns 1024 values of the sine    
    audio=audio.'; 
    step(hap,audio); %play 'sample' values of the signal
    if (i>10)
       pause(0.7*samples/fs);       % Waits 70% of sample playing time (we assume that de computation time is about the other 30%)
    end
end 

pause(hap.QueueDuration);       % Wait until audio plays to the end
release(hap);                   % close audio output device, release resources
clear all;