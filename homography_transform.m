function [imOut] = homography_transform( I, H )
    t = maketform('projective', double(H'));
    imOut = imtransform(I,t);   
end