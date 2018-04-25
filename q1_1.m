clear
close all

%% Begin program

numPoints = 10;

im1 = imread('images/boat/img1.pgm');
im2 = imread('images/boat/img2.pgm');

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

save('images/boat_img1_2','MP1','MP2');






