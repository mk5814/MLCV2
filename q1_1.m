clear
close all

%% Begin program

numPoints = 5;

im1 = imread('images/boat/img1.pgm');
im2 = imread('images/boat/img2.pgm');

figure(1);
imshow(im1);
figure(2);
imshow(im2);

im1pts = [];
im2pts = [];

for i = 1:numPoints
    figure(1);
    [x,y] = ginput(1);
    im1pts = [im1pts;[x,y]];
    
    figure(2);
    [x,y] = ginput(1);
    im2pts = [im2pts;[x,y]];
end
close all;

save('images/boat_img1','im1pts','im2pts');






