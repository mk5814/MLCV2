function [ histogram_descriptors ] = histogram_feature_descriptor( input_image, points_of_interest, param )
    % Implements naive version of histogram feature descriptors
    % Window size
    if (isfield(param,'window_size'))
        window_size = param.window_size;
    else
        window_size = 64;
    end
    % Histogram patch size
    if (isfield(param,'patch_size'))
        patch_size = param.patch_size;
    else
        patch_size = 8;
    end
    % Histogram number of bins
    if (isfield(param,'number_of_bins'))
        number_of_bins = param.number_of_bins;
    else
        number_of_bins = 8;
    end
    edges = linspace(0,255,number_of_bins+1);
    % Convert to greyscale if not already done so
    if (size(input_image,3)~=1)
        grey_input_image = rgb2gray(input_image);
    else
        grey_input_image = input_image;
    end
    grey_input_image = double(grey_input_image);
    [size_x,size_y] = size(grey_input_image);
    number_of_features = size(points_of_interest,1);
    if (mod(window_size,patch_size)~=0)
        disp('window_size/patch_size must be an integer');
        return
    else
        number_of_patches_1d = window_size/patch_size;
    end
    half_window = round(window_size/2);
    for index1 = 1:number_of_features
        x_i = points_of_interest(index1,1);
        y_i = points_of_interest(index1,2);
        % Extract window
        feature_window = zeros(window_size);
        temp_var_1 = grey_input_image(max(x_i-half_window,1):min(x_i+window_size-half_window-1,size_x),max(y_i-half_window,1):min(y_i+window_size-half_window-1,size_y));
        % Check for boundary conflicts
        if (max(x_i-half_window,1)==1)
            if (max(y_i-half_window,1)==1)
                feature_window(half_window-x_i+2:end,half_window-y_i+2:end) = temp_var_1;
            elseif (min(y_i+window_size-half_window-1,size_y)==size_y)
                feature_window(half_window-x_i+2:end,1:size_y+1+half_window-y_i) = temp_var_1;
            else
                feature_window(half_window-x_i+2:end,:) = temp_var_1;
            end
        elseif(min(x_i+window_size-half_window-1,size_x)==size_x)
            if (max(y_i-half_window,1)==1)
                feature_window(1:size_x+1+half_window-x_i,half_window-y_i+2:end) = temp_var_1;
                % feature_window(1:size_x+1+half_window-x_i:end,half_window-y_i+2:end) = temp_var_1;
            elseif (min(y_i+window_size-half_window-1,size_y)==size_y)
                feature_window(1:size_x+1+half_window-x_i,1:size_y+1+half_window-y_i) = temp_var_1;
                % feature_window(1:size_x+1+half_window-x_i:end,1:size_y+1+half_window-y_i) = temp_var_1;
            else
                feature_window(1:size_x+1+half_window-x_i,:) = temp_var_1;
                % feature_window(1:size_x+1+half_window-x_i:end,:) = temp_var_1;
            end
        elseif (max(y_i-half_window,1)==1)
            feature_window(:,half_window-y_i+2:end) = temp_var_1;
        elseif (min(y_i+window_size-half_window-1,size_y)==size_y)
            feature_window(:,1:size_y+1+half_window-y_i) = temp_var_1;
        else
            feature_window = temp_var_1;
        end
        temp_hist_2 = [];
        for index2 = 1:number_of_patches_1d
            for index3 = 1:number_of_patches_1d
                % Find patch
                temp_patch_1 = feature_window(patch_size*(index2-1)+1:patch_size*index2,patch_size*(index3-1)+1:patch_size*index3);
                temp_patch_1 = reshape(temp_patch_1,[1,patch_size^2]);
                % Find histogram
                temp_hist_1 = histcounts(temp_patch_1,edges)/(patch_size^2);
                temp_hist_2 = [temp_hist_2 temp_hist_1];
            end
        end
        histogram_descriptors(index1,:) = temp_hist_2;
    end
end