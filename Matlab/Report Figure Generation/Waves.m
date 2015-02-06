t=1:0.01:1000;
ramp=0:0.001:1;
T=length(ramp);
ramp = [ramp ramp ramp 0];
t=1:length(ramp);

square = ones(1, length(ramp));
for i=1:length(ramp)
    if(ramp(i)>0.5)
        square(i)=-1;
    else 
        square(i)=1;
    end
end

for i=1:length(ramp)
    gauss(i)=1*power(e,(-(ramp(i)-1)^2)/(2*3^2));
end

sine = sin(2*pi*2*T*ramp);

subplot (3,2,1);
plot(t,ramp);
subplot(3,2,2);
plot(square);
subplot(3,2,3);
plot(sine);
subplot(3,2,4);
plot(gauss);
