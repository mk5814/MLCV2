clear
img = imread('images/boat/img1.pgm');

tic
[corn, poi, strength] = harris_detector(img, 1, 150/255, 10, 1);
toc
