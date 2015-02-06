function plot_signals( n, sig, tit )
%PLOT_SIGNALS plot a group of signals taken from a source separation problem 
%   n: no. of signals 
%   sig: signals
%   tit: title for figure

    figure; 
    for i=1:n,
        subplot(n,1,i); plot(sig(i,:));
        if i==1, 
            title (tit); 
        end
    end
    
end

