function [rfl, corr, illum] = corrStack(nz, nx, nt, npml, sxz, fdFolder, bdFolder, varargin)
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
        otherwise
            error(['The parameter ''' parameterName ''' is not recognized by the function ''' mfilename '''.']);  
    end
end

ne = npml;
nze = nz + 2*ne;
nxe = nx + 2*ne;

ns = size(sxz, 1);

illum = zeros(nze, nxe, ns);
corr  = zeros(nze, nxe, ns);

if fdFolder(end) ~= '\'
    fdFolder = [fdFolder, '\'];
end
if bdFolder(end) ~= '\'
    bdFolder = [bdFolder, '\'];
end

for ishot = 1 : ns
    fdFile = [fdFolder, 'wfd_x', num2str(sxz(ishot, 2)), '_z', num2str(sxz(ishot, 1)), '.bin'];
    bdFile = [bdFolder, 'wfd_x', num2str(sxz(ishot, 2)), '_z', num2str(sxz(ishot, 1)), '.bin'];
    fdFid = fopen(fdFile, 'r');
    bdFid = fopen(bdFile, 'r');
    disp(['Shot: ', num2str(ishot), ', source location: x-', num2str(sxz(ishot, 2)), ' z-', num2str(sxz(ishot, 1))]);
    for it = 1 : nt
        fdOffset = (it-1)*nze*nxe*4;
        bdOffset = (nt-it)*nze*nxe*4;
        fseek(fdFid, fdOffset, -1);
        fseek(bdFid, bdOffset, -1);
        fdWfd = fread(fdFid, [nze, nxe], 'float32');
        bdWfd = fread(bdFid, [nze, nxe], 'float32');
        if (showImage)
            if mod(it, displayFreq)==0
                imagesc([fdWfd,bdWfd]), colormap(gray), colorbar;
                pause(0.2);
            end
        end
        illum(:, :, ishot) = illum(:, :, ishot) + fdWfd.*fdWfd;
        corr(:, :, ishot) = corr(:, :, ishot) + fdWfd.*bdWfd;
    end
    fclose(fdFid);
    fclose(bdFid);
end

rfl = sum(corr(ne+1:nz+ne, ne+1:nx+ne, :), 3)./sum(illum(ne+1:nz+ne, ne+1:nx+ne, :), 3);

return