function [markers,types,ann] = mergeMarkers(A,B,typeA,typeB,annA, annB)
indexA=1;
indexB=1;
nAmarks = size(A,1);
nBmarks = size(B,1);
limit = min([nApeaks nBpeaks]);
markers = zeros(nAmarks+nBmarks,1);
types = zeros(nAmarks+nBmarks,1);
ann = zeros(nAmarks+nBmarks,1);
flag = true;
while (flag == true)
            
    if (A(indexA,1)< B(indexB,1))
        markers(indexA,1)= A(indexA,1);
        types(indexA,1)= typeA(indexA,1);
        ann(indexA,1)= annA(indexA,1);
        indexA = indexA + 1;
    else
        markers(indexB,1)= B(indexB,1);
        types(indexB,1)= typeB(indexB,1);
        ann(indexB,1)= annB(indexB,1);
        indexB = indexB + 1;
    end
    
    if (indexA>nAmarks)
        markers(indexA:end)=B(indexB:end);
        flag=false;
    end
    if(indexB>nBmarks)
        markers(indexB:end)=A(indexA:end);
        flag=false;
    end    
  
end

