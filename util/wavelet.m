function y = wavelet(dt,nt,f,delay)
t = (0:nt-1)*dt;
t = t - delay;
tmp = pi*pi*f*f;
t2 = t.*t;
y = (1-2*tmp*t2).*exp(-tmp*t2);
y = y';
end