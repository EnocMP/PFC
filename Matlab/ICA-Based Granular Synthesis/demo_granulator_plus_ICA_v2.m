%% DEMO OF GRANULAR SYNTHESIS + ICA 
%
%  The concept:  
%   Events, i.e. sequences of audio generated from taking a no. of grains, 
%   are lated mixed into a single signal with the help of Independent
%   Component Analysis (ICA). The output audio file contained a series of 
%   SCREENS, i.e. a series of gradual transformations of the original events
%   mixed using progressive runs of ICA algorithms. If the final part of 
%   this file is compared with a random mix (the counterpart file ended wih
%   'r'), it can be noted that the sound in the ICA mix has a clearer 
%   quality since ICA tends to project for obtaining a random var as far as
%   possible from a normal distribution.

% Dependencies:   
%   FastICA and RobustICA packages  
%   Unzip the file ICA-soft.zip avalaible in this folder and install
%   in two separate directories. Finally, include their path in Matlab
%   using the 'Set Path' option 
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
%filename='dryspeech.wav'; 
filename='bach-brandenburg-5.wav';
channel_choice=1;
number = 101;

% For each SCREEN, the granular synthesis params...
    turbo = 1;

    % Events = sequences of audio generated from taking a no. of grains 
    % [These events will be later mixed into a single signal using the mixed 
    % coefficients obtained with Independent Component Analysis (ICA)]
    NEvents1 = 5;  %% The number of events for channel 1  
    NEvents2 = 5; %% The number of events for channel 2
    L = 1; %% The length of each event in seconds
    
    % Micro-events= grains taken for each event 
    micro_events1=3000/turbo;  %% The number of grains taken for each event in channel 1
    micro_events2=3000/turbo;  %% The number of grains taken for each event in channel 2
    %micro_events1=ceil(NEvents1/100);
    %micro_events2=ceil(NEvents2/100);
    
    % Grains
    
    
    Max1 = turbo*0.01;  %% The maximum duration in seconds of grains for channel1
    Min1 = turbo*0.001; %% The minimum duration in seconds of grains for channel1
    Max2 = turbo*100*0.01;  %% The maximum duration in seconds of grains for channel2
    Min2 = turbo*0.001; %% The minimum duration in seconds of grains for channel2
    Fades = 0.1;  %% Fading percentatge in each grain


% For each SCREEN, the ICA params...

% BASIC PARAM: no_of_it= no. of SCREENS to be concatenated

    %ICA_algorithm='FAST_ICA  ';    % the ICA algorithm to be used 
    ICA_algorithm='ROBUST_ICA';

    if ICA_algorithm=='FAST_ICA  ',
        %For FAST_ICA
        epsilon= [1.0 0.5 0.1 0.09 0.08 0.05 0.03 0.01 0.001 0.0001];
        maxNuMIt=1000;
        no_of_it=length(epsilon);   
    else ICA_algorithm=='ROBUST_ICA',
        % For RobustICA
        maxNumIt= [1 2 3 4 5 6 10];
        no_of_it=length(maxNumIt);
    end


%% READING THE INPUT AUDIO FILE
%
[signal,fs] = audioread(filename); % store the data in 'signal'and read the sample rate into 'fs'.

[~, channels] = size(signal); % find out how many channels there are in 'signal'. Store the answer in 'channels'. 
if channels == 2; % If 'signal' has 2 channels get rid of one of them.
    signal = signal(:,channel_choice); % 'signal' is now a single column array.
end

%% OBTAINING THE EVENTS (=SEQUENCE OF GRAINS) FROM THE 2-CHANNEL INPUT AUDIO FILE

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

    
%% GENERATING A SINGLE SCREEN BASED ON RANDOM MIXING 

W1r= normrnd(0,1,1,NEvents1);
W2r= normrnd(0,1,1,NEvents2);

channel1_=W1r*channel1;
channel2_=W2r*channel2;

normalise1 = max(abs(channel1_'));
channel1_= channel1_/(normalise1*2);
normalise2 = max(abs(channel2_'));
channel2_= channel2_/(normalise2*2);

Frankensteinr=[];
Frankensteinr = cat(1,Frankensteinr,cell2mat({channel1_',channel2_'}));
audiowrite(strcat('Frankensteinr',num2str(number),'.wav'), Frankensteinr,fs);

%% GENERATING A SERIES OF SCREENS WITH A "GRADUAL" TRANSITION FROM A MIXING OF EVENTS BASED ON ICA

Frankenstein=[];
W1_=[];
W2_=[];

for i=1:no_of_it,
    
    % For channel no.1...
    channel1_=[];
    if ICA_algorithm=='FAST_ICA  ',
        [channel1_,A1, W1] = fastica (channel1, 'numOfIC', 1,  'maxNumIterations', maxNuMIt, 'epsilon', epsilon(i));
        
        %channel1_=[];
        %channel1_=W1*channel1;
        %channel1_=abs(W1)*channel1;
    else ICA_algorithm=='ROBUST_ICA',
        arguments = {'tol', -1, 'maxiter', maxNumIt(i)};
        [channel1__, A1, iter1, WW1] = robustica(channel1, arguments);
        W1=WW1(1,:);
        %W1=WW1(:,1)';
        %channel1_=W1*channel1;
        channel1_=channel1__(1,:);
    end
    %store mixing coefficients dynamics
    W1_= [W1_; W1];
    %normalization
    normalise1 = max(abs(channel1_'));
    channel1_= channel1_/(normalise1*2);
  
    % For channel no.2...
    channel2_=[];
    if ICA_algorithm=='FAST_ICA  ',
    %For FAST_ICA
        [channel2_,A2, W2] = fastica (channel2, 'numOfIC', 1,  'maxNumIterations', maxNuMIt, 'epsilon', epsilon(i));
    else ICA_algorithm=='ROBUST_ICA',
        [channel2__, A2, iter2, WW2] = robustica(channel2, arguments);
        W2=WW2(1,:);
        channel2_=channel2__(1,:);
    end
    %store mixing coefficients dynamics
    W2_= [W2_; W2];
    %normalization
    normalise2 = max(abs(channel2_'));
    channel2_= channel2_/(normalise2*2);
   
    % Concat SCREENS...
    Frankenstein = cat(1,Frankenstein,cell2mat({channel1_',channel2_'}));

end

%% WRITE THE RESULTS
audiowrite(strcat('Frankenstein',num2str(number),'.wav'), Frankenstein,fs);