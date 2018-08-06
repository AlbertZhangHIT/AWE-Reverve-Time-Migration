function writeRecords(nt, gxz, sxz, records, rcFolder)
if rcFolder(end) ~= '\'
    rcFolder = [rcFolder, '\'];
end
if ~exist(rcFolder, 'dir')
    mkdir(rcFolder);
end
ns = size(sxz, 1);
ng = size(gxz, 1);
if size(records, 1) ~= nt || size(records, 2) ~= ng*ns
    error('Dimension does not match');
end

for ishot = 1 : ns
    recordFile = [rcFolder, 'shot_x', num2str(sxz(ishot, 2)), '_z', num2str(sxz(ishot, 1)), '.bin'];
    if exist(recordFile, 'file')
        delete(recordFile);
    end
    output(recordFile, records(:,(ishot-1)*ng+1:ishot*ng));
end

end
    