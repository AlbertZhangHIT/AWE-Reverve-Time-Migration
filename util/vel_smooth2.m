function velocity_smooth = vel_smooth2( velocity,smooth_num )
%Function SmoothVelocity2 is a convolutional smoothing operator:
%   v(i,j) = 0.25*(1-w)*( v(i-1,j) + v(i+1,j) + v(i,j-1) + v(i,j+1) ) + w*v(i,j) 
w = 0.5;
velocity_n = velocity;
for smooth_i = 1:smooth_num
    velocity_np1 = 0.25*( 1 - w )*( velocity_n([1 1:end-1],:) + velocity_n([2:end end],:) + ...
                  + velocity_n(:,[1 1:end-1]) + velocity_n(:,[2:end end]) ) + w*velocity_n;
    velocity_n = velocity_np1;
end
velocity_smooth = velocity_n;

end

