%Features para reproducir el paper Arrhythmia Detection in Single lead ECG by Combining Beat and Rhythmlevel Information
function [beats Fft35 Magnitude Phase RRInterval RPCentered]=frequencyFeatures(signal)
  %pkg load signal;
  %Leemos la señal
  [ecg,HDR]=sload([signal '.dat']);
  
  %Leemos los picos R en donde se encuentran las anotaciones
  
  %[nwaves]=rdann(signal,'test',[],[],[],'N');
  %Leemos las anotaciones de la señal
  [tmann,ann]=extractBeatAnnotations(signal);
  %Partimos la señal y la guardamos en beats
 
  NRPeaks = size(tmann,1)
  beats = cell(NRPeaks-2,2);
  Fft35 = cell(NRPeaks-2,1);
  Magnitude = cell(NRPeaks-2,1);
  Phase = cell(NRPeaks-2,1);
  for i=1:NRPeaks-2 
    beats(i,1) = {resample(ecg(tmann(i):tmann(i+2)),100,size(ecg(tmann(i):tmann(i+2)),2))};    
    %se supone que hay una anotacion por cada beat
    beats(i,2) = {ann(i+1)}; 
    Fft35(i) = {fft(beats{i,1})};
    Magnitude(i) = {abs(Fft35{i})};
    Phase(i) = {unwrap(angle(Fft35{i}))};
  end 
end