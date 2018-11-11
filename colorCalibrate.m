function [hsv_thresh_l, hsv_thresh_r] = colorCalibrate(filepath, option)
% TODO: Fix this function comment 
% TODO: ONCE YOU WRITE ROS SUBSCRIBER SWITCH BAG PARAMETER WITH TOPIC
%colorCalibrate gittakes bag file path and opion argument for graphing
%   This function gets the color calibration from a bag file 
%   returns the red, green, blue means and stds 


close all;

% Gets ros bag that has the depth and color data (topic) 
bag = rosbag(filepath); 
bagselect0 = select(bag, 'Topic', '/camera/depth_registered/points');


% Gets the first frame 
msg = readMessages(bagselect0,1);
% Extracts the [r g b] values from all points in the PointCloud2 object,
pcrgb = readRGB(msg{1});

% HSV standard deviation values 
h_sigma = 3; 
s_sigma = 3; 
v_sigma = 10; 


% reshapes the image into the correct pixel dimensions
top_img = reshape(pcrgb,640,480,3); 
top_img = imrotate(top_img, 90);
% Converts RGB colors to HSV 
hsv_pts = rgb2hsv(top_img); 


figure; 
imagesc(hsv_pts); 
% Allows you to select the polygone area with colors
mask_l = roipoly; % select left target 
mask_r = roipoly; % select right target

if option == 1
    % Visualize selected region
    figure; 
    imagesc(mask_l);
    figure; 
    imagesc(mask_r);
end


init_thresh = [h_sigma, s_sigma, v_sigma]; 

% left target
[bin_l, hsv_thresh_l] = seg_color(hsv_pts, mask_l, init_thresh);
[x_target_l, y_target_l] = gettarget(bin_l); 
% right target 
[bin_r,hsv_thresh_r] = seg_color(hsv_pts, mask_r, init_thresh); 
[x_target_r, y_target_r] = gettarget(bin_r); 

if option == 1 
         figure 
            imagesc(top_img);
        hold on; 
     
        h_l = plot(x_target_l, y_target_l,'b+', 'markersize', 20,'linewidth',2);  
        h_r = plot(x_target_r, y_target_r,'r+', 'markersize', 20,'linewidth',2);  
end gi

end