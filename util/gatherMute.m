function d = gatherMute(record, velocity, dx, dt, wlt, sxz, gxz)
% Input
% record    raw seimogram
% velocity  velocity model
% dz        vertical sample grid interval
% dx        horizontal sample grid interval
% dt        time sample space
% wlt       source wavelet 
% sxz       source location
% OUTPUT
% d         muted gather
sz = sxz(1);
sx = sxz(2);
ng = length(gxz(:, 2));
v = velocity(sz, :); % horizontal velocity
t = cumsum(dx./v);
travelTime = abs(t - t(sx));
% the duration of wavelet
w = cumsum(wlt);
maxInd = find(w == max(w));
endInd = find(diff(w(maxInd:end)) == 0) + maxInd;
durt = endInd(1);

d = record;
for ig = 1 : ng
    index = 1:fix(travelTime(ig)/dt + durt);
    d(index, ig) = 0;
end

return