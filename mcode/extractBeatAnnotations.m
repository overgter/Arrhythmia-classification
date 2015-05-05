function [tm,ann] = extractBeatAnnotations(signal)
%extractBeatAnnotations Extrae los beats que tienen anotaciones
% L	Left bundle branch block beat
% R	Right bundle branch block beat
% A	Atrial premature beat
% a	Aberrated atrial premature beat
% J	Nodal (junctional) premature beat
% S	Supraventricular premature beat
% V	Premature ventricular contraction
% F	Fusion of ventricular and normal beat
% e	Atrial escape beat
% j	Nodal (junctional) escape beat
% E	Ventricular escape beat
% /	Paced beat
% f	Fusion of paced and normal beat
%
%INPUT: 
%   signal: Nombre de la señal
%OUTPUT:
%   ann: Vector Nx1 de caracteres describiendo el tipo de la anotacion
%   tm:  Vector Nx1 de ints. El tiempo donde se encuentra cada anotacion en
%   muestras con respecto a la primera muestra en la señal 'signal'
% Fin de ayuda

%Lee todas las anotaciones de Signal
  [alltm,allAnn]=rdann(signal,'atr');
  %Arreglos dinamicos para almacenar informacion
  ann = []; 
  tm = [];
  for i=1:size(allAnn,1)  
     % Se escogen los unicamente las anotacioenes de beats
     if(allAnn(i) == 'A' || allAnn(i)== 'N' || allAnn(i)== 'V' || allAnn(i)== 'Q'...
         || allAnn(i)== '/' || allAnn(i)== 'f' || allAnn(i)== 'F' || allAnn(i)== 'j' ...
         || allAnn(i)== 'L' || allAnn(i)== 'R' || allAnn(i)== 'E' || allAnn(i)== 'S'...
         ||allAnn(i)== 'a' || allAnn(i)== 'J' || allAnn(i)== 'e')
      ann = [ann allAnn(i)]; 
      tm = [tm alltm(i)]; 
     end
  end
 ann=ann';
 tm=tm';