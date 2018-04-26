function [EPleft, EPright] = epipole_solve(F)
    [U,~,V] = svd(F);
    EPleft = U(:,end)';
    EPleft = EPleft/EPleft(end);
    EPright = V(:,end)';
    EPright = EPright/EPright(end);
end