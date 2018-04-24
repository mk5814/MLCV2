function [FA] = fundamental_accuracy(F, matchedPoints1, matchedPoints2)
    FA = 0;
    for i = 1:size(matchedPoints1,1)
%         if inliers(i) == 1
            [m,c] = epipolar_solve(F,matchedPoints1(i,1),matchedPoints1(i,2));
            d = point_to_line_distance(matchedPoints2(i,:),m,c);
            FA = FA+d;
%         end
    end
    % FA = FA/sum(inliers);
    FA = FA/size(matchedPoints1,1);
end