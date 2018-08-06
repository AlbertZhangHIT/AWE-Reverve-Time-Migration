function [out] = awe_stg_fm2d(nz, nx, nt, dz, dx, dt, npml, v, wlt, sxz, gxz, varargin)
% Optional inputs
% recorddir -- directory to store the recorded seismic signal
% wfddir    -- directory to store the wavefields of forward modeling
writeRecord = 0;
writeWfd = 0;
displayFreq = inf;
showImage = 0;
%Parse the optional inputs.
if (mod(length(varargin), 2) ~= 0 )
    error(['Extra Parameters passed to the function ''' mfilename ''' lambdast be passed in pairs.']);
end
parameterCount = length(varargin)/2;
for parameterIndex = 1:parameterCount
    parameterName = varargin{parameterIndex*2 - 1};
    parameterValue = varargin{parameterIndex*2};
    switch lower(parameterName)
        case 'show'
            showImage = parameterValue;
        case 'display'
            displayFreq = parameterValue;
        case 'recorddir'
            recordDir = parameterValue;
            writeRecord = 1;
        case 'wfddir'
            wfdDir = parameterValue;
            writeWfd = 1;
        otherwise
            error(['The parameter ''' parameterName ''' is not recognized by the function ''' mfilename '''.']);  
    end
end

if (writeRecord)
    if recordDir(end) ~= '\'
        recordDir = [recordDir, '\'];
    end
    if ~exist(recordDir, 'dir')
        mkdir(recordDir);
    end
end

if (writeWfd)
    if wfdDir(end) ~= '\'
        wfdDir = [wfdDir, '\'];
    end
    if ~exist(wfdDir, 'dir')
        mkdir(wfdDir);
    end
end

ns = size(sxz, 1);
ng = size(gxz, 1);
out = [];
if (writeRecord && writeWfd) 
    for ishot = 1 : ns
        disp(['\n Shot: ', num2str(ishot), ', source location: x-', num2str(sxz(ishot, 2)), ' z-', num2str(sxz(ishot, 1))]);
        recordFile = [recordDir, 'shot_x', num2str(sxz(ishot, 2)), '_z', num2str(sxz(ishot, 1)), '.bin'];
        wfdFile = [wfdDir, 'wfd_x', num2str(sxz(ishot, 2)), '_z', num2str(sxz(ishot, 1)), '.bin'];
        if exist(recordFile, 'file')
            fid = fopen(recordFile, 'w');
            fclose(fid);
        end
        if exist(wfdFile, 'file')
            fid = fopen(wfdFile, 'w');
            fclose(fid);
        end
        tmp = stg_fd(nz, nx, nt, dz, dx, dt, npml, v, wlt, sxz(ishot, :), gxz, 'recordfile', recordFile, ...
                'wfdfile', wfdFile, 'show', showImage, 'display', displayFreq);
    end
end

if (writeRecord && ~writeWfd) 
    for ishot = 1 : ns
        disp(['\n Shot: ', num2str(ishot), ', source location: x-', num2str(sxz(ishot, 2)), ' z-', num2str(sxz(ishot, 1))]);
        recordFile = [recordDir, 'shot_x', num2str(sxz(ishot, 2)), '_z', num2str(sxz(ishot, 1)), '.bin'];
        if exist(recordFile, 'file')
            fid = fopen(recordFile, 'w');
            fclose(fid);
        end
        tmp = stg_fd(nz, nx, nt, dz, dx, dt, npml, v, wlt, sxz(ishot, :), gxz, 'recordfile', recordFile, ...
                'show', showImage, 'display', displayFreq);
    end
end

if (~writeRecord && writeWfd) 
    out = zeros(nt, ns*ng);
    for ishot = 1 : ns
        disp(['\n Shot: ', num2str(ishot), ', source location: x-', num2str(sxz(ishot, 2)), ' z-', num2str(sxz(ishot, 1))]);
        wfdFile = [wfdDir, 'wfd_x', num2str(sxz(ishot, 2)), '_z', num2str(sxz(ishot, 1)), '.bin'];
        if exist(wfdFile, 'file')
            fid = fopen(wfdFile, 'w');
            fclose(fid);
        end
        tmp = stg_fd(nz, nx, nt, dz, dx, dt, npml, v, wlt, sxz(ishot, :), gxz, ...
                'wfdfile', wfdFile, 'show', showImage, 'display', displayFreq);
        out(:, (ishot-1)*ng+1:ishot*ng) = tmp;
    end
end

if (~writeRecord && ~writeWfd) 
    out = zeros(nt, ns*ng);
    for ishot = 1 : ns
        disp(['\n Shot: ', num2str(ishot), ', source location: x-', num2str(sxz(ishot, 2)), ' z-', num2str(sxz(ishot, 1))]);
        tmp = stg_fd(nz, nx, nt, dz, dx, dt, npml, v, wlt, sxz(ishot, :), gxz, ...
                'show', showImage, 'display', displayFreq);
        out(:, (ishot-1)*ng+1:ishot*ng) = tmp;
    end
end
   
return;
