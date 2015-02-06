% Demo ICA
%
%  15.01.06

close all;
n=4; % no. of signals
[sig,mixedsig]=demosig();
plot_signals (n, sig, 'source signals');
plot_signals (n, mixedsig, 'mixed signals');

[icasig, A, W] = fastica (mixedsig);
plot_signals (n, icasig, 'ICA signals');


