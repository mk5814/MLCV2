% Witch RANSAC
function H = homography_solveRANSAC(mp1, mp2, ransacTh)
    
    numTrials = 500;
    inliers = cell(1,numTrials);
    for i = 1:numTrials    
        idx = randperm(size(mp1,1),5);
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
    
    H = homog_solve(mp11',mp22');
    
    
end

% Without RANSAC:
function H = homog_solve(matchedPoints1, matchedPoints2)
    n = size(matchedPoints1, 2);
    % Solve equations using SVD
    x = matchedPoints2(1,:); 
    y = matchedPoints2(2,:); 
    X = matchedPoints1(1,:); 
    Y = matchedPoints1(2,:);

    rows0 = zeros(3, n);
    rowsXY = -[X; Y; ones(1,n)];

    hx = [rowsXY; rows0; x.*X; x.*Y; x];
    hy = [rows0; rowsXY; y.*X; y.*Y; y];
    h = [hx hy];

    [U, ~, ~] = svd(h, 'econ');

    H = (reshape(U(:,9), 3, 3)).';
end