function [u3,delX] = step_fd(u1, u2, v2, nzpad, nxpad, bnd, dz, dx, dt, C, adj)
% forward stepping
%   u2,u1   - last two wavefield slices
%   vt2     - square of product of velcocity and time interval
%   C       - differential coefficients
%   adj     - adjoint indicator, =1 indicates adjoint, =0 forward

bool_abs = 1;

nz = nzpad - 2*bnd;
nx = nxpad - 2*bnd;

w = zeros(1,bnd);
for i = 1:bnd
    w(i) = 1.0 - i/bnd;
end
w2d = [repmat(w(end:-1:1),nz,1), ones(nz,nx), repmat(w,nz,1)];
w2d = [repmat(w(end:-1:1)',1,nxpad); w2d ; repmat(w',1,nxpad)];
vt2 = v2.*v2*dt*dt;
u31 = zeros(nzpad, nxpad);

if(adj)
    delX = imfilter(vt2.*u2, C);
    u3   = 2*u2 - u1 + delX;
else
    delX  = vt2.*imfilter(u2, C);
    u3   = 2*u2 - u1 + delX;
end
if (bool_abs)
for IK = 1:bnd
    
    % up
    K =  bnd+1-IK;
    b1 = 1;
    b2 = nxpad;
    for ix =b1:b2
         HH = v2(K,ix)*dt/dz;
         H1 = 0.5*(2 - HH) *(1-HH);
         H2 = ( 2 - HH) * HH;
         H3 = 0.5 * HH * ( HH -1);
         H_0 = 2 * H1;
         H_1 = 2 * H2;
         H_2 = 2 * H3;
         H_3 = -( H1 * H1 );
         H_4 = -( H1 * H2 + H2 * H1 );
         H_5 = -( H1 * H3 + H2 * H2 + H3 * H1 );
         H_6 = -( H2 * H3 + H3 * H2 );
         H_7 = -( H3 * H3 );
         tmp = H_0 * u2(K,ix) + H_1 * u2(K+1,ix) + H_2 * u2(K+2,ix) + ...
                H_3 * u1(K,ix) + H_4 * u1(K+1,ix) + H_5 * u1(K+2,ix) + ...
                H_6 * u1(K+3,ix) + H_7 * u1(K+4,ix);
         u31(K,ix) = tmp;
    end
     % left
     K = bnd+1 - IK;
     b1 = 1;
     b2 = nzpad;
      for iz = b1:b2    
         HH = v2(iz,K)*dt/dx;
         H1 = 0.5*(2 - HH) *(1-HH);
         H2 = ( 2 - HH) * HH;
         H3 = 0.5 * HH * ( HH -1);
         H_0 = 2 * H1;
         H_1 = 2 * H2;
         H_2 = 2 * H3;
         H_3 = -( H1 * H1 );
         H_4 = -( H1 * H2 + H2 * H1 );
         H_5 = -( H1 * H3 + H2 * H2 + H3 * H1 );
         H_6 = -( H2 * H3 + H3 * H2 );
         H_7 = -( H3 * H3 );
         tmp = H_0 * u2(iz,K) + H_1 * u2(iz,K+1) + H_2 * u2(iz,K+2) + ...
                H_3 * u1(iz,K) + H_4 * u1(iz,K+1) + H_5 * u1(iz,K+2) + ...
                H_6 * u1(iz,K+3) + H_7 * u1(iz,K+4);
          u31(iz,K) = tmp;
      end
    % down
    K = nz + IK+bnd;
    b1 = 1;
    b2 = nxpad;
     for ix =b1:b2
           HH = v2(K,ix)*dt/dz;
         H1 = 0.5*(2 - HH) *(1-HH);
         H2 = ( 2 - HH) * HH;
         H3 = 0.5 * HH * ( HH -1);
         H_0 = 2 * H1;
         H_1 = 2 * H2;
         H_2 = 2 * H3;
         H_3 = -( H1 * H1 );
         H_4 = -( H1 * H2 + H2 * H1 );
         H_5 = -( H1 * H3 + H2 * H2 + H3 * H1 );
         H_6 = -( H2 * H3 + H3 * H2 );
         H_7 = -( H3 * H3 );
         tmp = H_0 * u2(K,ix) + H_1 * u2(K-1,ix) + H_2 * u2(K-2,ix) + ...
                H_3 * u1(K,ix) + H_4 * u1(K-1,ix) + H_5 * u1(K-2,ix) + ...
                H_6 * u1(K-3,ix) + H_7 * u1(K-4,ix);
         u31(K,ix) = tmp;
     end
     % right 
     K = nx + IK+bnd;
     b1 = 1;
     b2 = nzpad;
     for iz = b1:b2    
          HH = v2(iz,K)*dt/dx;
         H1 = 0.5*(2 - HH) *(1-HH);
         H2 = ( 2 - HH) * HH;
         H3 = 0.5 * HH * ( HH -1);
         H_0 = 2 * H1;
         H_1 = 2 * H2;
         H_2 = 2 * H3;
         H_3 = -( H1 * H1 );
         H_4 = -( H1 * H2 + H2 * H1 );
         H_5 = -( H1 * H3 + H2 * H2 + H3 * H1 );
         H_6 = -( H2 * H3 + H3 * H2 );
         H_7 = -( H3 * H3 );
         tmp = H_0 * u2(iz,K) + H_1 * u2(iz,K-1) + H_2 * u2(iz,K-2) + ...
                H_3 * u1(iz,K) + H_4 * u1(iz,K-1) + H_5 * u1(iz,K-2) + ...
                H_6 * u1(iz,K-3) + H_7 * u1(iz,K-4);
          u31(iz,K) = tmp;
     end
     % downright corner
      zk = nz + bnd+IK;
      xk = nx + bnd+IK;
      zc = [zk,zk-1,zk];
      xc = [xk-1,xk,xk];
      for ik = 3:3
          zc0=zc(ik);
          xc0=xc(ik);
          ax1 = 1/dz;
          ax2 = 1/dx;
          ax3 = sqrt(2)/v2(zc0,xc0)/dt;
          tmp = -ax1*u3(zc0-1,xc0) - ax2*u3(zc0,xc0-1)+ax3*(-u2(zc0,xc0));
          u31(zc0,xc0) = -tmp/(ax1+ax2+ax3);
      end
     % downleft corner
      zk = nz + bnd+IK;
      xk = 1  + bnd-IK;
      zc = [zk,zk-1,zk];
      xc = [xk+1,xk,xk];
      for ik = 3:3
          zc0=zc(ik);
          xc0=xc(ik);
          ax1 = 1/dz;
          ax2 = 1/dx;
          ax3 = sqrt(2)/v2(zc0,xc0)/dt;
          tmp = -ax1*u3(zc0-1,xc0) - ax2*u3(zc0,xc0+1)+ax3*(-u2(zc0,xc0));
          u31(zc0,xc0) = -tmp/(ax1+ax2+ax3);
      end
       % upright corner
      zk = 1 + bnd-IK;
      xk = nx + bnd+IK;
      zc = [zk,zk+1,zk];
      xc = [xk-1,xk,xk];
      for ik = 3:3
          zc0=zc(ik);
          xc0=xc(ik);
          ax1 = 1/dz;
          ax2 = 1/dx;
          ax3 = sqrt(2)/v2(zc0,xc0)/dt;
          tmp = -ax1*u3(zc0+1,xc0) - ax2*u3(zc0,xc0-1)+ax3*(-u2(zc0,xc0));
          u31(zc0,xc0) = -tmp/(ax1+ax2+ax3);
      end
     % upleft corner
      zk = 1  + bnd-IK;
      xk = 1  + bnd-IK;
      zc = [zk,zk+1,zk];
      xc = [xk+1,xk,xk];
      for ik = 3:3
          zc0=zc(ik);
          xc0=xc(ik);
          ax1 = 1/dz;
          ax2 = 1/dx;
          ax3 = sqrt(2)/v2(zc0,xc0)/dt;
          tmp = -ax1*u3(zc0+1,xc0) - ax2*u3(zc0,xc0+1)+ax3*(-u2(zc0,xc0));
          u31(zc0,xc0) = -tmp/(ax1+ax2+ax3);
      end
end
end
u3 = u3.*w2d + u31.*(1-w2d);

end