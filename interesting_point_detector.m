% function out = interesting_point_detector(img, ~, ~)

img = imread('images/boat/img1.pgm');
img = im2double(img);

[Ix, Iy] = gradient(img);
% [Ixx, Ixy] = gradient(Ix);
% [Ixy, Iyy] = gradient(Iy); %safe to assume Ixy = Iyx
 
A = [sum(sum(Ix.*Ix)), sum(sum(Ix.*Iy));
     sum(sum(Ix.*Iy)), sum(sum(Iy.*Iy))];   
% Noble's corner measure(harmonic mean of eigenvalues)
Mc = 2*det(A)/(trace(A)+eps);
Mc = Mc';
 
 
% end