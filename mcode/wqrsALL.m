a=ls;
b=a(:,[1:3]);
[f,c]=size(b);
d = [];
for i = 1:f
    d=[d ;(str2num(b([i],[1:3])))];
end
d = unique(d);
[f,c] = size(d);
for i=f-1:-1:2
    signal=num2str(d(i))
    %wqrs(signal);
    featuresExtraction(signal); 
end

