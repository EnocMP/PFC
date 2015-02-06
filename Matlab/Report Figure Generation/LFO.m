

fs=44100;
t = 1:0.01:2000;
f1 =400;
f2 = 0.1*f1;





wave1 = sin(2*pi*f1*t/fs);
wave2 = 0.5+0.3*(sin(2*pi*f2*t/fs));

for i=1:length(wave1)
    wave(i)=wave1(i)*wave2(i);
end


% plot(wave,'r') % x will be in red
% hold % hold the current plot
% plot(seq,'y') % y will be plotted in yellow
figure('Color',[1 1 1]);


plot(t, wave2,'b', t, wave, 'r', t, -wave2, 'b');

legend('LFO','output','Location','EastOutside')
title('AM modulation using a LFO')
xlabel('Samples') % x-axis label
ylabel('Amplitude') % y-axis label