function [hsv_thresh] = getThresh(hsv_pts, mask, init_thresh)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
h_sigma = init_thresh(1); 
s_sigma = init_thresh(2); 
v_sigma = init_thresh(3); 

hsv_hue = hsv_pts(:,:,1);
hsv_sat = hsv_pts(:,:,2); 
hsv_val = hsv_pts(:,:,3); 

% Statistical calculations 
hue_pix = hsv_hue(mask);
sat_pix = hsv_sat(mask);
val_pix = hsv_val(mask);
hue_mean = mean(hue_pix); 
sat_mean = mean(sat_pix); 
val_mean = mean(val_pix); 
hue_std = std(single(hue_pix)); 
sat_std = std(single(sat_pix));
val_std = std(single(val_pix)); 

% Threshold calculations 
hue_low = (hue_mean  - (h_sigma * hue_std)); 
hue_high = (hue_mean  + (h_sigma * hue_std)); 
sat_low =  (sat_mean  - (s_sigma * sat_std)); 
sat_high = (sat_mean  + (s_sigma * sat_std)); 
val_low = (val_mean  - (v_sigma * val_std)); 
val_high = (val_mean  + (v_sigma * val_std)); 

hsv_thresh = [hue_low hue_high sat_low sat_high val_low val_high];


end
