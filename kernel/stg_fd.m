% Acoustic wave equation forward modeling utilizing perfectly match layer 
% absorbing boundary condition.
% Author: Hao Zhang, Harbin Institute of Technology
%         Sep. 8, 2017 
% Modificaion: July. 29, 2018


function [out] = stg_fd(nz, nx, nt, dz, dx, dt, npml, v, wlt, sxz, gxz, varargin)
writeRecord = 0;
writeWfd = 0;
displayFreq = inf;
showImage = 0;
recordFile = [];
freeSurf = 0;
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
        case 'freesurf'
            freeSurf = parameterValue;
        otherwise
            error(['The parameter ''' parameterName ''' is not recognized by the function ''' mfilename '''.']);  
    end
end

ne = npml ;
coef = DCoef(4, 's');

%%% check stability
if dt >= 1 / (sqrt(2) * max(v(:))/(min(dx, dz))) / sum(abs(coef))
    error('The numerical configuration leads to unstability, please reset.');
end

[d1, d2] = pml_Coef(nz, nx, dz, dx, npml, v);
if freeSurf
    d2(1:round(end/2),:) = 0;
end
nze = nz + 2*ne;
nxe = nx + 2*ne;
ng = size(gxz, 1);

U = zeros(nze, nxe);
Ux = zeros(nze, nxe);
Uz = zeros(nze, nxe);
Vx = zeros(nze, nxe);
Vz = zeros(nze, nxe);
v = boundary_pad(v, ne);
v = v.*v;

s = (sxz(:,2)+ne)*nze + sxz(:,1) + ne;  
g = (gxz(:,2)+ne)*nze + gxz(:,1) + ne; 

dtx = dt/dx;
dtz = dt/dz;

%explicite scheme
% d1x = 1 - dt*d1;
% d2z = 1 - dt*d2;
% d11 = dtx;
% d22 = dtz;

% % implicite scheme
d1x = (2 - dt*d1)./(2 + dt*d1);
d2z = (2 - dt*d2)./(2 + dt*d2);
d11 = 2*dtx./(2 + dt*d1);
d22 = 2*dtz./(2 + dt*d2);

out = zeros(nt, ng);
for it = 1:nt
        U(s) = U(s) + wlt(it,:);
        % explicite scheme
%         Vx(5:nze-4, 5:nxe-4) = d1x(5:nze-4, 5:nxe-4).*Vx(5:nze-4, 5:nxe-4) + d11.*(...
%                                coef(1)*( U(5:nze-4, 6:nxe-3) - U(5:nze-4, 5:nxe-4) ) +  ...
%                                coef(2)*( U(5:nze-4, 7:nxe-2) - U(5:nze-4, 4:nxe-5) ) + ...
%                                coef(3)*( U(5:nze-4, 8:nxe-1) - U(5:nze-4, 3:nxe-6) ) + ...
%                                coef(4)*( U(5:nze-4, 9:nxe) - U(5:nze-4, 2:nxe-7) ) ); 
%         Vz(5:nze-4, 5:nxe-4) = d2z(5:nze-4, 5:nxe-4).*Vz(5:nze-4, 5:nxe-4) + d22.*(...
%                                coef(1)*( U(6:nze-3, 5:nxe-4) - U(5:nze-4, 5:nxe-4) ) + ...
%                                coef(2)*( U(7:nze-2, 5:nxe-4) - U(4:nze-5, 5:nxe-4) ) + ...
%                                coef(3)*( U(8:nze-1, 5:nxe-4) - U(3:nze-6, 5:nxe-4) ) + ...
%                                coef(4)*( U(9:nze, 5:nxe-4) - U(2:nze-7, 5:nxe-4) ) );
%         Ux(5:nze-4, 5:nxe-4) = d1x(5:nze-4, 5:nxe-4).*Ux(5:nze-4, 5:nxe-4) + d11.*v(5:nze-4, 5:nxe-4).*( ...
%                                coef(1)*( Vx(5:nze-4, 5:nxe-4) - Vx(5:nze-4, 4:nxe-5) ) + ...
%                                coef(2)*( Vx(5:nze-4, 6:nxe-3) - Vx(5:nze-4, 3:nxe-6) ) + ...
%                                coef(3)*( Vx(5:nze-4, 7:nxe-2) - Vx(5:nze-4, 2:nxe-7) ) + ...
%                                coef(4)*( Vx(5:nze-4, 8:nxe-1) - Vx(5:nze-4, 1:nxe-8) ) );
%         Uz(5:nze-4, 5:nxe-4) = d2z(5:nze-4, 5:nxe-4).*Uz(5:nze-4, 5:nxe-4) + d22.*v(5:nze-4, 5:nxe-4).*(...
%                                coef(1)*( Vz(5:nze-4, 5:nxe-4) - Vz(4:nze-5, 5:nxe-4) ) + ...
%                                coef(2)*( Vz(6:nze-3, 5:nxe-4) - Vz(3:nze-6, 5:nxe-4) ) + ...
%                                coef(3)*( Vz(7:nze-2, 5:nxe-4) - Vz(2:nze-7, 5:nxe-4) ) + ...
%                                coef(4)*( Vz(8:nze-1, 5:nxe-4) - Vz(1:nze-8, 5:nxe-4) ) );
        % implicite scheme
        Vz(4:nze-4, 4:nxe-4) = d2z(4:nze-4, 4:nxe-4).*Vz(4:nze-4, 4:nxe-4) + d22(4:nze-4, 4:nxe-4).*(...
                               coef(1)*( U(5:nze-3, 4:nxe-4) - U(4:nze-4, 4:nxe-4) ) + ...
                               coef(2)*( U(6:nze-2, 4:nxe-4) - U(3:nze-5, 4:nxe-4) ) + ...
                               coef(3)*( U(7:nze-1, 4:nxe-4) - U(2:nze-6, 4:nxe-4) ) + ...
                               coef(4)*( U(8:nze, 4:nxe-4) - U(1:nze-7, 4:nxe-4) ) );
        Vx(4:nze-4, 4:nxe-4) = d1x(4:nze-4, 4:nxe-4).*Vx(4:nze-4, 4:nxe-4) + d11(4:nze-4, 4:nxe-4).*(...
                               coef(1)*( U(4:nze-4, 5:nxe-3) - U(4:nze-4, 4:nxe-4) ) +  ...
                               coef(2)*( U(4:nze-4, 6:nxe-2) - U(4:nze-4, 3:nxe-5) ) + ...
                               coef(3)*( U(4:nze-4, 7:nxe-1) - U(4:nze-4, 2:nxe-6) ) + ...
                               coef(4)*( U(4:nze-4, 8:nxe) - U(4:nze-4, 1:nxe-7) ) ); 
        Uz(5:nze-3, 5:nxe-3) = d2z(5:nze-3, 5:nxe-3).*Uz(5:nze-3, 5:nxe-3) + d22(5:nze-3, 5:nxe-3).*v(5:nze-3, 5:nxe-3).*(...
                               coef(1)*( Vz(5:nze-3, 5:nxe-3) - Vz(4:nze-4, 5:nxe-3) ) + ...
                               coef(2)*( Vz(6:nze-2, 5:nxe-3) - Vz(3:nze-5, 5:nxe-3) ) + ...
                               coef(3)*( Vz(7:nze-1, 5:nxe-3) - Vz(2:nze-6, 5:nxe-3) ) + ...
                               coef(4)*( Vz(8:nze, 5:nxe-3) - Vz(1:nze-7, 5:nxe-3) ) );
        Ux(5:nze-3, 5:nxe-3) = d1x(5:nze-3, 5:nxe-3).*Ux(5:nze-3, 5:nxe-3) + d11(5:nze-3, 5:nxe-3).*v(5:nze-3, 5:nxe-3).*( ...
                               coef(1)*( Vx(5:nze-3, 5:nxe-3) - Vx(5:nze-3, 4:nxe-4) ) + ...
                               coef(2)*( Vx(5:nze-3, 6:nxe-2) - Vx(5:nze-3, 3:nxe-5) ) + ...
                               coef(3)*( Vx(5:nze-3, 7:nxe-1) - Vx(5:nze-3, 2:nxe-6) ) + ...
                               coef(4)*( Vx(5:nze-3, 8:nxe) - Vx(5:nze-3, 1:nxe-7) ) );      
        U = Ux + Uz; 
                                 
        if mod(it, displayFreq)==1
            fprintf('%i\t', it);
            if(showImage)
                imagesc(U);colormap(gray), colorbar;drawnow;
            end
        end

        out(it,:) = U(g);
        if (writeWfd && ~isempty(wfdFile))
            output(wfdFile, U);
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