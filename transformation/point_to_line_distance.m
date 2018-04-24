function d = point_to_line_distance(pt, m, c)
    % Equation of normal to y=mx+c passing through pt
    m1 = -1/m;
    c1 = pt(2) -m1*pt(1);
    
    x2 = (c1-c)/(m-m1);
    y2 = m*x2 + c;
    d = norm([x2,y2]-pt);
%     d = sqrt((x2-pt(1))^2 + (y2-pt(2))^2);
    
end