clc
clear ;

addpath('benchmark');
addpath('data');


% file_name = 'snap';
% size = [561,1361*201];
file_name = 'seis';
size = [1361,2001*5];

fid_raw = fopen([file_name,'.bin'], 'rb');

out = fread(fid_raw, size, 'float32');

% figure(1)
% imagesc(out'), axis equal tight;colorbar
file_name = 'seis_direct';
size = [1361,2001*5];

fid_direct = fopen([file_name,'.bin'], 'rb');

out2 = fread(fid_direct, size, 'float32');

