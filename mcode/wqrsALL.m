% a=ls;
% b=a(:,[1:3]);
% [f,c]=size(b);
% d = [];
% for i = 1:f
%     d=[d ;(str2num(b([i],[1:3])))];
% end
% d = unique(d);
% [f,c] = size(d);
%for i=5:f
 %   signal=num2str(d(i))
   % wqrs(signal);
  % [preRR,posRR,avgRR,avgLRR,intervalQRS,morphologyQRS,intervalST,morphologyST,flagP]=featuresExtraction('100');
    %testEcgpuwave(signal); 
    [ann,type,subtype,chan,num,comments]=rdann('100','atr',[],[],[]);
    type=type(3:end);
    arffwrite('weka.arff','arrhythmia',{'preRR' 'posRR' 'avgLRR' 'intervalQRS' 'intervalST' 'flagP' 'class'},{'NUMERIC' 'NUMERIC' 'NUMERIC' 'NUMERIC' 'NUMERIC' 'NUMERIC' '{N,A,V}'},[preRR,posRR,avgLRR,intervalQRS,intervalST,flagP,type]);
%end

