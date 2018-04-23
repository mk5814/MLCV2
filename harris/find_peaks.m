function loc = find_peaks(harrCorn,quality)
    maxHarr = max(harrCorn(:));    
    % Return logical array with 1s wherever there is a regional maximum
    imLogic = imregionalmax(harrCorn, 8);    
    threshold = quality * maxHarr;
    imLogic(harrCorn < threshold) = 0;
    % Remove redundant locations(adjacent points which are actually the
    % same point of interest
    imLogic = bwmorph(imLogic, 'shrink', Inf);

    % Exclude points very close to the border as they may give poor results
    imLogic(1:3, :) = 0;
    imLogic(end-2:end, :) = 0;
    imLogic(:, 1:3) = 0;
    imLogic(:, end-2:end) = 0;

    % Find location of the peaks
    idx = find(imLogic);
    loc = zeros([length(idx) 2], 'like', harrCorn );
    [loc(:, 2), loc(:, 1)] = ind2sub(size(harrCorn), idx);
end