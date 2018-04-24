function [imOut] = homography_transform( I, H , mode)
    t = maketform(mode, double(H'));
    imOut = imtransform(I,t);   
end