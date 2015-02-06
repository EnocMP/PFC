clear all;
grainLength=1000;
transient=1;
titleSize=13;
attackLength=grainLength/2*transient;
sustainLength=grainLength*(1-transient);

attack = 0:1/attackLength:1;
for i=1:length(attack)
decay(i)=attack(length(attack)-i+1);
end

% decay = 1 - attack;
sustain=ones(1, sustainLength);
wait = zeros(1, length(attack)/2);

rootGrain = [wait attack.^0.5 sustain decay.^0.5 wait];
squareGrain = [wait attack.^2 sustain decay.^2 wait];
linearGrain = [wait attack sustain decay wait];

% % 1/sqr(s^pi)*e^-x^2/2;
% e=2.71;
%   for (index=0; index<samples; index++) {
%     x=(double)index/samples;
%     num=x-b;
%     num= - pow(num, 2);
%     den = 2*pow(c,2);
%     exponent=num/den;
%     result=a*pow(e, exponent);
%     if(index==0)  offset=result;
%     GaussTable[index]=(result-offset)*(1+offset); //starting at 0 and 
% 		//normalizint to 1
%   }

 b=1;
 c=0.4;
 a=1;
for i=1:length(linearGrain) 
    x=linearGrain(i);
    num=-power(x-b, 2);
    den=2*c^2;
    result=a*exp(num/den);
    if (i==1)
        offset=result;
    end
    gaussGrain(i)=(result-offset)*(1+offset);
end

figure('Color',[1 1 1]);
subplot (2, 2, 1);
plot(linearGrain);
title('Linear Gain', 'FontSize', titleSize);
xlabel('Samples', 'Fontsize', 10) % x-axis label
ylabel('Amplitude','Fontsize', 10) % y-axis label
axis([0 length(linearGrain) 0 1.1])

subplot (2, 2, 2); plot(rootGrain);

title('Square Root', 'FontSize', titleSize)
xlabel('Samples') % x-axis label
ylabel('Amplitude') % y-axis label
axis([0 length(linearGrain) 0 1.1]);

subplot(2, 2, 3); plot(squareGrain);
title('Exponential', 'FontSize', titleSize)
xlabel('Samples') % x-axis label
ylabel('Amplitude') % y-axis label

axis([0 length(linearGrain) 0 1.1]);
subplot (2,2,4); plot(gaussGrain);

title('Gaussian', 'FontSize',titleSize);
xlabel('Samples') % x-axis label
ylabel('Amplitude') % y-axis label
axis([0 length(linearGrain) 0 1.1])

% plot(t, seq,'b', t, wave, 'r', t, -seq, 'b');
% legend('Sequencer','Output','Location','EastOutside')
% xlabel('Samples') % x-axis label
% ylabel('Amplitude') % y-axis label