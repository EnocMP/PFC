

clear all;
fs=44100;
ending = 800*3.14;

len=1000;

f1=zeros(1,len/2);
f1=f1+200;

f2=201:200/len:400;
f3=f1+200;

f = [f1 f2 f3];

step =100;

t = 1:1/step:length(f)/step;

length(f)
length(t)

wave=zeros(1:length(f);
for i=1:length(f)
   wave(i)=sin(2*pi*200*t);
end


axis([0 length(f) 100 500]);
plot(f);

% wave1 = a1*sin(2*pi*f1*t/fs);
% wave2 = a2*sin(2*pi*f2*t/fs);
% wave3 = a3*sin(2*pi*f3*t/fs);
% wave4 = a4*sin(2*pi*f4*t/fs);
% wave = [wave1 wave2 wave3 wave4];


% plot(wave,'r') % x will be in red
% hold % hold the current plot
% plot(seq,'y') % y will be plotted in yellow
% figure('Color',[1 1 1]);
% 
% plot(t, seq,'b', t, wave, 'r', t, -seq, 'b');
% title('Sine wave modulated by a sequencer')
% legend('Sequencer','Output','Location','EastOutside')
% xlabel('Samples') % x-axis label
% ylabel('Amplitude') % y-axis label