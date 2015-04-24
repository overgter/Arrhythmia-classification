% %function[preRR,posRR,avgRR,avgLRR,intervalQRS,morphologyQRS,intervalST,morphologyST,flagP]=featuresExtraction(signal)
% %wqrs('100s') -->considerar usar otro anotador qrs
% %%ecgpuwave('100s','test','wqrs');
% 
% %Lee la señal
[tm2,ecg] = rdsamp('233');
% %Filtra la señal
 %ecg2 = wden(ecg(:,1),'heursure','s','one',4,'db4');
 ecg2=ecg;
% mat2wfdb(ecg2,'235',360);
% sqrs('235');
% 
% %Genera anotaciones picos, inicio y fin de P,QRS,T
% ecgpuwave('235','test',[],[],'wqrs');
[pwaves2,ptype,psubtype,pchan,pnum,pcomments]=rdann('235','test',[],[],[],'p');
[twaves2,ttype,tsubbtype,tchan,tnum2,tcomments]=rdann('235','test',[],[],[],'t');
[nwaves2,ntype,nsubtype,nchan,nnum2,ncomments]=rdann('235','test',[],[],[],'N');
 [onwaves2,ontype,subtype,chan,numon2,comments]=rdann('235','test',[],[],[],'(');
 [offwaves2,offtype,subtype,chan,numoff2,comments]=rdann('235','test',[],[],[],')');
 [allwaves,alltype,allsubtype,allchan,allnum,allcomments]=rdann('235','test',[],[],[]);
% %Grafica
% %plot(tm,ecg(:,1));hold on;grid on
% %plot(tm(twaves),ecg(twaves),'xg','MarkerSize',10)
% %plot(tm(pwaves),ecg(pwaves),'xr','MarkerSize',10)
% %plot(tm(nwaves),ecg(nwaves),'xr','MarkerSize',10)
% %plot(tm(onwaves),ecg(onwaves),'ob','MarkerSize',10)
% %plot(tm(offwaves),ecg(offwaves),'or','MarkerSize',10)
% 
% %RR-Intervals
% %--------------------------------------------------------------------------
[nRpeaks2,c] = size(nwaves2);
preRR2 = zeros(nRpeaks2,1);
posRR2 = zeros(nRpeaks2,1);
avgRR2 = -1;

for i = 2 : nRpeaks2-1
    preRR2(i)= (nwaves2(i))-  (nwaves2(i-1));
    posRR2(i)= (nwaves2(i+1)) - (nwaves2(i));
    avgRR2 = avgRR2 + preRR2(i);
end

avgRR2 = (avgRR2 + posRR2(nRpeaks2-1))/nRpeaks2;    %Average-RR interval
preRR2(1)= avgRR2;                                %Pre-RR interval
preRR2(nRpeaks2)= posRR2(nRpeaks2-1);
posRR2(1)= preRR2(2);
posRR2(nRpeaks2)= avgRR2;                          %Pos-RR interval

avgLRR2 = zeros(nRpeaks2,1);                      %avg local rr

startRR2 = posRR2(1);
sum = 0;
%sum es la suma de los 10 primeros intervalos R-R
for i = 1:10
    sum = sum + posRR2(i);
end
% a los primeros 4 damos el valor avg promedio de los primeros 10
for i = 1 : 4
    avgLRR2(i) = sum/10;
end
% del 5 hasta los ultimos 5 se da el promedio de i-4 hasta i+5
for i = 5:nRpeaks2-6
    avgLRR2(i) = sum/10;
    sum = sum - startRR2;
    startRR2 = posRR2(i-3);
    sum = sum + posRR2(i+6); 
end
%Los ultimos damos el valor promedio de los ultimos 10 R-R
for i=nRpeaks2-5:nRpeaks2
    avgLRR2(i)=sum/10;
end
%Intervalos QRS

%--------------------------------------------------------------------------
[nOnset2,c] = size(onwaves2);
intervalQRS2=zeros(nRpeaks2,1);
cnt = 1;
morphologyQRS2=zeros(nRpeaks2*10,1);
counter = 1;
for i=1:nOnset2
    if(numon2(i)==1)
        if(numoff2(i)==1)
            intervalQRS2(cnt)=tm2(offwaves2(i))-tm2(onwaves2(i));
            intervals2=ceil((offwaves2(i)-onwaves2(i))/10);            
            flag2 = onwaves2(i);
            for j = 1:10
                morphologyQRS2(counter)=ecg2(flag2);
                counter = counter+1;
                flag2 = flag2 + intervals2;
            end
        else
            intervalQRS2(cnt)=-1;
        end
        cnt = cnt+1;
    end
end

%Intervalo ST
%--------------------------------------------------------------------------
[nOffset2,c] = size(offwaves2);
intervalST2=zeros(nRpeaks2,1);
cnt = 1;
i=1;
morphologyST2=zeros(nRpeaks2*10,1);
counter = 1;
while i < nOffset2
    if(numoff2(i)==1)
        offQRS2 = tm2(offwaves2(i));
        offqrsM2 = offwaves2(i);
        while numoff2(i)~=2
            i=i+1;
        end
        intervalST2(cnt)=tm2(offwaves2(i))-offQRS2;        
        cnt = cnt+1;
        intervals2=ceil((offwaves2(i)-offqrsM2)/10);            
            flag = offqrsM2;
            for j = 1:10
                morphologyST2(counter)=ecg2(flag);
                counter = counter+1;
                flag = flag + intervals2;
            end
    end
    i=i+1;
end

%Calcula onset de T,P y QRS
onsetT2 =  [];
onsetP2 =  [];
onsetQRS2 =  [];
for i = 1: nOnset2
    if (numon2(i)==0)
        onsetP2=[onsetP2 onwaves2(i)];
    end
    if (numon2(i)==1)
        onsetQRS2=[onsetQRS2 onwaves2(i)];
    end
    if (numon2(i)==2)
        onsetT2=[onsetT2 onwaves2(i)];
    end    
end

onsetT2 = onsetT2'
onsetP2 = onsetP2'
onsetQRS2 = onsetQRS2'

%Calcula offset de T,P y QRS
offsetT2 =  [];
offsetP2 =  [];
offsetQRS2 =  [];
for i = 1: nOffset2
    if (numoff2(i)==0)
        offsetP2=[offsetP2 offwaves2(i)];
    end
    if (numoff2(i)==1)
        offsetQRS2=[offsetQRS2 offwaves2(i)];
    end
    if (numoff2(i)==2)
        offsetT2=[offsetT2 offwaves2(i)];
    end    
end

offsetT2 = offsetT2'
offsetP2 = offsetP2'
offsetQRS2 = offsetQRS2'
% aca bandera si esta p 
flagP2 = zeros(nRpeaks2,1);
count = nRpeaks2+1;
for i=nOnset2:-1:1
    if (numon2(i)==1)
        count = count-1;
    end
    if (numon2(i)==0)
       flagP2(count)=1;
    end
    
end
%morfologia 1-a



 
