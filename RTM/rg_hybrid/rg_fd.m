function out = rg_fd(nz, nx, nt, dz, dx, dt, npml, v, wlt, sxz, gxz, varargin)

writeRecord = 0;
writeWfd = 0;
displayFreq = inf;
showImage = 0;
recordFile = [];
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
        case 'recordfile'
            recordFile = parameterValue;
            writeRecord = 1;
        case 'wfdfile'
            wfdFile = parameterValue;
            writeWfd = 1;
        otherwise
            error(['The parameter ''' parameterName ''' is not recognized by the function ''' mfilename '''.']);  
    end
end

ne = npml ;
nze = nz + 2*ne;
nxe = nx + 2*ne;
ng = size(gxz, 1);

s = (sxz(:,2)+ne)*nze + sxz(:,1) + ne;  
g = (gxz(:,2)+ne)*nze + gxz(:,1) + ne; 

C = conv_matrix(dz, dx, 4);
v2 = boundary_pad(v, ne);

sp0 = zeros(nze,nxe);
sp1 = zeros(nze,nxe);

out = zeros(nt, ng);
for it = 1:nt
  
    sp0 = step_fd(sp0, sp1, v2, nze, nxe, ne, dz, dx, dt, C, 0);
    sp0 = add_source(sp0, wlt(it), s, 0);
    
    if(writeWfd && ~isempty(wfdFile))
        output(wfdFile, sp0);
    end
    out(it, :) = sp0(g);
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
% write record to file
if(writeRecord && ~isempty(recordFile))
    output(recordFile, out);
end
if displayFreq < inf
    fprintf('\n');
end

end