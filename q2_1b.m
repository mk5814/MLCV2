addpath('harris')
addpath('transformation')

vis = 1;
readnew = 1;

tic
if readnew
    I1 = imread('images/rescaled/00.jpg');
    I2 = imread('images/rescaled/11.jpg');
    if length(size(I1)) == 3
        I1 = rgb2gray(I1);
        I2 = rgb2gray(I2);
    end

    I1 = im2single(I1);
    I2 = im2single(I2);
    
    % Automatic Point of Interest Detector
    qual = 0.01;
    poi1 = myHarris(I1,qual);
    poi2 = myHarris(I2,qual);

    [f1, validpts1] = extractFeatures(I1, poi1);
    [f2, validpts2] = extractFeatures(I2, poi2);

    map12 = nnMatch(f1, f2, 0.6);
    mp12_1 = validpts1(map12(:,1),:);
    mp12_2 = validpts2(map12(:,2),:);    
end


ransacTh = 50;

%% DONT FORGET TO INCLUDE THIS NOTE IN THE REPORT
% NOTE: HA is only high in H12 because of a few outliers in the matched
% points which have a distance >300. The actual image(turn vis on) is
% actually a reasonably close match
[Hauto,inliers1] = homography_solveRANSAC(mp12_2, mp12_1, ransacTh);
[HAauto, ~] = homography_accuracy(Hauto, mp12_2(inliers1,:), mp12_1(inliers1,:));
fprintf('(Auto)HA = %.1f\n',HAauto)     

% Load Manual POI from q1_1.m
load images/rescaled_00_11.mat
[Hmanual,inliers2] = homography_solveRANSAC(MP2,MP1,ransacTh);
[HAmanual, ~] = homography_accuracy(Hmanual, MP2(inliers2,:), MP1(inliers2,:));
fprintf('(Manual)HA = %.1f\n',HAmanual)     

if vis
    figure;
    showMatchedFeatures(I1,I2,mp12_1(inliers1,:),mp12_2(inliers1,:),'montage');
    title('Matched Features(Automatic)');
    figure;
    showMatchedFeatures(I1,I2,MP1(inliers2,:),MP2(inliers2,:),'montage');
    title('Matched Features(Manual)');
    
    I22 = homography_transform(I2,Hauto,'projective');
    I222 = homography_transform(I2,Hmanual,'projective');

    figure;
    imshow(I1);
    title('Original Image')
    figure;
    imshow(I22);
    title('Transformed Image(automatic)')
    figure;
    imshow(I222);
    title('Transformed Image(manual)')
end

toc
