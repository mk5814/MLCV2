function v = homography_solve(matchedPoints1, matchedPoints2)

n = size(matchedPoints1, 2);
% Solve equations using SVD
x = matchedPoints2(1,:); 
y = matchedPoints2(2,:); 
X = matchedPoints1(1,:); 
Y = matchedPoints1(2,:);

rows0 = zeros(3, n);
rowsXY = -[X; Y; ones(1,n)];

hx = [rowsXY; rows0; x.*X; x.*Y; x];
hy = [rows0; rowsXY; y.*X; y.*Y; y];
h = [hx hy];

[U, ~, ~] = svd(h, 'econ');

v = (reshape(U(:,9), 3, 3)).';
end