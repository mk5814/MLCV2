function [I1Rect,I2Rect] = stereo_rect(I1,I2,F,MP1,MP2)
    [t1, t2] = estimateUncalibratedRectification(F, MP1, MP2, size(I2));
    tform1 = projective2d(t1);
    tform2 = projective2d(t2);
    [I1Rect, I2Rect] = rectifyStereoImages(I1, I2, tform1, tform2);
end