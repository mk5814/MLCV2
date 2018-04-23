% q1_2;

homogMatrix = homography_solve(matchedPoints2', matchedPoints1');
I3 = homography_transform(I2,homogMatrix);

figure;
imshow(I1);
figure;
imshow(I2);
figure;
imshow(I3);