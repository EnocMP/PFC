%% a direct script for using granulator

warning('off','all');

%% 
y = 'bach-brandenburg-5.wav';
%%y = 'dryspeech.wav';
[signal,fs] = wavread(y); % store the data in 'signal'and read the sample rate into 'fs'.

%[signal,fs] = audioread(y); % store the data in 'signal'and read the sample rate into 'fs'.

[~, channels] = size(signal); % find out how many channels there are in 'signal'. Store the answer in 'channels'. 

if channels == 2; % If 'signal' has 2 channels get rid of one of them.

    choice = 1;
    
    signal = signal(:,choice); % 'signal' is now a single column array.
end

%% Get input from the user

numseg = 1; %% how many segments?


%% The main loop. For each segment get user input 
for  i = 1:numseg

    str= strcat('Segment',num2str(i));
    disp(str)
    

    NEvents1 = 10000;  %% The number of events for channel 1
    NEvents2 = 100000; %% The number of events for channel 2
    
    L = 30; %% The length in seconds
    
    Max1 = 0.01;    %% The maximum duration in seconds for channel1
    Min1 = 0.001;  %% The minimum duration in seconds for channel1
    
    Max2 = 0.1;    %% The maximum duration in seconds for channel2
    Min2 = 0.001; %% The minimum duration in seconds for channel2
    
    Fades = 0.1; %% The fade in/out time as percentage of grain length 
    %% Call the 'granulatormono' function. The function asks for user input for how the input file is accessed and for how the grains in the output file are disposed in time.

    message = 'channel1';
    disp(message)
    channel1  = granulatormono(signal,fs,NEvents1,L,Max1*fs,Min1*fs,Fades); % this function calls 'grainLn'.
    normalise1 = max(abs(channel1));
    channel1 = channel1./(normalise1*2);

%% Call the 'granulatormono' function. The function asks for user input for how the input file is accessed and for how the grains in the output file are disposed in time.

    message = 'channel2';
    disp(message)
    channel2 = granulatormono(signal,fs,NEvents2,L,Max2*fs,Min2*fs,Fades); % this function calls 'grainLn'.
    normalise2 = max(abs(channel2)); 
    channel2 = channel2./(normalise2*2); % later on... normalise * numChannelsOut for multichannel output

%% convert to cell arrays and store in'bothchannels'.

    bothchannels{i} = {channel1,channel2};
    %bothchannels{i} = bothchannels{i}./max(abs(bothchannels{i}));

end % the main loop terminates

%% convert cells back to arrays and then concatenate them. 

Frankenstein = [];
for i = 1:numseg;
    Frankenstein = cat(1,Frankenstein,cell2mat(bothchannels{i}));
end

%% don't play the result
%Frankenstein = Frankenstein./max(abs(Frankenstein));
%soundsc(Frankenstein,fs)


%% If you like what you heard then save it as 'Frankenstein(n).wav'


choice = 1; %% You wanna save it? 1 for ''yes'' any other number for ''no''   
if choice == 1;
    number = input('Give it a number for the saved file ');
    wavwrite(Frankenstein,fs,strcat('Frankenstein',num2str(number),'.wav'));
else
    str = sprintf('Not that great eh?  Ah well... back to the drawing board then.');
    
    disp(str);
end
% 
% 
% 
