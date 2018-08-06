function velocity_smooth = vel_smooth1( velocity,smooth_num )
%Note :Function SmoothVelocity1 is a three-point average smoothing operator  
velocity_n = velocity;
for smooth_i = 1:smooth_num
    velocity_np1 = 0.25*( velocity_n([1 1:end-1],:) + velocity_n([2:end end],:) + ...
                  + velocity_n(:,[1 1:end-1]) + velocity_n(:,[2:end end]) ) + velocity_n;
    velocity_n = velocity_np1;
end
velocity_smooth = velocity_n;

end

