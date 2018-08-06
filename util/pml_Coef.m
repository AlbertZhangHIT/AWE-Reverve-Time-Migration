function [d1, d2] = pml_Coef(nz, nx, dz, dx, npml, v)


ne = npml;
if npml <= 5
    R = 1e-2;
elseif npml <= 10
    R = 1e-3;
elseif npml <= 20
    R = 1e-4;
elseif npml <= 30
    R = 1e-5;
else 
    R = 1e-7;
end

tau = 3;
vmax = max(v(:));
index = 1:ne;

% d1x = -tau*log(R)*vmax/(ne*dx)*(index/ne).^2;
% d2z = -tau*log(R)*vmax/(ne*dz)*(index/ne).^2;

L = ne*max(dx,dz);
d0 = -tau*log(R)*vmax/(2*L^3);

d1x = d0*(index*dx).^2;
d2z = d0*(index*dz).^2;

d1 = zeros(nz+2*ne, nx);
d1 = [repmat(flip(d2z),[nz+2*ne,1]), d1 , repmat(d2z, [nz+2*ne,1])];
d2 = zeros(nz, nx+2*ne);
d2 = [repmat( flip(d1x'),[1,nx+2*ne]); d2; repmat(d1x', [1, nx+2*ne])];


end
