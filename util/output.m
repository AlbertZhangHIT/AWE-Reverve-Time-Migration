function [] = output(fname, A)

fid = fopen(fname, 'a');
if(fid>0)
    fwrite(fid, A, 'float32');
else
    disp('Cannot open file');
    return;
end
fclose(fid);

end