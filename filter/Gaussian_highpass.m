function y = Gaussian_highpass(I, radius, varargin)
showImage = 0;
%Parse the optional inputs.
if (mod(length(varargin), 2) ~= 0 )
    error(['Extra Parameters passed to the function ''' mfilename ''' lambdast be passed in pairs.']);
end
parameterCount = length(varargin)/2;
for parameterIndex = 1:parameterCount
    parameterName = varargin{parameterIndex*2 - 1};
    parameterValue = varargin{parameterIndex*2};
    switch lower(parameterName)
        case 'show'
            showImage = parameterValue;
        otherwise
            error(['The parameter ''' parameterName ''' is not recognized by the function ''' mfilename '''.']);  
    end
end

[m, n] = size(I);
centerx = m/2;
centery = n/2;
H = zeros(m, n);
for x = 1 : m
    for y = 1 : n
        H(x, y) = exp( - ((x-centerx)^2 + (y-centery)^2)/(2*radius^2) );
    end
end

H = 1 - H;

spI = fft2(I);
spI = fftshift(spI);

g1 = H.*spI;
g2 = g1 + spI;

g3 = ifftshift(g2);
y = real(ifft2(g3));

if(showImage)
    figure, imshow([H, log(1+abs(spI))], []);
end