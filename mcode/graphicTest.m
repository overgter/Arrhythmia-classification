function graphicTest()
[wqrs]=rdann('233','wqrs');
[puwave]=rdann('233','test',[],[],[],'N');
[tm,ecg]=rdsamp('233');
[ann]=rdann('233','atr');
plot(tm(1:3000),ecg(1:3000,1));hold on;plot(tm(puwave(1:10)),ecg(puwave(1:10)),'*r');hold on;plot(tm(wqrs(1:10)),ecg(wqrs(1:10)),'*c');hold on;plot(tm(ann(1:30)),ecg(ann(1:30)),'or')
plot(tm(1:3000),ecg(1:3000,1));hold on;plot(tm(puwave(1:10)),ecg(puwave(1:10)),'*r');hold on;plot(tm(wqrs(1:10)),ecg(wqrs(1:10)),'*c');hold on;plot(tm(ann(1:10)),ecg(ann(1:10)),'ob')
plot(tm(1:3000),ecg(1:3000,1));hold on;plot(tm(puwave(1:10)),ecg(puwave(1:10)),'*r');hold on;plot(tm(wqrs(1:10)),ecg(wqrs(1:10)),'*c');hold on;plot(tm(ann(1:20)),ecg(ann(1:20)),'ob')