function [corr, illum] = rg_rtm(nz, nx, nt, dz, dx, dt, npml, v, sxz, gxz, record, fdWfdFile, varargin)
% a single shot reverse time migration
displayFreq = inf;
showImage = 0;
writeWfd = 0;
wfdFile = [];
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
        case 'wfd'
            wfdFile = parameterValue;
            writeWfd = 1;
        otherwise
            error(['The parameter ''' parameterName ''' is not recognized by the function ''' mfilename '''.']);  
    end
end

ne = npml ;
nze = nz + 2*ne;
nxe = nx + 2*ne;

s = (sxz(:,2)+ne)*nze + sxz(:,1) + ne;  
g = (gxz(:,2)+ne)*nze + gxz(:,1) + ne; 

C = conv_matrix(dz, dx, 4);
v2 = boundary_pad(v, ne);

sp0 = zeros(nze,nxe);
sp1 = zeros(nze,nxe);
corr = zeros(nze, nxe);
illum = zeros(nze, nxe);

fdFid = fopen(fdWfdFile, 'r');
for it = nt:-1:1
    sp0 = step_fd(sp0, sp1, v2, nze, nxe, ne, dz, dx, dt, C, 0);
    sp0(g) = record(it, :);
    if (fseek(fdFid, (it-1)*nze*nxe*4, -1) == 0)
        snap = fread(fdFid, [nze, nxe], 'float32');
    else
        error(['Cannot open forward wavefield file "', fdWfdFile]);
    end
    corr = corr + sp0.*snap;
    illum = illum + snap.*snap;
    if(writeWfd && ~isemtpy(wfdFile))
        output(wfdFile, sp0);
    end

    ptr = sp0;
    sp0 = sp1;
    sp1 = ptr;
    
    if mod(it, displayFreq)==1
        fprintf('%i\t', it);
        if(showImage)
            imagesc([sp0/max(abs(sp0)), corr/max(abs(corr)), illum/max(abs(illum))]);colormap(gray), colorbar;drawnow;
        end
    end
end

fclose(fdFid);
if displayFreq < inf
    fprintf('\n');
end

end