% Witch RANSAC
function [H,inlierLocations] = homography_solveRANSAC(mp1, mp2, ransacTh)
    
    numTrials = 2000;
    inliers = cell(1,numTrials);
    for i = 1:numTrials    
        K = 4;
        idx = randperm(size(mp1,1),K);
        mp11 = mp1(idx,:);
        mp22 = mp2(idx,:);
        % Compute Homography
        H = homog_solve(mp11',mp22');               
        
        %Compute Inliers
        mP1 = [mp1, ones(size(mp1,1),1)];
        newpts = (H*(mP1'))';

        newpts = newpts(:,1:2)./repmat(newpts(:,3),1,2);
        dist = sum((mp2-newpts).^2,2);
        inliers_ = find(dist < ransacTh);
        numInliers(i) = length(inliers_);
        inliers{i} = inliers_;
    end
    idx = find(numInliers == max(numInliers),1);
    inlierLocations = inliers{idx};
    mp11 = mp1(inlierLocations,:);
    mp22 = mp2(inlierLocations,:);
    
    if size(mp11,1) < 4
        % If none of the random samples reached a valid consensus then just
        % use the full set of matched points. Results will definitely be
        % bad but it avoids the error message interrupting the program
        H = homog_solve(mp1',mp2');
    else    
        H = homog_solve(mp11',mp22');
    end  
    
end

% Without RANSAC:
function H = homog_solve(MP1, MP2)  
    n = size(MP1, 2);
    if n < 4
        error('Need at least 4 matching points');
    end
    % Solve equations using SVD
    x = MP2(1, :); y = MP2(2,:); X = MP1(1,:); Y = MP1(2,:);
    rows0 = zeros(3, n);
    rowsXY = -[X; Y; ones(1,n)];
    hx = [rowsXY; rows0; x.*X; x.*Y; x];
    hy = [rows0; rowsXY; y.*X; y.*Y; y];
    h = [hx hy];
    if n == 4
        [U, ~, ~] = svd(h);
    else
        [U, ~, ~] = svd(h, 'econ');
    end
    H = (reshape(U(:,9), 3, 3)).';
end