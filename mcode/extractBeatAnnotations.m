function [ann] = extractBeatAnnotations(signal)
  [tm,ann1]=rdann(signal,'atr');
  ann = [];  
  for i=1:size(ann1,1)  
     % if(ann1(i) == 'A' || ann1(i)== 'N' || ann1(i)== 'V' || ann1(i)== 'Q' || ann1(i)== '/' || ann1(i)== 'f' || ann1(i)== 'j' || ann1(i)== 'L' || ann1(i)== 'R' || ann1(i)== 'E' || ann1(i)== 'S')
      ann = [ann ann1(i)];
  end
end