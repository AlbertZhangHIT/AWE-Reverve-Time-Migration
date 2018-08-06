function C = conv_matrix(dz, dx, o, s)
% generate convolution matrix...
%
%   o               - half precision of finite difference scheme   
%   s               - difference type indicator. ='s' indicates
%                     staggered-grid, and ='r' regular-grid. See func.
%                     Dcoef 
%
if nargin<4
    C = DCoef(o);
else
    C = DCoef(o,s);
end
C = [zeros(o),C(end:-1:1)/dz/dz,zeros(o);(C(end:-1:1))'/dx/dx,-2*sum(C)/dz/dz-2*sum(C)/dx/dx,C'/dx/dx;zeros(o),C/dz/dz,zeros(o)];


end