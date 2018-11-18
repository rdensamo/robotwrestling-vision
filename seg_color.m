function [bin_img] = seg_color(hsv_pts, hsv_thresh)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
hsv_hue = hsv_pts(:,:,1);
hsv_sat = hsv_pts(:,:,2); 
hsv_val = hsv_pts(:,:,3); 
hsv_ball = hsv_hue >= hsv_thresh(1) & hsv_hue <= hsv_thresh(2) & hsv_sat >= hsv_thresh(3) & hsv_sat <= hsv_thresh(4) & hsv_val >= hsv_thresh(5) & hsv_val <= hsv_thresh(6);  
bin_img = imclose(hsv_ball, ones(3)); 

end

