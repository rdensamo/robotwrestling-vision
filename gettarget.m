function [x_target, y_target] = gettarget(bin_img)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

        stats = regionprops(bin_img, 'Area', 'BoundingBox', 'Centroid'); 
        
        [max_v, index] = max([stats.Area]);

        centers = cat(1,stats.Centroid);
        x_target = centers(index,1); 
        y_target = centers(index,2); 
        
end

