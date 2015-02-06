time    =str2double(get(handles.Time_in,'String'));
fs=44100;
t=0:1/fs:time;
fs=44100;
Exp=4;
Tmax=5; % max time for attack, decay and release

%%max attack time 5s
%%max decay time 5s
%%max release time 5s


%%%%%%%%%%%%%%%%%Enveloe 1%%%%%%%%%%%%%%%%
%get values
attack1= (get(handles.attack1,'Value'))^2;
decay1 = (get(handles.decay1,'Value'))^2;
sustain1 = (get(handles.sustain1,'Value'))^2;
release1 = (get(handles.release1,'Value'))^2;
slope_attack1 = get(handles.slope_attack1,'Value');
slope_decay1 = get(handles.slope_decay1,'Value');
slope_release1 = get(handles.slope_release1,'Value');

if attack1 < 1    
    string = strcat(num2str(attack1*Tmax*1000), 'ms');
    set(handles.attack1_text, 'String', string);
else
     string = strcat(num2str(attack1*Tmax), 's');
     set(handles.attack1_text, 'String', string);
end

if attack1 < 1    
    string = strcat(num2str(attack1*Tmax*1000), 'ms');
    set(handles.attack1_text, 'String', string);
else
     string = strcat(num2str(attack1*Tmax), 's');
     set(handles.attack1_text, 'String', string);
end

if decay1 < 1    
    string = strcat(num2str(decay1*Tmax*1000), 'ms');
    set(handles.decay1_text, 'String', string);
else
     string = strcat(num2str(decay1*Tmax), 's');
     set(handles.decay1_text, 'String', string);
end

string = strcat(num2str(20*log(sustain1), 3), 'dB');
set(handles.sustain1_text, 'String', string);


if release1 < 1    
    string = strcat(num2str(release1*Tmax*1000), 'ms');
    set(handles.release1_text, 'String', string);
else
     string = strcat(num2str(release1*Tmax), 's');
     set(handles.release1_text, 'String', string);
end

%attack calculation
m = 1 / (fs*attack1*Tmax);
vector = 0:m:1;
k=Exp^(2*slope_attack1-1);
envelope1_attack=vector.^k;

%decay calculation
m = 1 / (fs*decay1*Tmax);
k=Exp^(2*slope_decay1-1);
vector = (0:m:1).^(1/k);
envelope1_decay= 1 - (1-sustain1)*vector;

%Sustain
envelope1_sustain = zeros(1,time*fs) + sustain1;

%Release calculation
m = 1 / (fs*release1*Tmax);
k=Exp^(2*slope_release1-1);
vector = (0:m:1).^(1/k);
envelope1_release=  sustain1*(1-vector);



envelope1=[envelope1_attack, envelope1_decay, envelope1_sustain, envelope1_release];
%plot
axes(handles.axes_env1);
plot(envelope1);
axis off;


%%%%%%%%%%%%%%%%%Envelope 2%%%%%%%%%%%%%%%%

attack2= (get(handles.attack2,'Value'))^2;
decay2 = (get(handles.decay2,'Value'))^2;
sustain2 = (get(handles.sustain2,'Value'))^2;
release2 = (get(handles.release2,'Value'))^2;
slope_attack2 = (get(handles.slope_attack2,'Value'));
slope_decay2 = (get(handles.slope_decay2,'Value'));
slope_release2 = (get(handles.slope_release2,'Value'));
%print values in text boxes

if attack2 < 1    
    string = strcat(num2str(attack2*Tmax*1000), 'ms');
    set(handles.attack2_text, 'String', string);
else
     string = strcat(num2str(attack2*Tmax), 's');
     set(handles.attack2_text, 'String', string);
end

if attack2 < 1    
    string = strcat(num2str(attack2*Tmax*1000), 'ms');
    set(handles.attack2_text, 'String', string);
else
     string = strcat(num2str(attack2*Tmax), 's');
     set(handles.attack2_text, 'String', string);
end

if decay2 < 1    
    string = strcat(num2str(decay2*Tmax*1000), 'ms');
    set(handles.decay2_text, 'String', string);
else
     string = strcat(num2str(decay2*Tmax), 's');
     set(handles.decay2_text, 'String', string);
end

string = strcat(num2str(20*log(sustain2), 2), 'dB');
set(handles.sustain2_text, 'String', string);


if release2 < 1    
    string = strcat(num2str(release2*Tmax*1000), 'ms');
    set(handles.release2_text, 'String', string);
