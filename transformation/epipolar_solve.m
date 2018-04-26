function [m, c, EPleft, EPright] = epipolar_solve(F, xcord, ycord)
    % Find epipolar line in I2 given fundamental matrix and point
    ELcoeff = F*[xcord ycord 1]';
    m = -ELcoeff(1)/ELcoeff(2);
    c = -ELcoeff(3)/ELcoeff(2);
end