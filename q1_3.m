clc
if ~exist('matchedPoints1')
    clear
    q1_2;
end

mode = 2;

if mode == 1
    H = homography_solve(matchedPoints2', matchedPoints1');
    [HA, I2proj] = homography_accuracy(H, matchedPoints2, matchedPoints1);
    fprintf('HA = %.1f\n',HA)

    I3 = homography_transform(I2,H,'projective');
    figure;
    imshow(I1);
    figure;
    imshow(I2);
    figure;
    imshow(I3);
elseif mode == 2
%     [F, inliers] = estimateFundamentalMatrix(matchedPoints1, matchedPoints2);
    [F, inliers] = estimateFundamentalMatrix(matchedPoints1,...
        matchedPoints2,'Method','RANSAC',...
        'NumTrials',2000,'DistanceThreshold',1e-4);

    % Random test points in I1   
    ycord = round(size(I1,1)*rand(10,1));
    xcord = round(size(I1,2)*rand(10,1));
    M = []; C = [];
    tic
    for i = 1:size(xcord,1)
        [m,c] = epipolar_solve(F,xcord(i),ycord(i),size(I2));
        M = [M; m];
        C = [C; c];
    end
    toc
    figure(2)
    I3 = horzcat(I1,I2);
    imshow(I3);
    hold on
    scatter(xcord,ycord,'marker','O','MarkerEdgeColor','yellow'); 
    for i = 1:size(M,1)
        draw_line(M(i), C(i), size(I2), size(I1,2)); hold on;        
    end
    title('x-epipole, o-selected point');
    hold off    
end
        