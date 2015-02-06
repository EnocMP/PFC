

fs=44100;
t = 1:0.01:2000;
f1 =100;
f2 = 2*f1;
f3 = f1/2;
f4=1.5*f1;

a1=1;
a2=0.4;
a3=0.8;
a4=0.3;

t1=1:1000;


wave1 = a1*sin(2*pi*f1*t/fs);
wave2 = a2*sin(2*pi*f2*t/fs);
wave3 = a3*sin(2*pi*f3*t/fs);
wave4 = a4*sin(2*pi*f4*t/fs);
wave = [wave1 wave2 wave3 wave4];
plot(wave);