

clear all;
fs=44100;
ending = 800*3.14;

len=1000;
pre=1000;
r=2000;
post=1000;
total=pre+r+post;

fin=zeros(1, total);
fin(1:pre)=200;
fin(pre+1:total)=400;

inc=200/r;

ramp=200:inc:400-inc;
f1=zeros(1, pre) +200;
f2=zeros(1,post) +400;
fglide=[f1 ramp f2];

t=1:length(fglide);

x=1:length(fglide);
x=t/3;

for i=1:length(fin)
    wave(i) = sin(2/44100*pi*x(i)*fglide(i));
end

 subplot(2,1,1);
plot(t, fin,'b',t, fglide, 'r')
 % titleSize=14;
% % subplot(2,1,1);
% plot(fin);
 axis([0 total 150 450]);
 
  subplot(2,1,2);
plot(wave);
% titleSize=14;
% subplot(2,1,1);
% plot(fin);
 %axis([0 total 150 450]);
% title('Frequency response without glide', 'FontSize', titleSize)
% xlabel('Time') % x-axis label
% ylabel('Frequency') % y-axis label
% 
% 
% 
% plot(fglide);
% axis([0 total 150 450]);
% title('Frequency response without glide', 'FontSize', titleSize)
% xlabel('Time') % x-axis label
% ylabel('Frequency') % y-axis label
% % subplot(3,1,1);
% % plot(wave1);




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