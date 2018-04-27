function map = depth_map(dispMap,f,d)   
    sz = size(dispMap);
    szCCD = [0.158,0.236];
    map = zeros(sz);
    for y = 1:sz(1)
        for x = 1:sz(2)   
            i1ccd = (x-sz(2)/2)/(sz(2)*szCCD(2));
            i2ccd = (x-dispMap(y,x)-sz(2)/2)/(sz(2)*szCCD(2));
            if i2ccd == 0
                continue
            end
            m1 = f/i1ccd;
            m2 = f/i2ccd;
            if i1ccd == 0
                map(y,x) = m2*d;
                continue
            end
            if m1-m2 ~= 0
                map(y,x) = (m1*m2*d)/(m2-m1);
            end            
        end
    end
end