else
     string = strcat(num2str(release2*Tmax), 's');
     set(handles.release2_text, 'String', string);
end


%attack calculation
m = 1/ (fs*attack2*Tmax);
vector = 0:m:1;
k=Exp^(2*slope_attack2-1);
envelope2_attack=vector.^k;

%decay calculation
m = 1 / (fs*decay2*Tmax);
k=Exp^(2*slope_decay2-1);
vector = (0:m:1).^(1/k);
envelope2_decay= 1 - (1-sustain2)*vector;



%Release calculation
m = 1 / (fs*release2*Tmax);
k=Exp^(2*slope_release2-1);
vector = (0:m:1).^(1/k);
envelope2_release=  sustain2*(1-vector);

%Sustain
len = length(envelope1) - (length(envelope2_attack) + length(envelope2_decay) + length(envelope2_release));

envelope2_sustain = zeros(1,len) + sustain2;
envelope2=[envelope2_attack, envelope2_decay, envelope2_sustain, envelope2_release];

length(envelope2)

%plot
axes(handles.axes_env2);
plot(envelope2);
axis off;

%%%%%%%%%%%%%%%%%Envelope 3%%%%%%%%%%%%%%%%

attack3= (get(handles.attack3,'Value'))^2;
decay3 = (get(handles.decay3,'Value'))^2;
sustain3 = (get(handles.sustain3,'Value'))^2;
release3 = (get(handles.release3,'Value'))^2;
slope_attack3 = (get(handles.slope_attack3,'Value'));
slope_decay3 = (get(handles.slope_decay3,'Value'));
slope_release3 = (get(handles.slope_release3,'Value'));

%attack calculation
m = 1/ (fs*attack3*Tmax);
vector = 0:m:1;
k=Exp^(2*slope_attack3-1);
envelope3_attack=vector.^k;

%decay calculation
m = 1 / (fs*decay3*Tmax);
k=Exp^(2*slope_decay3-1);
vector = (0:m:1).^(1/k);
envelope3_decay= 1 - (1-sustain3)*vector;



%Release calculation
m = 1 / (fs*release3*Tmax);
k=Exp^(2*slope_release3-1);
vector = (0:m:1).^(1/k);
envelope3_release=  sustain3*(1-vector);

%Sustain
len = length(envelope1) - (length(envelope3_attack) + length(envelope3_decay) + length(envelope3_release));


envelope3_sustain = zeros(1,len) + sustain3;
envelope3=[envelope3_attack, envelope3_decay, envelope3_sustain, envelope3_release];

%plot
axes(handles.axes_env3);
plot(envelope3);
axis off;
%%%%%%%%%%%%%%%%%Envelope 3%%%%%%%%%%%%%%%%

attack3= (get(handles.attack3,'Value'))^2;
decay3 = (get(handles.decay3,'Value'))^2;
sustain3 = (get(handles.sustain3,'Value'))^2;
release3 = (get(handles.release3,'Value'))^2;
slope_attack3 = (get(handles.slope_attack3,'Value'));
slope_decay3 = (get(handles.slope_decay3,'Value'));
slope_release3 = (get(handles.slope_release3,'Value'));
%print values in text boxes

if attack3 < 1    
    string = strcat(num2str(attack3*Tmax*1000), 'ms');
    set(handles.attack3_text, 'String', string);
else
     string = strcat(num2str(attack3*Tmax), 's');
     set(handles.attack3_text, 'String', string);
end

if attack3 < 1    
    string = strcat(num2str(attack3*Tmax*1000), 'ms');
    set(handles.attack3_text, 'String', string);
else
     string = strcat(num2str(attack3*Tmax), 's');
     set(handles.attack3_text, 'String', string);
end

if decay3 < 1    
    string = strcat(num2str(decay3*Tmax*1000), 'ms');
    set(handles.decay3_text, 'String', string);
else
     string = strcat(num2str(decay3*Tmax), 's');
     set(handles.decay3_text, 'String', string);
end

string = strcat(num2str(20*log(sustain3), 3), 'dB');
set(handles.sustain3_text, 'String', string);


if release3 < 1    
    string = strcat(num2str(release3*Tmax*1000), 'ms');
    set(handles.release3_text, 'String', string);
else
     string = strcat(num2str(release3*Tmax), 's');
     set(handles.release3_text, 'String', string);
end

