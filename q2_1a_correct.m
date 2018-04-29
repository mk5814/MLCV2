addpath('harris')
addpath('transformation')

vis = 0;
readnew = 1;

tic
for scale = [1,1/2,1/3]
    if readnew
    %     I1 = imread('images/boat/img1.pgm');
    %     I1 = imread('images/rescaled/00.jpg');
        I1 = imread('images/own/origrot.jpg');
        I2 = imread('images/own/rot2.jpg');
        I1 = imresize(I1,scale);
        I2 = imresize(I2,scale);
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
    end


    ransacTh = 50;

    % NOTE: HA is only high in H12 because of a few outliers in the matched
    % points which have a distance >300. The actual image(turn vis on) is
    % actually a reasonably close match
    [H,inliers1] = homography_solveRANSAC(MP2, MP1, ransacTh);
    [HA, ~] = homography_accuracy(H, MP2(inliers1,:), MP1(inliers1,:));
    fprintf('[scale=%.2f]HA = %.1f\n',scale,HA)   

    if vis
        figure;
        showMatchedFeatures(I1,I2,MP1(inliers1,:),MP2(inliers1,:));
        I22 = homography_transform(I2,H,'projective');
        figure;
        imshow(I1);
        figure;
        imshow(I22);
    end             
end
toc
