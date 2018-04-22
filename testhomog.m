clear
tic
I1 = imread('images/boat/img1.pgm');
I2 = imread('images/boat/img2.pgm');

qual = 0.01;
method = 0;
[~, poi1, strength1] = harris_detector(I1, 1, qual, 5, method, 0);
[~, poi2, strength2] = harris_detector(I2, 1, qual, 5, method, 0);

[feat1, validpts1] = extractFeatures(I1, poi1, 'Method', 'Block');
[feat2, validpts2] = extractFeatures(I2, poi2, 'Method', 'Block');

hist1 = hist(double(feat1)', 255)';
hist2 = hist(double(feat2)', 255)';

map = nnMatch(hist1,hist2, 0.9);

matchedPoints1 = validpts1(map(:,1),:);
matchedPoints2 = validpts2(map(:,2),:);
figure;
showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2,'montage','Parent',axes);
% showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);
%% Using MATLAB inbuilt functions
% points1 = detectHarrisFeatures(I1);
% points2 = detectHarrisFeatures(I2);
% [f1, vpts1] = extractFeatures(I1, points1);
% [f2, vpts2] = extractFeatures(I2, points2);
% indexPairs = matchFeatures(f1, f2) ;
% matchedPoints1 = vpts1(indexPairs(1:20, 1));
% matchedPoints2 = vpts2(indexPairs(1:20, 2));
% figure; ax = axes;
% showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2,'montage','Parent',ax);

toc
