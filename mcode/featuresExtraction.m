function[preRR,posRR,avgRR,avgLRR,intervalQRS,morphologyQRS,intervalST,morphologyST,flagP]=featuresExtraction(signal)
%wqrs('100s') -->considerar usar otro anotador qrs
%%ecgpuwave('100s','test','wqrs');

%Lee la señal
[tm,ecg] = rdsamp(signal);
%Filtra la señal
ecgf = wden(ecg(:,1),'heursure','s','one',2,'db4');
%Generar archivo con señal filtrada
%mat2wfdb(ecgf,'100s'); -->cambiar nombre

%Genera anotaciones picos, inicio y fin de P,QRS,T
%ecgpuwave(signal,'test',[],[],'wqrs');
[pwaves,ptype,psubtype,pchan,pnum,pcomments]=rdann(signal,'test',[],[],[],'p');
[twaves,ttype,tsubtype,tchan,tnum,tcomments]=rdann(signal,'test',[],[],[],'t');
[nwaves,ntype,nsubtype,nchan,nnum,ncomments]=rdann(signal,'test',[],[],[],'N');
[onwaves,ontype,onsubtype,onchan,numon,oncomments]=rdann(signal,'test',[],[],[],'(');
[offwaves,offtype,offsubtype,offchan,numoff,oncomments]=rdann(signal,'test',[],[],[],')');
[allwaves,alltype,allsubtype,allchan,allnum,allcomments]=rdann(signal,'test',[],[],[]);
%Grafica
%plot(tm,ecg(:,1));hold on;grid on
%plot(tm(twaves),ecg(twaves),'xg','MarkerSize',10)
%plot(tm(pwaves),ecg(pwaves),'xr','MarkerSize',10)
%plot(tm(nwaves),ecg(nwaves),'xr','MarkerSize',10)
%plot(tm(onwaves),ecg(onwaves),'ob','MarkerSize',10)
%plot(tm(offwaves),ecg(offwaves),'or','MarkerSize',10)

%RR-Intervals
%--------------------------------------------------------------------------
[nRpeaks,c] = size(nwaves);
preRR = zeros(nRpeaks,1);
posRR = zeros(nRpeaks,1);
avgRR = -1;

for i = 2 : nRpeaks-1
    preRR(i)= (nwaves(i))-  (nwaves(i-1));
    posRR(i)= (nwaves(i+1)) - (nwaves(i));
    avgRR = avgRR + preRR(i);
end

avgRR = (avgRR + posRR(nRpeaks-1))/nRpeaks;    %Average-RR interval
preRR(1)= avgRR;                                %Pre-RR interval
preRR(nRpeaks)= posRR(nRpeaks-1);
posRR(1)= preRR(2);
posRR(nRpeaks)= avgRR;                          %Pos-RR interval

avgLRR = zeros(nRpeaks,1);                      %avg local rr

startRR = posRR(1);
sum = 0;
%sum es la suma de los 10 primeros intervalos R-R
for i = 1:10
    sum = sum + posRR(i);
end
% a los primeros 4 damos el valor avg promedio de los primeros 10
for i = 1 : 4
    avgLRR(i) = sum/10;
end
% del 5 hasta los ultimos 5 se da el promedio de i-4 hasta i+5
for i = 5:nRpeaks-6
    avgLRR(i) = sum/10;
    sum = sum - startRR;
    startRR = posRR(i-3);
    sum = sum + posRR(i+6); 
end
%Los ultimos damos el valor promedio de los ultimos 10 R-R
for i=nRpeaks-5:nRpeaks
    avgLRR(i)=sum/10;
end
%Intervalos QRS

%--------------------------------------------------------------------------
[nOnset,c] = size(onwaves);
intervalQRS=zeros(nRpeaks,1);
cnt = 1;
morphologyQRS=zeros(nRpeaks*10,1);
counter = 1;
for i=1:nOnset
    if(numon(i)==1)
        if(numoff(i)==1)
            intervalQRS(cnt)=tm(offwaves(i))-tm(onwaves(i));
            intervals=ceil((offwaves(i)-onwaves(i))/10);            
            flag = onwaves(i);
            for j = 1:10
                morphologyQRS(counter)=ecgf(flag);
                counter = counter+1;
                flag = flag + intervals;
            end
        else
            intervalQRS(cnt)=-1;
        end
        cnt = cnt+1;
    end
end

%Intervalo ST
%--------------------------------------------------------------------------
[nOffset,c] = size(offwaves);
intervalST=zeros(nRpeaks,1);
cnt = 1;
i=1;
morphologyST=zeros(nRpeaks*10,1);
counter = 1;
while i < nOffset
    if(numoff(i)==1)
        offQRS = tm(offwaves(i));
        offqrsM = offwaves(i);
        while numoff(i)~=2
            i=i+1;
        end
        intervalST(cnt)=tm(offwaves(i))-offQRS;        
        cnt = cnt+1;
        intervals=ceil((offwaves(i)-offqrsM)/10);            
            flag = offqrsM;
            for j = 1:10
                morphologyST(counter)=ecgf(flag);
                counter = counter+1;
                flag = flag + intervals;
            end
    end
    i=i+1;
end

%Calcula onset de T,P y QRS
onsetT =  [];
onsetP =  [];
onsetQRS =  [];
for i = 1: nOnset
    if (numon(i)==0)
        onsetP=[onsetP onwaves(i)];
    end
    if (numon(i)==1)
        onsetQRS=[onsetQRS onwaves(i)];
    end
    if (numon(i)==2)
        onsetT=[onsetT onwaves(i)];
    end    
end

onsetT = onsetT'
onsetP = onsetP'
onsetQRS = onsetQRS'

% aca bandera si esta p 
flagP = zeros(nRpeaks,1);
count = nRpeaks+1;
for i=nOnset:-1:1
    if (numon(i)==1)
        count = count-1;
    end
    if (numon(i)==0)
       flagP(count)=1;
    end
    
end
%morfologia 1-a
