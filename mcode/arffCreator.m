function arffCreator ()
     m=cell(101,1);
     num=cell(101,1);
%     p=cell(101,1);
%     for i=1:100
%         m(i)={strcat('m',num2str(i))};
%         num(i)={'NUMERIC'};
%     end
%     
%     m(101)={'class'};
%     num(101)={'{A,N,Q,V,/,f,J,L,R,E,S}'};
    
    
a=ls;
b=a(:,[1:3]);
[f,c]=size(b);
d = [];
for i = 1:f
     d=[d ;(str2num(b([i],[1:3])))];
end
d = unique(d);
[f,c] = size(d);
%for i=1:f
 %  signal=num2str(d(i))
   [beats Fft35 Magnitude Phase]=frequencyFeatures('200');
   
   for j=1:size(Magnitude,1)
       j;
       size(Magnitude{2});
        size(beats{j,2}); 
       arffrewrite('weka.arff','arrhythmia',m,num,[Magnitude{j} beats{j,2}]);        
   end
%end
    