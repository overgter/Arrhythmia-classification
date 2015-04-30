%Features para reproducir el paper Arrhythmia Detection in Single lead ECG by Combining Beat and Rhythmlevel Information
function [beats Fft35 Magnitude Phase RRInterval RPCentered]=frequencyFeatures(signal)
  pkg load signal;
  %Leemos la señal
  [tm,ecg]=rdsamp(signal);
  
  %Leemos los picos R 
  
  [nwaves]=rdann('100','test',[],[],[],'N');
  %Leemos las anotaciones de la señal
  [ann]=extractBeatAnnotations(signal);
  %Partimos la señal y la guardamos en beats
  NRPeaks = size(nwaves,1);
  beats = cell(NRPeaks,2);
  for i=1:NRPeaks-2
    beats(i,1) = resample(ecg(nwaves(i):nwaves(i+2)),100,size(ecg(nwaves(i):nwaves(i+2)),2));    
    %se supone que hay una anotacion por cada beats
    beats(i,2) = [ann(i+1)]; 
  end 
end