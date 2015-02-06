%clc
W1r= normrnd(0,1,1,NEvents1);
W2r= normrnd(0,1,1,NEvents2);

ce=cos(-pi/3.2);
se=sin(-pi/3.2);
    
Rx=[ 1 0 0; 0 ce -se; 0 se ce];
Ry=[ ce 0 se; 0 1 0; -se 0 ce];
Rz=[ ce -se 0; se ce 0; 0 0 1];

Rx*Ry*Rz