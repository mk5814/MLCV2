function metric = corner_metric(I, filter2D)
% Compute gradients
Ix = imfilter(I,[-1 0 1] ,'replicate','same','conv');
Iy = imfilter(I,[-1 0 1]','replicate','same','conv');

% Crop to valid range
Ix = Ix(2:end-1,2:end-1);
Iy = Iy(2:end-1,2:end-1);

% Compute Ix^2, Iy^2 and Ix*Iy for use in corner metric calculation
Ixy = Ix .* Iy;
Ix2 = Ix .* Ix;
Iy2 = Iy .* Iy;

% Filter with gaussian kernel
Ix2 = imfilter(Ix2,filter2D,'replicate','full','conv');
Iy2 = imfilter(Iy2,filter2D,'replicate','full','conv');
Ixy = imfilter(Ixy,filter2D,'replicate','full','conv');

% Clip to image size
cropwidth = max(0, (size(filter2D,1)-1) / 2 - 1);
Ix2 = Ix2(cropwidth+1:end-cropwidth,cropwidth+1:end-cropwidth);
Iy2 = Iy2(cropwidth+1:end-cropwidth,cropwidth+1:end-cropwidth);
Ixy = Ixy(cropwidth+1:end-cropwidth,cropwidth+1:end-cropwidth);

% k=0.04 typically works well in practice
k = 0.04; 
metric = (Ix2 .* Iy2) - (Ixy .^ 2) - k * ( Ix2 + Iy2 ) .^ 2;
