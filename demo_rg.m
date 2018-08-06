clc
clear

addpath('RTM');
addpath('RTM/rg_hybrid');
addpath('kernel')
addpath('util')
addpath('filter')
 
load BPsmall4.mat

nx = size(BPsmall, 2);

BPsmall = [BPsmall(1,floor(nx/2))*ones(3, nx); BPsmall];
[nz, nx] = size(BPsmall);

dz = 10;
dx = 10;
dt = 1e-3;
bnd = 20;
nt = 2501;
t = (0:nt-1)*dt;
x = (0:nx-1)*dx;
z = (0:nz-1)*dz;

% source wavelet
delay = 0.1;
fdom = 20;
wlt = wavelet(dt, nt, fdom, delay);

% source geometry
ns = 10;
sxz = ones(ns, 2);
sxz(:, 2) = ceil(linspace(1, nx, ns))';

% reciever geometry
ng = nx;
gxz = ones(ng, 2);
gxz(:, 2) = 1:nx;
% constant velocity
vc = BPsmall(1, floor(nx/2))*ones(nz, nx);

% forward modeling
fdFolder = 'Data\BPsmall4\rgFD_nt_2501_bnd_20\';
Records = awe_rg_fm2d(nz, nx, nt, dz, dx, dt, bnd, BPsmall, wlt, sxz, gxz, 'display', 500, ...
        'wfddir', fdFolder, 'show', 1);
% modeling direct wave
DirectWave = awe_rg_fm2d(nz, nx, nt, dz, dz, dt, bnd, vc, wlt, sxz, gxz, 'display', 500);
% muting direct wave
Records = Records - DirectWave;
% show
figure, imagesc(Records), colormap(gray); colorbar;
title('Seismic signals')

% write out records
writeRecords(nt, gxz, sxz, Records, fdFolder);
% processing on seismic records


% reverse time migration
[rfl, image, normal] = awe_rg_rtm2d(nz, nx, nt, dz, dx, dt, bnd, BPsmall, sxz, gxz, fdFolder, 'display', 500, ...
        'records', Records, 'show', 1);

% show
figure, imagesc(x, z, rfl); colormap(gray), colorbar;
% sharpen
hrfl = Gaussian_highpass(rfl, 60, 'show', 1);
figure, imagesc(x, z, hrfl); colormap(gray), colorbar;