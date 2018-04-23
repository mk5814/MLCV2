function d = point_to_line(pt, m, c)
    % pt should be 1x3
    % v1 and v2 are vertices on the line (each 1x3)
    % d is a nx1 vector with the orthogonal distances
    v1 = [0, c, 0];
    v2 = [1, m+c, 0];
    pt = [pt, zeros(size(pt,1),1)];
    a = v1 - v2;
    b = pt - v2;
    d = sqrt(sum(cross(a,b,2).^2,2)) ./ sqrt(sum(a.^2,2));
end