function [] = rg_bd(nz, nx, nt, dz, dx, dt, npml, v, sxz, gxz, record, varargin)
% a single shot backward propagation
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

for it = nt:-1:1
  
    sp0 = step_fd(sp0, sp1, v2, nze, nxe, ne, dz, dx, dt, C, 0);
    sp0(g) = record(it, :);
    
    if(writeWfd && ~isemtpy(wfdFile))
        output(wfdFile, sp0);
    end

    ptr = sp0;
    sp0 = sp1;
    sp1 = ptr;
    
    if mod(it, displayFreq)==1
        fprintf('%i\t', it);
        if(showImage)
            imagesc(sp0);colormap(gray), colorbar;drawnow;
        end
    end
end

if displayFreq < inf
    fprintf('\n');
end

end