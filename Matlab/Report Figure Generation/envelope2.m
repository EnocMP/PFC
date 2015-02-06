slope = 4;

attack = 2000;
decay = 1000;
sustain = 500;
sustainLevel = 0.7;
release = 2000;
att = 1/attack;
dec=1/decay;
rel=1/release;
rampatt=zeros(1, attack);
envelopes=zeros();


rampatt(1)=0;
for i=2:attack
    rampatt(i)=rampatt(i-1)+att;
end
rampatt=rampatt.^slope;

rampdec=ones(1,decay);
rampdec(1)=1;
for i=2:decay
    rampdec(i)=rampdec(i-1)-dec;
end
rampdec=sustainLevel+(1-sustainLevel)*rampdec.^slope;



rampsus=ones(1, sustain)*sustainLevel;


envelopes=[rampatt rampdec rampsus];
%%%%%%%%%%%%%%%%%%%
rampatt(1)=0;
att2=(1)/attack;

for i=2:attack
    rampatt(i)=rampatt(i-1)+att2;
end
rampatt=sustainLevel+(1-sustainLevel)*rampatt.^slope;

rampdec=ones(1,decay);
rampdec(1)=1;
for i=2:decay
    rampdec(i)=rampdec(i-1)-dec;
end
rampdec=sustainLevel+(1-sustainLevel)*rampdec.^slope;



rampsus=ones(1, sustain)*sustainLevel;

ramprel=ones(1,release+1);
ramprel(1)=1;
for i=2:release
    ramprel(i)=ramprel(i-1)-rel;
end
ramprel=sustainLevel*(ramprel.^slope);
ramprel(length(ramprel))= 0;
envelopes=[envelopes rampatt rampdec rampsus ramprel];

figure('Color',[1 1 1]);
plot(envelopes);
