function [m, c] = epipolar_solve(F, xcord, ycord, Imsz)
    % Find epipolar line in I2 given fundamental matrix
    ELcoeff = F*[xcord ycord 1]';
    m = -ELcoeff(1)/ELcoeff(2);
    c = -ELcoeff(3)/ELcoeff(2);
%     % Find epipoles, left and right null space of fundamental matrix
%     [U,~,D] = svd(F);
%     EPleft = U(:,end);
%     EPleft = EPleft/EPleft(end);
%     EPright = D(:,end);
%     EPright = EPright/EPright(end);
end