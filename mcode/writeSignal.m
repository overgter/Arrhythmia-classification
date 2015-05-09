function writeSignal(signal)
%-------------------------------
nAttribute = size(signal,2);
format = [];
for i=1:nAttribute-1
   format = [format ' %6.4f,'];
end
 format = [format '%6.4f,'];
fid = fopen('prueba.txt','w');
fprintf(fid,format,signal);
fclose(fid);
