clc
if ~exist('matchedPoints1')
    q1_2;
end

H = homography_solve(matchedPoints2', matchedPoints1');
[HA, I2proj] = homography_accuracy(H, matchedPoints2, matchedPoints1);


I3 = homography_transform(I2,H);
figure;
imshow(I1);
figure;
imshow(I2);
figure;
imshow(I3);

% [F, inliers] = estimateFundamentalMatrix(matchedPoints1, matchedPoints2);
% %Calculate Epipolar Line
% figure
% imshow(I1,[])
% hold all
% plot(matchedPoints1(inliers,1),matchedPoints1(inliers,2),'go')
% epiLines = epipolarLine(F',matchedPoints2(inliers,:));
% points = lineToBorderPoints(epiLines,size(I1));
% line(points(:,[1,3])',points(:,[2,4])');
% title('Epipolar Lines and Matched Points')