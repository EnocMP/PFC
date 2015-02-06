clear all;
titleSize=10;
figure('Color',[1 1 1]);

[y1 fs]=wavread('71.wav');


y=y1(1:length(y1), 1);
l1=length(y);
% y=[y y y y y y y y y y];

fmax=fs/2;
fy=abs(fft(y));
fy=fy(1:length(fy)/2);
fy=mag2db(fy);
fx=1:length(fy);
fx=fx*(fmax/length(fy));

 subplot(2,1,1);
 semilogx(fx,fy);
% plot(fx,fy);

xlim([20 fmax]);
ylim([-50 70]);

title('Granular Synthesis Spectrum', 'FontSize', titleSize);
xlabel('Frequency (Hz)', 'Fontsize', 10) % x-axis label
ylabel('Amplitude (dB)','Fontsize', 10) % y-axis label



[y1 fs]=wavread('71ICA.wav');
y=y1(1:length(y1), 1);
l2=length(y);
% y=y(l2/2:l2);

fmax=fs/2;
fy=abs(fft(y));
fy=fy(1:length(fy)/2);
fy=mag2db(fy);
fx=1:length(fy);
fx=fx*(fmax/length(fy));
 subplot(2,1,2);
 semilogx(fx,fy);
% plot(fx,fy);


xlim([20 fmax]);
ylim([-50 70]);

title('ICA-based Granular Synthesis Spectrum', 'FontSize', titleSize);
xlabel('Frequency (Hz)', 'Fontsize', 10) % x-axis label
ylabel('Amplitude (dB)','Fontsize', 10) % y-axis label




y=zeros(l2,1);
% y=awgn(y,1);
% fmax=fs/2;
% fy=abs(fft(y));
% fy=mag2db(fy);
% 
% subplot(3,1,3);
% semilogx(fy);
% xlim([1 fmax]);
% title('white noise spectrum', 'FontSize', titleSize);
% xlabel('Frequency (Hz)', 'Fontsize', 10) % x-axis label
% ylabel('Amplitude (dB)','Fontsize', 10) % y-axis label




% l=round(length(y1)/2);
% % y1=y1(1:l);
% f=1:l;
% f=f*(fmax/l);


% 
% 
% fy=fy(1:l);
% fy=mag2db(fy);
% subplot(2,1,1);
% semilogx(f,fy);
% xlim([1 fmax]);
% %figure('Color',[1 1 1]);
% title('Granulated Signal Sepctrum', 'FontSize', titleSize);
% xlabel('Frequency (Hz)', 'Fontsize', 10) % x-axis label
% ylabel('Amplitude (dB)','Fontsize', 10) % y-axis label
% 
% [y2 fs]=wavread('Frankenstein69ICA.wav');
% 
% L1=length(y2);
% offset=L1/2;
% y2=y2(offset:offset+l);
% 
% fmax=fs/2;
% l=round(length(y2)/2);
% y2=y2(1:l);
% f=1:l;
% f=f*(fmax/l);
% fy=abs(fft(y2));
% fy=mag2db(fy);
% subplot(2,1,2);
% semilogx(f,fy);
% xlim([1 fmax]);
% 
% title('Processed Signal Sepctrum', 'FontSize', titleSize);
% xlabel('Frequency (Hz)', 'Fontsize', 10) % x-axis label
% ylabel('Amplitude (dB)','Fontsize', 10) % y-axis label
% 
% length(y1)
% length(y2)


% fy=abs(fft(y));
% fdb=mag2db(fy);
% freq=0:Fs/length(
% 
% L=length(fdb);
% L2=round(L/2);
% fa=(fdb(1:L2)); % half is essential, rest is aliasing
% fdb=fdb(1:L2);
% length(fdb)
% length(fa)
% subplot(2,1,1);
% semilogx(fdb,fa);
% 
% 

% 
% [y Fs]=wavread('Frankenstein69ICA.wav');
% fmax=Fs/2;
% fy=fft(y);
% y=mag2db(abs(fy));
% 
% L=length(y);
% L2=round(L/2);
% fa=abs(fy(1:L2)); % half is essential, rest is aliasing
% 
% subplot(2,1,2);
% loglog(fq,fa);