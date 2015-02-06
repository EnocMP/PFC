% A. D. Hanna 2013  This program was inspired by the truly appalling reception I get on my digital TV.



function [outsound grainLength] = granulatormono(insig,fs,numEvents,Lout,maxL,minL,fade) 
%% A granulating function that takes numEvents segments with a maximum length of maxL and a minimum length of minL from an input signal and creates an output signal of Lout seconds. 
numSamplesIN = length(insig);
% the number of samples in the input file 'insig'.



numSamplesOUT = round(Lout*fs);
% 'Lout' is the time in seconds input by the user. Multiply this by the sample rate
% to find the required number of samples. Stick it in 'numSamplesOUT'.



outsound = zeros(1,numSamplesOUT)'; % a column vector of 'numSamples' zeros.
% the matrix for the output file. This is place-holder function.
% a silent pre-universe waiting for a 'big bang':)


 
%%

grainLength = round((maxL-minL)*rand(1,numEvents))+minL;
%grainLength = mod(round((maxL-minL)*rand(1,numEvents)),257)+minL;% produces 'numEvents' grain lengths
% 'numEvents' number of random numbers between 0 and 1 get multiplied
% 'maxL' minus 'minL', the decimal is rounded off and 'minL' is added.

%% multiple choice for how to get the grains from the input file.

%%typeIN = input('random, random but progressing through the input file, or linear? 1 2 or 3    ');
typeIN=1;
if typeIN == 1;
    
 initIN = ceil((numSamplesIN - maxL)*rand(1,numEvents));
% random access
elseif typeIN == 2;
 initIN = sort(ceil((numSamplesIN - maxL)*rand(1,numEvents))); % init grain
% random but progressing through the input file
% create 'numEvents' onset sample points pseudo-random between 1 and ('numSamplesIN' - 'maxL')
% sort them from smallest to largest. The onset sample numbers in the input
% file
else
 
 initIN = ceil(linspace(1,numSamplesIN - maxL,numEvents)); % init grain
% progressing linearly through the file
end

%% multiple choice for where to put the grains in the output file.

%%typeOUT = input('- acceleration, + acceleration, linear, or random out? 1  2  3 or 4  ');
typeOUT =4;

if typeOUT == 1; % - acceleration

initOUTz = floor(logspace(0.1,log10(numSamplesOUT - maxL),numEvents));
% creat a set of non-linear onset times.  10^0.1 = 1.2589,find the value of x for 
%10^x = numSamplesOUT - maxL.  Create numEvents onset times between them.

% find difference-less-than-20 values, kick them into the future
% ---------------------------------------------------------------------------------------%
%                                                                                        %
for i = 2:numEvents;                                                                     % 
if initOUTz(i-1) - initOUTz(i) < 20,initOUTz(i) = initOUTz(i)+randi([10 50]);            %   
end                                                                                      %
end                                                                                      %
%                                                                                        %
% ---------------------------------------------------------------------------------------%

initOUT = initOUTz;

clear initOUTz     % take out the trash

elseif typeOUT ==2 % + acceleration

initOUT = floor(logspace(0.1,log10(numSamplesOUT - maxL),numEvents));
% creat a set of non-linear onset times.  10^0.1 = 1.2589,find the value of x for
%10^x = numSamplesOUT - maxL.  Create numEvents onset times between them.

%% The relatively reverse mapping function.

biggest = max(initOUT); % find the maximum value of initOUT. store it in 'biggest'.

for i = 1:numEvents;

    difference(i) = biggest - initOUT(i); % subtract all the values in 'initOUT' from 'biggest'. store all the differences in 'difference'. 

end

ratio = difference./biggest; % find all the ratios by comparing the differences with 'biggest'


for i = 1:length(initOUT);

    newTime(i) = round(biggest*ratio(i))+1; % map the old values into the new range.

end

% find difference-less-than-20 values, kick them into the past
% ---------------------------------------------------------------------------------------%
%                                                                                        %
for i = 2:length(numEvents);                                                             %
if newTime(i-1) - newTime(i) < 20,newTime(i) = newTime(i)-randi([10 50]);                %   
end                                                                                      %
end                                                                                      %
%                                                                                        %
% ---------------------------------------------------------------------------------------%
%%

initOUT = sort(newTime); % Store 'newTime' in 'initOUT'.

clear newTime  % take out the trash

elseif typeOUT ==3;  % linear distribution
initOUT = ceil(linspace(1,numSamplesOUT - maxL,numEvents));
%Create a vector of 'numEvents' linearly spaced numbers from 1 to ('numSamplesOUT' - 'maxL'):

else  % pseudo random
 initOUT = sort(ceil((numSamplesOUT - maxL)*rand(1,numEvents)));% init out grain
% the onset sample numbers in outsound 
% create 'numEvents' onset sample points pseudo-random between 1 and ('numSamplesOUT' - 'maxL')
% sort them from smallest to largest. The onset sample numbers in the output
% file 'outsound'.
end

%%


amplitudes = rand(1,numEvents);% generate 'numEvents' random amplitudes

%%

endOUT = initOUT+grainLength-1;
% the sample number in the output file at which the grain is terminated
% this being at 'grainLength'-1 number of samples after the onset time
% 'initOUT'.

%% The main loop


for k = 1:numEvents, % the synthesis 'engine'. Call the grainLn function 'numEvents' times. The length of initIN = the length of initOUT.

    

     %% input stage
    
     grain = grainLn(insig,initIN(k),grainLength(k),fade); % create 'numEvents' grains with 'initIN' onset sample points.
     % there are 'numEvents' grain lengths. Pass the value entered by the
     % user to the tukeywin function.
     
     %% output stage
     
     outsound(initOUT(k):endOUT(k)) = outsound(initOUT(k):endOUT(k))+amplitudes(k)*grain;
     % add 'numEvents' amplitudes pseudo-random between 0 and 1 multiplied
     % by each grain to the vector of zeros 'outsound'.. The choice regarding 'initOUT' determines the onset
     % sample points in the output file which is 'outsound' samples long.
     % Each grain is endOUT - initOUT samples long.
    
    
 end

