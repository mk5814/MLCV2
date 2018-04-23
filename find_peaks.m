function loc = find_peaks(metric,quality)
maxMetric = max(metric(:));
if maxMetric <= eps(0)
    loc = zeros(0,2, 'single');
else
    
    % Return logical array with 1s wherever there is a regional maximum
    imLogic = imregionalmax(metric, 8);    
    threshold = quality * maxMetric;
    imLogic(metric < threshold) = 0;
    % Remove redundant locations(adjacent points which are actually the
    % same point of interest
    imLogic = bwmorph(imLogic, 'shrink', Inf);
    
    % Exclude points very close to the border as they may be unreliable
%     imLogic(1:3, :) = 0;
%     imLogic(end-2:end, :) = 0;
%     imLogic(:, 1:3) = 0;
%     imLogic(:, end-2:end) = 0;
    imLogic(1, :) = 0;
    imLogic(end, :) = 0;
    imLogic(:, 1) = 0;
    imLogic(:, end) = 0;
    
    % Find location of the peaks
    idx = find(imLogic);
    loc = zeros([length(idx) 2], 'like', metric );
    [loc(:, 2), loc(:, 1)] = ind2sub(size(metric), idx);
end