
addpath('RTM');
addpath('RTM/stg_pml');
addpath('RTM/rg_hybrid');
addpath('kernel')
addpath('util')
addpath('filter')


nz = 300;
nx = 300;
vp = 2000;
v = vp*ones(nz, nx);
v(200:end, :) = vp*1.3;
v(55:64, 70:73) = vp*1.4;
v(90:95, 162:170) = vp*1.6;

dz = 10;
dx = 10;
dt = 1e-3;
bnd = 20;
nt = 1501;
t = (0:nt-1)*dt;
x = (0:nx-1)*dx;
z = (0:nz-1)*dz;

% source wavelet
delay = 0.1;
fdom = 20;
wlt = wavelet(dt, nt, fdom, delay);

% source geometry
sxz = [2, 150];

% reciever geometry
ng = nx;
gxz = ones(ng, 2);
gxz(:, 2) = 1:nx;

% record file
rcFile_stg = 'Data\Demo\rc_stg.bin';
rcFile_rg = 'Data\Demo\rc_rg.bin';

% test stg
figure(1)
record_stg = stg_fd(nz, nx, nt, dz, dx, dt, bnd, v, wlt, sxz, gxz, 'show', 1, 'display', 10, 'recordfile', rcFile_stg, 'freesurf', 0);

% test rg
figure(2)
record_rg = rg_fd(nz, nx, nt, dz, dx, dt, bnd, v, wlt, sxz, gxz, 'show', 1, 'display', 10, 'recordfile', rcFile_rg);

figure(3)
subplot(121)
imagesc(record_stg), colormap(gray), colorbar;
subplot(122)
imagesc(record_rg), colormap(gray), colorbar;

% muting direct wave
record_stg = gatherMute(record_stg, v, dx, dt, wlt, sxz, gxz);
record_rg = gatherMute(record_rg, v, dx, dt, wlt, sxz, gxz);
figure(4)
subplot(121)
imagesc(record_stg), colormap(gray), colorbar;
subplot(122)
imagesc(record_rg), colormap(gray), colorbar;
