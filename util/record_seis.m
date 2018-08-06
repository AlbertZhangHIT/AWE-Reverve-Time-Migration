function [data] = record_seis( u, gxz, ng, bnd)
% record at geophones ...
%
%   gxz     - matrix profile of location of geophones, with first column
%             and second column the z-axis and x-axis respectively
%   ng      - # of geophones
data = zeros(1,ng);
for ig = 1:ng
    index = gxz(ig,:)+bnd;
    data(ig) = u(index(1),index(2));
end

end