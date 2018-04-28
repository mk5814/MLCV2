addpath('harris')
addpath('transformation')
vis = 1;
vis2 = 1;

clearvars -except vis vis2
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
%% Map I1 to I2
H1 = homography_solveRANSAC(MP2, MP1, 5);
[HA, ~] = homography_accuracy(H1, MP2, MP1);
fprintf('(Auto)HA = %.1f\n',HA)  
H2 = homography_solveRANSAC(MP1, MP2, 5);
[HA, ~] = homography_accuracy(H2, MP1, MP2);
fprintf('(Auto)HA = %.1f\n',HA)  
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
%% Compute Disparity of Images
dispMap = (disparity(I1,I2));
%% Compare to ground truth
% GTdepth = im2single(imread('images/tsukuba/truedisp.row3.col3.pgm'));
% bb = linspace(0.05,0.2,10);
% ff = linspace(0.01,1,100);
% minerr = inf;
% for b = bb
%     for f = ff
%         dm = depth_map(dispMap,f,b);
%         % err = mse(dm,GTdepth);
%         err = abs(max(max(dm(50:end-50,50:end-50))-max(GTdepth(50:end-50,50:end-50))));
%         if err < minerr
%             minerr = err;
%             best = dm;
%             bestf = f;
%             bestb = b;
%             % fprintf('New best (f,b) = (%.2f,%.2f)\n',f,b)
%         end
%     end
% end
% bestf = 0.34; bestb = 0.05; % For Tsukuba
bestf = 0.4; bestb = 0.1; %For OnePlus 5 Camera
f = bestf;
b = bestb;
depthMap = depth_map(dispMap,f,b);
fprintf('Best f = %.2f, Best b = %.2f\n',bestf,bestb)
%% VISUALISATION OF RESULTS
if vis
    offset = size(I1,2);
    figure
    I3 = horzcat(I1,I2);
    imshow(I3);
    hold on
    pts = [mp1; mp2+[offset,0]];
    scatter(pts(:,1),pts(:,2),'marker','o','MarkerFaceColor','y');    
    EP = [EPleft+[offset,0,0]; EPright];
    scatter(EP(:,1),EP(:,2),'marker','sq','MarkerFaceColor','r');    
    for i = 1:size(M1,1)
        draw_line(M1(i), C1(i), size(I2), size(I1,2),'g'); hold on;
    end
    for i = 1:size(M2,1)
        draw_line(M2(i), C2(i), size(I1), 0,'g'); hold on;
    end        
    scatter(EP(:,1),EP(:,2),'marker','sq','MarkerFaceColor','r');  
    title('Epipolar Lines and Epipoles for Selected Points');  
    if isin1 || isin2
        legend('Inliers','Epipoles','Epipolar Lines')
    else
        legend('Inliers','Epipoles Out of Bounds','Epipolar Lines')
    end
    hold off        
end
if vis2
    % Disparity Map
%     figure;
%     imshow(dispMap);
    % Depth Map
    dmsort = sort(depthMap(:));
    % Remove outliers when finding range of image
    dmsort = dmsort(1000:end-1000);
    dmr = [min(dmsort),max(dmsort)];
    dmr = [0,0.3]; % For OnePlus5 images
    figure;
    imshow(depthMap,dmr);
    colormap(gca,jet)
    title('Reconstructed Depth Map');
end

toc





        