function loc = myHarris(I, quality)

sigma = 5/3;
gblur = fspecial('gaussian', 5, sigma);


harrCorn = corner_metric(I,gblur);

loc = find_peaks(harrCorn, quality);

loc = sub_pixel_location(harrCorn, loc);

end