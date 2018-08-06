function v2 = boundary_pad(v, bnd)
% pad the model with boundary ...
% 
%
%
v2 = [repmat(v(:,1),1,bnd),v,repmat(v(:,end),1,bnd)];
v2 = [repmat(v2(1,:),bnd,1);v2;repmat(v2(end,:),bnd,1)];

end