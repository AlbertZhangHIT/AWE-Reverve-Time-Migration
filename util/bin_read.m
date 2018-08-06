% binary file reading 
function y = bin_read(file, size, precision)

 fid = fopen(file, 'rb');
 y = fread(fid, size, precision);
 fclose(fid);
 
return;