%attack calculation
m = 1/ (fs*attack3*Tmax);
vector = 0:m:1;
k=Exp^(2*slope_attack3-1);
envelope3_attack=vector.^k;

%decay calculation
m = 1 / (fs*decay3*Tmax);
k=Exp^(2*slope_decay3-1);
vector = (0:m:1).^(1/k);
envelope3_decay= 1 - (1-sustain3)*vector;



%Release calculation
m = 1 / (fs*release3*Tmax);
k=Exp^(2*slope_release3-1);
vector = (0:m:1).^(1/k);
envelope3_release=  sustain3*(1-vector);

%Sustain
len = length(envelope1) - (length(envelope3_attack) + length(envelope3_decay) + length(envelope3_release));

envelope3_sustain = zeros(1,len) + sustain3;
envelope3=[envelope3_attack, envelope3_decay, envelope3_sustain, envelope3_release];

%plot
axes(handles.axes_env3);
plot(envelope3);
axis off;


%%%%%%%%%%%%%%%%%Envelope 4%%%%%%%%%%%%%%%%

attack4= (get(handles.attack4,'Value'))^2;
decay4 = (get(handles.decay4,'Value'))^2;
sustain4 = (get(handles.sustain4,'Value'))^2;
release4 = (get(handles.release4,'Value'))^2;
slope_attack4 = (get(handles.slope_attack4,'Value'));
slope_decay4 = (get(handles.slope_decay4,'Value'));
slope_release4 = (get(handles.slope_release4,'Value'));

%print values in text boxes
if attack4 < 1    
    string = strcat(num2str(attack4*Tmax*1000), 'ms');
    set(handles.attack4_text, 'String', string);
else
     string = strcat(num2str(attack4*Tmax), 's');
     set(handles.attack4_text, 'String', string);
end

if attack4 < 1    
    string = strcat(num2str(attack4*Tmax*1000), 'ms');
    set(handles.attack4_text, 'String', string);
else
     string = strcat(num2str(attack4*Tmax), 's');
     set(handles.attack4_text, 'String', string);
end

if decay4 < 1    
    string = strcat(num2str(decay4*Tmax*1000), 'ms');
    set(handles.decay4_text, 'String', string);
else
     string = strcat(num2str(decay4*Tmax), 's');
     set(handles.decay4_text, 'String', string);
end

string = strcat(num2str(20*log(sustain4), 3), 'dB');
set(handles.sustain4_text, 'String', string);


if release4 < 1    
    string = strcat(num2str(release4*Tmax*1000), 'ms');
    set(handles.release4_text, 'String', string);
else
     string = strcat(num2str(release4*Tmax), 's');
     set(handles.release4_text, 'String', string);
end



%attack calculation
m = 1/ (fs*attack4*Tmax);
vector = 0:m:1;
k=Exp^(2*slope_attack4-1);
envelope4_attack=vector.^k;

%decay calculation
m = 1 / (fs*decay4*Tmax);
k=Exp^(2*slope_decay4-1);
vector = (0:m:1).^(1/k);
envelope4_decay= 1 - (1-sustain4)*vector;



%Release calculation
m = 1 / (fs*release4*Tmax);
k=Exp^(2*slope_release4-1);
vector = (0:m:1).^(1/k);
envelope4_release=  sustain4*(1-vector);

%Sustain
len = length(envelope1) - (length(envelope4_attack) + length(envelope4_decay) + length(envelope4_release));

envelope4_sustain = zeros(1,len) + sustain4;
envelope4=[envelope4_attack, envelope4_decay, envelope4_sustain, envelope4_release];

%plot
axes(handles.axes_env4);
plot(envelope4);
axis off;


%%%%Global envelope length
% 
% envelope1=[envelope1_attack, envelope1_decay];
% envelope2=[envelope2_attack, envelope2_decay];
% envelope3=[envelope3_attack, envelope3_decay];
% envelope4=[envelope4_attack, envelope4_decay];
% 
% len1 = length(envelope1);
% len2 = length(envelope2);
% len3 = length(envelope3);
% len4 = length(envelope4);
% vector_len = [len1 len2 len3 len4]
% 
% [len_max, pos] = max(vector_len)
% 
% 
% if pos == 1
% envelope1 = [envelope1_attack, envelope1_decay, envelope1_sustain, envelope1_release];
% envelope2_sustain = zeros (1, len1
% elseif pos==2
%     
% elseif pos==3
%     
% elseif pos == 4
% 
% end

