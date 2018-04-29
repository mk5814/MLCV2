addpath('harris')
addpath('transformation')

vis = 1;
readnew = 1;

tic
if readnew
%     I1 = imread('images/boat/img1.pgm');
%     I1 = imread('images/rescaled/00.jpg');
    I1 = imread('images/own/orig.jpg');
    I2 = imresize(I1,0.5);
    I3 = imresize(I1,1/3);
    if length(size(I1)) == 3
        I1 = rgb2gray(I1);
        I2 = rgb2gray(I2);
        I3 = rgb2gray(I3);
    end

    I1 = im2single(I1);
    I2 = im2single(I2);
    I3 = im2single(I3);

    qual = 0.01;
    poi1 = myHarris(I1,qual);
    poi2 = myHarris(I2,qual);
    poi3 = myHarris(I3,qual);

    [f1, validpts1] = extractFeatures(I1, poi1);
    [f2, validpts2] = extractFeatures(I2, poi2);
    [f3, validpts3] = extractFeatures(I2, poi3);

    map12 = nnMatch(f1, f2, 0.6);
    mp12_1 = validpts1(map12(:,1),:);
    mp12_2 = validpts2(map12(:,2),:);

    map13 = nnMatch(f1, f3, 0.6);
    mp13_1 = validpts1(map13(:,1),:);
    mp13_3 = validpts3(map13(:,2),:);
end


ransacTh = 50;

% NOTE: HA is only high in H12 because of a few outliers in the matched
% points which have a distance >300. The actual image(turn vis on) is
% actually a reasonably close match
[H12,inliers1] = homography_solveRANSAC(mp12_2, mp12_1, ransacTh);
[HA, ~] = homography_accuracy(H12, mp12_2(inliers1,:), mp12_1(inliers1,:));
fprintf('HA = %.1f\n',HA)   

[H13,inliers2] = homography_solveRANSAC(mp13_3, mp13_1, ransacTh);
[HA, ~] = homography_accuracy(H13, mp13_3(inliers2,:), mp13_1(inliers2,:));
fprintf('HA = %.1f\n',HA)   


if vis
    figure;
    showMatchedFeatures(I1,I2,mp12_1(inliers1,:),mp12_2(inliers1,:));
    figure;
    showMatchedFeatures(I1,I3,mp13_1(inliers2,:),mp13_3(inliers2,:));
    I22 = homography_transform(I2,H12,'projective');
    I33 = homography_transform(I3,H13,'projective');
    figure;
    imshow(I1);
    figure;
    imshow(I22);
    figure;
    imshow(I33);
end

toc
