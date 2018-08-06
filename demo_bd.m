
addpath('RTM');
addpath('RTM/stg_pml');
addpath('RTM/rg_hybrid');
addpath('kernel')
addpath('util')
addpath('filter')


nz = 300;
nx = 300;
v = 2000*ones(nz, nx);

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
sxz = [150, 150];

% reciever geometry
ng = nx;
gxz = ones(ng, 2);
gxz(:, 2) = 1:nx;

% record file
rcFile_stg = 'Data\Demo\rc_stg.bin';
rcFile_rg = 'Data\Demo\rc_rg.bin';

% test stg
figure(1)
record_stg = bin_read(rcFile_stg, [nt, ng], 'float32');
stg_bd(nz, nx, nt, dz, dx, dt, bnd, v, sxz, gxz, record_stg, 'show', 1, 'display', 10);

% test rg
figure(2)
record_rg = bin_read(rcFile_rg, [nt, ng], 'float32');
rg_bd(nz, nx, nt, dz, dx, dt, bnd, v, sxz, gxz, record_rg, 'show', 1, 'display', 10);