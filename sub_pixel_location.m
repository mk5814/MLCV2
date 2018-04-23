%% UNUSED
function loc = sub_pixel_location(metric, loc)
    loc = reshape(loc', 2, 1, []);
    nLocs = size(loc,3);
    patch = zeros([3, 3, nLocs], 'like', metric);
    x = loc(1,1,:);
    y = loc(2,1,:);
    xm1 = x-1;
    xp1 = x+1;
    ym1 = y-1;
    yp1 = y+1;
    xsubs = [xm1, x, xp1;
             xm1, x, xp1;
             xm1, x, xp1];
    ysubs = [ym1, ym1, ym1;
             y, y, y;
             yp1, yp1, yp1];
    linind = sub2ind(size(metric), ysubs(:), xsubs(:));
    patch(:) = metric(linind);

    dx2 = ( patch(1,1,:) - 2*patch(1,2,:) +   patch(1,3,:) ...
        + 2*patch(2,1,:) - 4*patch(2,2,:) + 2*patch(2,3,:) ...
        +   patch(3,1,:) - 2*patch(3,2,:) +   patch(3,3,:) ) / 8;

    dy2 = ( ( patch(1,1,:) + 2*patch(1,2,:) + patch(1,3,:) )...
        - 2*( patch(2,1,:) + 2*patch(2,2,:) + patch(2,3,:) )...
        +   ( patch(3,1,:) + 2*patch(3,2,:) + patch(3,3,:) )) / 8;

    dxy = ( + patch(1,1,:) - patch(1,3,:) ...
            - patch(3,1,:) + patch(3,3,:) ) / 4;

    dx = ( - patch(1,1,:) - 2*patch(2,1,:) - patch(3,1,:)...
           + patch(1,3,:) + 2*patch(2,3,:) + patch(3,3,:) ) / 8;

    dy = ( - patch(1,1,:) - 2*patch(1,2,:) - patch(1,3,:) ...
           + patch(3,1,:) + 2*patch(3,2,:) + patch(3,3,:) ) / 8;

    detinv = 1 ./ (dx2.*dy2 - 0.25.*dxy.*dxy);

    % Calculate peak position and value
    x = -0.5 * (dy2.*dx - 0.5*dxy.*dy) .* detinv; % X-Offset of quadratic peak
    y = -0.5 * (dx2.*dy - 0.5*dxy.*dx) .* detinv; % Y-Offset of quadratic peak

    % If both offsets are less than 1 pixel, the sub-pixel location is
    % considered valid.
    isValid = (abs(x) < 1) & (abs(y) < 1);
    x(~isValid) = 0;
    y(~isValid) = 0;
    subPixelLoc = [x; y] + loc;
    loc = squeeze(loc)';
end