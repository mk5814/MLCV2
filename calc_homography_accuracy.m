function [HA, I1_points_projected]=calc_homography_accuracy(homography_matrix, I1_points, I2_points)
numpoints=size(I1_points,1);
HA=0;
I1_points_homo=[I1_points, ones(numpoints,1)];
I1_points_projected=zeros(numpoints,2);
for i=1: numpoints
temp=(homography_matrix*I1_points_homo(i,:)');
I1_points_projected(i,:)=temp(1:end-1)./temp(3);
distance=sqrt(sum((I1_points_projected(i,:)-I2_points(i,:)).^2));
HA=HA+distance;
end
HA=HA/numpoints;
End