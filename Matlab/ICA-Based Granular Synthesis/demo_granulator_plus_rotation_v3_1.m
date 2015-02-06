%% DEMO OF GRANULAR SYNTHESIS + Rotation 
%
% Comments:
%
% Sequences of grains (i.e. audio generated from sampling an input audio
% file) are mixed using a vector multiplied by a 3-D rotation matrix. In 
% this way, the output audio file contains a series of gradual 
% transformations of the original events mixed through a sweep of a 
% rotation angle and, accordingly, a repetitive music that gradually 
% evolves is heard. Each different piece is obtained with a different 
% initial condition of the mixing vector and a different sampling of the 
% input audio signal.
%
% Tags: algorithmic composition, aleatory music, granular synthesis  
%
%  Dec 2014- Jan 2015
%

% Start from scratch
clc;
close all;
clear all;
warning off all

%% PARAMETERS
%
%

% Output audio file parameters 

filename='dryspeech.wav'; 
%filename='bach-brandenburg-5.wav';
%filename='ultra.wav'; 
channel_choice=1;
number = 32;

% For each SCREEN, the granular synthesis params...

    % Events = sequences of audio generated from taking a no. of grains 
    % [These events will be later mixed into a single signal using the mixed 
    % coefficients obtained with Independent Component Analysis (ICA)]
    NEvents1 = 3;  %% The number of events for channel 1  
    NEvents2 = 3; %% The number of events for channel 2
    L = 2; %% The length of each event in seconds
    
    % Micro-events= grains taken for each event 
    micro_events1=2;  %% The number of grains taken for each event in channel 1
    micro_events2=10;  %% The number of grains taken for each event in channel 2
    %micro_events1=ceil(NEvents1/100);
    %micro_events2=ceil(NEvents2/100);
    
    % Grains
    Max1 = 0.5; %1.5;  %% The maximum duration in seconds of grains for channel1
    Min1 = 0.1; %1.0; %% The minimum duration in seconds of grains for channel1
    Max2 = 0.5; %1.0;  %% The maximum duration in seconds of grains for channel2
    Min2 = 0.1; %0.5; %% The minimum duration in seconds of grains for channel2
    Fades = 0.1;  %% Fading percentatge in each grain

 
% For each SCREEN, the rotation matrix params...

% BASIC PARAM: no_of_it= no. of SCREENS to be concatenated
    
    resampling_at_restart=1; % new sampled grains when starting ON(=1)/OFF 
    M=5;  %no. of restarts
    N=50; %no. of it
    noR=ceil(N/M); %no. of its for restarting
    
    start_angle=0;
    end_angle=8*pi;  %2*pi
    
    
    etha=start_angle:(end_angle-start_angle)/(N-1):end_angle;
    no_of_it=length(etha)  


%% READING THE INPUT AUDIO FILE
%
[signal,fs] = audioread(filename); % store the data in 'signal'and read the sample rate into 'fs'.

[~, channels] = size(signal); % find out how many channels there are in 'signal'. Store the answer in 'channels'. 
if channels == 2; % If 'signal' has 2 channels get rid of one of them.
    signal = signal(:,channel_choice); % 'signal' is now a single column array.
end
   

%% GENERATING A SERIES OF SCREENS WITH A "GRADUAL" TRANSITION FROM A MIXING OF EVENTS BASED ON ICA

Frankenstein=[];
W1_=[];
W2_=[];

for i=1:no_of_it,
    i
    if mod(i-1,noR)==0,  
        % RE-STARTING
        if (resampling_at_restart==1) | (i==0),
            
         % OBTAINING THE EVENTS (=SEQUENCE OF GRAINS) FROM THE 2-CHANNEL INPUT AUDIO FILE
         channel1=[];
         for j=1:NEvents1,
            channel1(j,:)  = granulatormono(signal,fs,micro_events1,L,Max1*fs,Min1*fs,Fades); % this function calls 'grainLn'.
            %normalise1 = max(abs(channel1(j,:)));
            %channel1(j,:)= channel1(j,:)./(normalise1*2);
         end

         channel2=[];
         for j=1:NEvents2,
            channel2(j,:)  = granulatormono(signal,fs,micro_events2,L,Max2*fs,Min2*fs,Fades); % this function calls 'grainLn'.
            %normalise2 = max(abs(channel2(j,:)));
            %channel2(j,:)= channel2(j,:)./(normalise2*2);
         end
       
         % GENERATING A RANDOM VECTOR
         W1r= normrnd(0,1,1,NEvents1)
         W2r= normrnd(0,1,1,NEvents2);
        end
    end
    ce=cos(etha(i));
    se=sin(etha(i));
    Rx=[ 1 0 0; 0 ce -se; 0 se ce];
    Ry=[ ce 0 se; 0 1 0; -se 0 ce];
    Rz=[ ce -se 0; se ce 0; 0 0 1];
    R=Rx*Ry*Rz;    
    % For channel no.1...

    channel1_=[];
    channel1_=W1r*R*channel1;
    %store mixing coefficients dynamics
    W1_= [W1_; W1r];
    %normalization
    normalise1 = max(abs(channel1_'));
    channel1_= channel1_/(normalise1*2);
    
    % For channel no.2...
    channel2_=[];
    channel2_=W2r*R*channel2;
    %store mixing coefficients dynamics
    W2_= [W2_; W2r];
    %normalization
    normalise2 = max(abs(channel2_'));
    channel2_= channel2_/(normalise2*2);

    
    % Concat SCREENS...
    Frankenstein = cat(1,Frankenstein,cell2mat({channel1_',channel2_'}));

end

%% WRITE THE RESULTS
audiowrite(strcat('Frankenstein_Rotated',num2str(number),'.wav'), Frankenstein,fs);