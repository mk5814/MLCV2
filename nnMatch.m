function [map] = nnMatch( f1, f2, maxRatio, maxThresh )
% map: Nx4 matrix
%      column 1 - index in f1
%      column 2 - index in f2
%      column 3 - distance from point in f1 to closest in f2
%      column 4 - distance from point in f1 to 2nd closest in f2

f1 = (normalize(f1'))';
f2 = (normalize(f2'))';


% Calculate SSD(sum of squared differences)
for i = 1:size(f1,1)
    for j = 1:size(f2,1)
        X = f1(i,:) - f2(j,:);
        dist(j) = sum(X(:).^2);
    end
     
    [dists, match] = min(dist);
    dist(match) = inf;
    ratios = min(dist);
    map(i,1) = i;
    map(i,2) = match;
    map(i,3) = dists;
    map(i,4) = ratios;
    
end

%Remove Ambiguous matches
%Handle divide by 0

zeroIdx = (map(:, 4) < eps);
map(zeroIdx,3:4) = 1;

ratio = map(:, 3) ./ map(:,4);
% idx = (ratio <= maxRatio);
idx = (ratio <= maxRatio) & (map(:,3) < maxThresh*size(f1,2));
% All map(zeroIdx) will have ratio = 1 > ambigTh and will be removed
map = map(idx,:);
newmap = zeros(1,4);

for i = 1:size(map,1)
    duplicates = find(map(:,2) == map(i,2));
    v = map(duplicates,3) == min(map(duplicates,3));
    newmap = [newmap;map(duplicates(v),:)];
end 
map = unique(newmap(:,:), 'rows');
map(1,:) = [];
end

function X = normalize(X)
Xnorm = sqrt(sum(X.^2, 1));
X = bsxfun(@rdivide, X, Xnorm);

% Set effective zero length vectors to zero
X(:, (Xnorm <= eps(single(1))) ) = 0;

end