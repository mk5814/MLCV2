rng(312)
addpath('harris')
addpath('transformation')
vis = 0;
vis2 = 1;
vis3 = 0;

clearvars -except vis vis2 vis3
I1 = imread('images/tsukuba/scene1.row3.col1.ppm');
I2 = imread('images/tsukuba/scene1.row3.col2.ppm');
I1 = imread('images/rescaled/l1.jpg');
I2 = imread('images/rescaled/r1.jpg');

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
tic
%% Carry on
% Estimate Fundamental Accuracy
[F, inliers] = estimateFundamentalMatrix(MP1,...
    MP2,'Method','RANSAC',...
    'NumTrials',2000,'DistanceThreshold',1e-2);
% FA = fundamental_accuracy(F, MP1, MP2);
FA = fundamental_accuracy(F, MP1(inliers,:), MP2(inliers,:));
fprintf('FA using Inliers Only = %.5f\n',FA);
% Random test points in I1(taken from matched points)
% idx = randperm(size(MP1,1),10);
mp1 = MP1(inliers,:);
mp2 = MP2(inliers,:);
M1 = []; C1 = [];
M2 = []; C2 = [];
for i = 1:size(mp1,1)
    [m,c] = epipolar_solve(F,mp1(i,1),mp1(i,2));
    M1 = [M1; m];
    C1 = [C1; c];    
end
for i = 1:size(mp2,1)
    [m,c] = epipolar_solve(F',mp2(i,1),mp2(i,2));
    M2 = [M2; m];
    C2 = [C2; c];    
end

lines = epipolarLine(F',mp2);
lines = lines(:,[2,3,1]);
lines = -lines./lines(:,1);
lines = lines(:,2:3);

[EPleft,EPright] = epipole_solve(F);

[isin1, ~] = isEpipoleInImage(F,size(I1));
[isin2, ~] = isEpipoleInImage(F',size(I2));


%% Stereo Rectification
% % f= 4.42mm (29mm equivalent?)
% J2 = homography_transform(I2,H,'projective');
[I1,I2] = stereo_rect(I1,I2,F,MP1,MP2);
%% Compute Disparity of Images
dispMap = abs(disparity(I1,I2));
% Cap disparity between 0.0001 and a reasonable max
% dispMap(dispMap<0.0001) = 0.0001;
dispMap(dispMap>10000000) = 60;
%% Add or dont add noise here
% noise = 0.1*std(dispMap(:))*randn(size(dispMap));
% dispMap = dispMap +  noise;
% bestf = 0.34; bestb = 0.05; % For Tsukuba
bestf = 0.25; bestb = 0.15; %For OnePlus 5 Camera
f = bestf;
b = bestb;
% depthMap = depth_map(dispMap,f,b);
depthMap = f*b*ones(size(dispMap))./dispMap;
fprintf('Best f = %.2f, Best b = %.2f\n',bestf,bestb)

%% VISUALISATION OF RESULTS
if vis
    offset = size(I1,2);
    figure
    title('Epipolar Lines and Epipoles for Selected Points');      
    subplot(1,2,1)
    imshow(I1);
    hold on
    %scatter(mp1(:,1),mp1(:,2),'marker','o','MarkerFaceColor','y');    
    scatter(EPleft(:,1),EPleft(:,2),'marker','sq','MarkerFaceColor','r');    
    for i = 1:size(M1,1)
        draw_line(M1(i), C1(i), size(I1), 0,'g'); hold on;
    end
    if isin1
        legend('Epipoles','Epipolar Lines')
    else
        legend('Epipoles Out of Bounds','Epipolar Lines')
    end
    subplot(1,2,2)
    imshow(I2);
    hold on
    %scatter(mp2(:,1),mp2(:,2),'marker','o','MarkerFaceColor','y');    
    scatter(EPright(:,1),EPright(:,2),'marker','sq','MarkerFaceColor','r');    
    for i = 1:size(M2,1)
        draw_line(M2(i), C2(i), size(I2), 0,'g'); hold on;
    end
    if isin2
        legend('Epipoles','Epipolar Lines')
    else
        legend('Epipoles Out of Bounds','Epipolar Lines')
    end
    hold off        
end
if vis2
    % Disparity Map
    figure;
    dmsort = sort(dispMap(:));
    dmr = [min(dmsort),max(dmsort)];
    dmr = [0,80];
    imshow(dispMap,dmr);
    colormap(gca,parula);
    title('Disparity Map')
    % Depth Map
    dmsort = sort(depthMap(:));
    % Remove outliers when finding range of image
    dmsort = dmsort(1000:end-1000);
    dmr = [min(dmsort),max(dmsort)];
    dmr = [0.0006,0.003]; % For OnePlus5 images
    figure;
    imshow(depthMap,dmr);
    colormap(gca,parula)
    title('Reconstructed Depth Map');    
end
if vis3
    figure;
    imshow(horzcat(I1,I2));
    title('Stereo Rectified Pair')
end

toc





        