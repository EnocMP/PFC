%% This script gets a mono file and, for a number of user defined segments, proceeds to granulate it. The segments are concatenated and the whole sequence is played. A. D. Hanna 2013

% Frankenstein1.wav was produced with 'L.10' as the input
% The rest was produced using 'dryspeech.wav'




%% 

y = input('Enter name of WAV file. Dont forget the quote marks '); % ask for the name of a mono WAV file and store it in 'y'.

%%[signal,fs] = wavread(y); % store the data in 'signal'and read the sample rate into 'fs'.
[signal,fs] = audioread(y); % store the data in 'signal'and read the sample rate into 'fs'.

[~, channels] = size(signal); % find out how many channels there are in 'signal'. Store the answer in 'channels'. 

if channels == 2; % If 'signal' has 2 channels get rid of one of them.

    choice = input('Looks like this is a stereo file. We only want one channel. 1 or 2?   ');
    
    signal = signal(:,choice); % 'signal' is now a single column array.
end

%% Get input from the user

numseg = input('how many segments?  ');

%% The main loop. For each segment get user input 
for  i = 1:numseg

    str= strcat('Segment',num2str(i));
    disp(str)
    
    NEvents1 = input('The number of events for channel 1 = ');  % ask for the number of events for channel1 and store in 'NEvents1'. 
    NEvents2 = input('The number of events for channel 2 = ');  % ask for the number of events for channel2 and store in 'NEvents2'. 
    
    L = input('The length in seconds = ');  % ask for the length in seconds and store in 'L'. 
    
    %Ambit1 = input('The maximum and minimum duration in samples for channel1. Use [] please ');  % ask for grain lengths for channel1 and store in array 'Ambit1'. 
    Ambit1 = input('The maximum and minimum duration in seconds for channel1. Use [] please ');  % ask for grain lengths for channel1 and store in array 'Ambit1'. 
    Max1 = Ambit1(:,1);
    Min1 = Ambit1(:,2); 
    
    %Ambit2 = input('The maximum and minimum duration in samples for channel2. Use [] please ');  % ask for grain lengths for channel2 and store in array 'Ambit2'.
    Ambit2 = input('The maximum and minimum duration in seconds for channel2. Use [] please ');  % ask for grain lengths for channel2 and store in array 'Ambit2'.
    Max2 = Ambit2(:,1);
    Min2 = Ambit2(:,2); 
    
    Fades = input('The fade in/out time as percentage of grain length = ');  % ask for fade in fade out time and store in 'Fades'. A value of 0.1 is useful.

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

%% play the result
%Frankenstein = Frankenstein./max(abs(Frankenstein));
soundsc(Frankenstein,fs)


%% If you like what you heard then save it as 'Frankenstein(n).wav'


choice = input('You wanna save it? 1 for ''yes'' any other number for ''no''   ');
if choice == 1;
    number = input('Give it a number  ');
    wavwrite(Frankenstein,fs,strcat('Frankenstein',num2str(number),'.wav'));
else
    str = sprintf('Not that great eh?  Ah well... back to the drawing board then.');
    
    disp(str);
end
% 
% 
% 
