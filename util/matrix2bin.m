clc
clear ;


file_name = 'rec_loc';
size = 1361;
location = 15*ones(size,1);

% file_name = 'src_loc';
% location = [2 2 2 2 2; 250 500 750 1000 1250];

fid = fopen([file_name,'.bin'],'wb');
if(fid>0)
   fwrite(fid, location, 'float32');
end
fclose(fid);

