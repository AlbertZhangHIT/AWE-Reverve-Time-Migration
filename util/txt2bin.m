clc
clear ;

addpath('benchmark')

file_name = 'density_marmousi-ii';

tic
V = dlmread([file_name,'.txt'])';%%(trace number:13601;sampling number 2801; sampling rate:4.816ms)
toc
imagesc(V), axis equal tight
colormap(seismic), colorbar

%% Resample

% V = V(1:5:end, 1:10:end);

% imagesc(V), axis equal tight
% colormap seismic;
% %colorbar('NorthOutside')
% drawnow

% % vectorize to 1D
% V = V(:);

% fid = fopen(['benchmark\',file_name,'.bin'],'wb');
% if(fid>0)
%     fwrite(fid, V, 'float32');
% end
% fclose(fid);
% sigsbee2a_migration_velocity = V;
save('benchmark\density_marmousi-ii', 'V')
