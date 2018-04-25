clear
close all

%% Begin program
addpath('images/rescaled');
numPoints = 10;

% im1 = imread('images/rescaled/img1.pgm');
% im2 = imread('images/boat/img2.pgm');
im1 = rgb2gray(imread('00.jpg'));
im2 = rgb2gray(imread('11.jpg'));


figure(1);
imshow(im1);
figure(2);
imshow(im2);

MP1 = [];
MP2 = [];

for i = 1:numPoints
    figure(1);
    [x,y] = ginput(1);
    MP1 = [MP1;[x,y]];
    
    figure(2);
    [x,y] = ginput(1);
    MP2 = [MP2;[x,y]];
end
close all;

save('images/rescaled_00_11','MP1','MP2');






