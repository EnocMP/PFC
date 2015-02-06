gauss=zeros();
t=1:0.01:1000;
e=1.1;
for i=1:length(ramp)
    gauss(i)=1*power(e,(-(t(i)-1)^2)/(2*3^2));
end
offset=length(gauss);



for i=1:length(ramp)
   wave(i)=gauss(offset+1-i);
end

for i=1:length(ramp)
   wave(offset+i)=gauss(i);
end
for i=1:length(ramp)
   wave(2*offset+i)=-gauss(offset+1-i);
end
for i=1:length(ramp)
   wave(3*offset+i)=-gauss(i);
end


plot(wave);
