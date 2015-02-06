function y = grainLn(x,init,L,Lw) 
% extract a long grain 
% x	inputsignal 
% init first sample 
% L	grain length (in samples) 
% Lw percent of L used by the Tukey window for fading in and out
%
%
if init == 0, init = 1;
end
if L > length(x),L = length(x);
end
if init+L+1 > length(x),init = length(x) - L+1;% bullet proof the function.
end
y = x(init:init+L-1);	
% extract segment 
%
%
%
%
%
%
w = tukeywin(L,Lw);
y = y.*w;
end