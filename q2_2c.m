% 4.42mm (29mm equivalent) FOCAL LENGTH
addpath('harris')
addpath('transformation')
vis = 1;

clearvars -except vis
I1 = imread('images/rescaled/0.jpg');
I2 = imread('images/rescaled/1.jpg');

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
% if vis
%     figure;
%     showMatchedFeatures(I1,I2,MP1,MP2);    
% end
tic
%% Map I1 to I2
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

disparityMap = disparity(I1,I2);
% z = f*b/d ---- b is distance between camera positions(20cm?)
% f= 4.42mm (29mm equivalent?)
f = 0.00442;
b = 0.2;
I1z = disparityMap.*(f/b);
J1 = zeros([size(I1),2]);
J1(:,:,1) = I1;
J1(:,:,2) = I1z;


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
    title('Epipolar Lines and Epipoles for Selected Points');  
    if isin1 || isin2
        legend('Inliers','Epipoles','Epipolar Lines')
    else
        legend('Inliers','Epipoles Out of Bounds','Epipolar Lines')
    end
    hold off    
    % Disparity Map
    figure;
    imshow(disparityMap);
end

toc





        