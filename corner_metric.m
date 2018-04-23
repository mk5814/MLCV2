% Compute corner metric matrix
function metric = corner_metric(I, filter2D)
% Compute gradients
A = imfilter(I,[-1 0 1] ,'replicate','same','conv');
B = imfilter(I,[-1 0 1]','replicate','same','conv');

% Crop the valid gradients
A = A(2:end-1,2:end-1);
B = B(2:end-1,2:end-1);

% Compute A, B, and C, which will be used to compute corner metric.
C = A .* B;
A = A .* A;
B = B .* B;

% Filter A, B, and C.
A = imfilter(A,filter2D,'replicate','full','conv');
B = imfilter(B,filter2D,'replicate','full','conv');
C = imfilter(C,filter2D,'replicate','full','conv');

% Clip to image size
removed = max(0, (size(filter2D,1)-1) / 2 - 1);
A = A(removed+1:end-removed,removed+1:end-removed);
B = B(removed+1:end-removed,removed+1:end-removed);
C = C(removed+1:end-removed,removed+1:end-removed);

% The parameter k which was defined in the Harris method is set to 0.04
k = 0.04; 
metric = (A .* B) - (C .^ 2) - k * ( A + B ) .^ 2;
