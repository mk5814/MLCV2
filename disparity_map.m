function [map] = disparity_map(I1,I2,maxx,a)
    
    s = size(I1);
    map = zeros(s);
    nbhd = 5;
    
    px = 7;
    py = 2;
    
    for y = nbhd+1:s(1)-nbhd
        for x = maxx:s(2)-px
            tmp = I1(y,x);
            mincost = inf;
            neibDisp = mean(mean(map(y-nbhd, x-nbhd:x)));
            
            for i = -(maxx-1-px):(maxx-1-px)
                p1 = I1(y-py:y+py, x-px:x+px);
                p2 = I2(y-py:y+py, x-px+i:x+px+i);
                
                matchCost = mean((p1(:)-p2(:)).^2);
                smoothCost = a*(i-neibDisp)^2;
                
                cost = matchCost + smoothCost;                
                if cost < mincost
                    mincost = cost;
                    tmpdisp = i;
                end
            end
            map(y,x) = tmpdisp/maxx;
        end
    end    
end




