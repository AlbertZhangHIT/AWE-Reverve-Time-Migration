function [u] = add_source( u, source, sxz, adj)
% source injection ...
%  u        - current wavefield slice
%  sxz      - ns by 2 matrix of source location, with first and second colum the 
%             z-axis and x-axis respectively
%  ns       - number of sources
%  nz       - # of rows in model
%  add      - a bool for injection or extraction

ns = size(sxz, 1);
if adj == 1
    for is = 1:ns
        index = sxz(is);
        u(index) = u(index) - source(is);
    end
else
    for is = 1:ns
        index = sxz(is);
        u(index) = u(index) + source(is);
    end 
end

end
