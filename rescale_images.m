inpath = 'images/own';
outpath = 'images/rescaled';

addpath(inpath);

I = imread('orig.jpg');
I = imresize(I, 0.35);
imwrite(I,'images/rescaled/0.jpg');

I = imread('shift1.jpg');
I = imresize(I, 0.35);
imwrite(I,'images/rescaled/1.jpg');

I = imread('shift2.jpg');
I = imresize(I, 0.35);
imwrite(I,'images/rescaled/2.jpg');

I = imread('origrot.jpg');
I = imresize(I, 0.35);
imwrite(I,'images/rescaled/00.jpg');

I = imread('rot1.jpg');
I = imresize(I, 0.35);
imwrite(I,'images/rescaled/11.jpg');

I = imread('rot2.jpg');
I = imresize(I, 0.35);
imwrite(I,'images/rescaled/22.jpg');