classdef SineModObject < matlab.System

  %define step method
  
  %when called, the step method returns a vector (with length = samples)
  %with the value of the output signal (a sine wave modulated by other
  %sine). The signal is generated taking into account the starting phase
  %(phase_offset), the frequency, the number of samples and the modulatoin
  %coefficient
  
  methods (Access=protected)      
    function y = stepImpl(~,freq_in, phase_offset, samples, Mod)
        fs = 44100; %defining sampling frequency
        z=zeros(1, samples); %vector initialization
        y=zeros(1, samples);

        for i = 1:samples
            phase=(i-1)/fs; %calculation of the phase increment
            z(i) = sin(2*pi*freq_in*(phase_offset+phase)); %sine calculation
            y(i) = sin(2*pi*(freq_in )*(phase_offset+phase)+ 10*Mod*z(i)); % modulated sine calculation           
        end       
    end
  end
  
  %define number of inputs
  methods (Access=protected)
   function numIn = getNumInputsImpl(~)
      numIn = 4;
   end
 
  %define number of outputs
   function numOut = getNumOutputsImpl(~)
      numOut = 1;
   end
  end
end