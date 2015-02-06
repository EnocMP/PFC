clear all;
len = 10000;
line = 0:1/len:1;

seg=len/4;

line1=line(1:seg);
line2=line(seg+1:seg*2)-0.15;
line3=line(2*seg+1:seg*3)+0.1;
line4=line(3*seg+1:seg*4)-0.1;
lineSemi=[line1 line2 line3 line4];

r1=line1+0.73;
r2=line1+0.4;
r3=line1+0;
r4=line1+0.6;

lineR=[r1 r2 r3 r4];

line=line(1:len);
figure('Color',[1 1 1]);

subplot(3,1,1);
%scatter(line, line,'marker', '.');% 'LineWidth', 1);%,'marker', 'none');
h=scatter(line,line,'marker', '.', 'LineWidth', 0.01);
 title('linear', 'FontSize',13);
hChildren = get(h, 'Children');
set(hChildren, 'Markersize', 1)
subplot(3,1,2);
h=scatter(line, lineSemi,'marker', '.');% 'LineWidth', 1);%,'marker', 'none');
 title('Semi-random', 'FontSize',13);
hChildren = get(h, 'Children');
set(hChildren, 'Markersize', 1)
subplot(3,1,3);
h=scatter(line, lineR,'marker', '.');% 'LineWidth', 1);%,'marker', 'none');
title('Random', 'FontSize',13);

hChildren = get(h, 'Children');
set(hChildren, 'Markersize', 1)

% 
% 
% axis([0 length(linearGrain) 0 1.1]);
% 
% subplot(2, 2, 3); plot(squareGrain);
% title('Exponential', 'FontSize', titleSize)
% xlabel('Samples') % x-axis label
% ylabel('Amplitude') % y-axis label
% 
% axis([0 length(linearGrain) 0 1.1]);
% subplot (2,2,4); plot(gaussGrain);
% 
% title('Gaussian', 'FontSize',titleSize);
% xlabel('Samples') % x-axis label
% ylabel('Amplitude') % y-axis label
% axis([0 length(linearGrain) 0 1.1])

% plot(t, seq,'b', t, wave, 'r', t, -seq, 'b');
% legend('Sequencer','Output','Location','EastOutside')
% xlabel('Samples') % x-axis label
% ylabel('Amplitude') % y-axis label