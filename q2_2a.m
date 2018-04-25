addpath('harris')
addpath('transformation')
vis = 0;
if ~exist('MP1')
    clearvars -except vis
    I1 = imread('images/tsukuba/scene1.row3.col1.ppm');
    I2 = imread('images/tsukuba/scene1.row3.col2.ppm');

    if length(size(I1)) == 3
        I1 = rgb2gray(I1);
        I2 = rgb2gray(I2);
    end

    I1 = im2single(I1);
    I2 = im2single(I2);

    qual = 0.01;
    poi1 = myHarris(I1,qual);
    poi2 = myHarris(I2,qual);

    [f1, validpts1] = extractFeatures(I1, poi1);
    [f2, validpts2] = extractFeatures(I2, poi2);

    map = nnMatch(f1, f2, 0.6);

    MP1 = validpts1(map(:,1),:);
    MP2 = validpts2(map(:,2),:);
    if vis
        figure;
        showMatchedFeatures(I1,I2,MP1,MP2);    
    end
end
tic
% Estimate Fundamental Accuracy
[F, inliers] = estimateFundamentalMatrix(MP1,...
    MP2,'Method','RANSAC',...
    'NumTrials',2000,'DistanceThreshold',1e-2);
FA = fundamental_accuracy(F, MP1, MP2);
fprintf('Fundamental Accuracy = %.3f\n',FA);

% Random test points in I1   
ycord = round(size(I1,1)*rand(10,1));
xcord = round(size(I1,2)*rand(10,1));
M = []; C = [];
for i = 1:size(xcord,1)
    [m,c] = epipolar_solve(F,xcord(i),ycord(i));
    M = [M; m];
    C = [C; c];
end
if vis
    figure
    I3 = horzcat(I1,I2);
    imshow(I3);
    hold on
    scatter(xcord,ycord,'marker','O','MarkerEdgeColor','yellow'); 
    for i = 1:size(M,1)
        draw_line(M(i), C(i), size(I2), size(I1,2)); hold on;        
    end
    title('o-selected point, -- epipolar line');
    hold off    
end


toc





        