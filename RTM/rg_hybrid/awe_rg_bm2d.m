function [] = awe_rg_bm2d(nz, nx, nt, dz, dx, dt, npml, v, sxz, gxz, wfdDir, varargin)
%recordDir, wavefieldDir)
% Optional inputs
% records   -- 2D matrix in size of [nt, ng*ns] of records for all shots
% recorddir -- directory where the recorded seismic signal stored
% At least one of records/recorddir should be input. 


displayFreq = inf;
showImage = 0;
records = [];
readRecord = 0;
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
        case 'records'
            records = parameterValue;
        case 'recorddir'
            recordDir = parameterValue;
            readRecord = 1;
        otherwise
            error(['The parameter ''' parameterName ''' is not recognized by the function ''' mfilename '''.']);  
    end
end
if (readRecord && ~exist(recordDir, 'dir'))
    error(['No such a directory', recordDir]);
else
    if (readRecord && (recordDir(end) ~= '\'))
        recordDir = [recordDir, '\'];
    end
end
if (isempty(records) && ~readRecord)
    error(['At least one in parameter set {records, recordDir} should be input.']);
end

if ~exist(wfdDir, 'dir')
    mkdir(wfdDir)
end
if wfdDir(end) ~= '\'
    wfdDir = [wfdDir, '\'];
end


ns = size(sxz, 1);
ng = size(gxz, 1);

if ~isempty(records)
    for ishot = 1:ns
        disp(['\n Shot: ', num2str(ishot), ', source location: x-', num2str(sxz(ishot, 2)), ' z-', num2str(sxz(ishot, 1))]);
        record = records(:, (ishot-1)*ng+1:ishot*ng);
        wfdFile = [wfdDir, 'wfd_x', num2str(sxz(ishot, 2)), '_z', num2str(sxz(ishot, 1)), '.bin'];
        if exist(wfdFile, 'file')
            fid = fopen(wfdFile, 'w');
            fclose(fid);
        end
        rg_bd(nz, nx, nt, dz, dx, dt, npml, v, sxz(ishot,:), gxz, record, 'wfd', wfdFile, ...
            'display', displayFreq, 'show', showImage);
    end  
    return;
end


if (readRecord)
    for ishot = 1:ns
        disp(['\n Shot: ', num2str(ishot), ', source location: x-', num2str(sxz(ishot, 2)), ' z-', num2str(sxz(ishot, 1))]);
        recordFile = [recordDir, 'shot_x', num2str(sxz(ishot, 2)), '_z', num2str(sxz(ishot, 1)), '.bin'];
        record = bin_read(recordFile, [nt, ng], 'float32');
        wfdFile = [wfdDir, 'wfd_x', num2str(sxz(ishot, 2)), '_z', num2str(sxz(ishot, 1)), '.bin'];
        if exist(wfdFile, 'file')
            fid = fopen(wfdFile, 'w');
            fclose(fid);
        end
        rg_bd(nz, nx, nt, dz, dx, dt, npml, v, sxz(ishot,:), gxz, record, 'wfd', wfdFile, ...
            'display', displayFreq, 'show', showImage);
    end
    return;
end

