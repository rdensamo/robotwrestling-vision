function [hsv_thresh_l, hsv_thresh_r, pcxyz] = colorCalibrate(filepath, option)
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
pcxyz = readXYZ(msg{1}); 

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
bad = isnan(pcxyz(:,1));
pcxyz = pcxyz(~bad,:);    
x_cords = pcxyz(:,1); 
y_cords = pcxyz(:,2); 

% left target
[hsv_thresh_l] = getThresh(hsv_pts, mask_l, init_thresh);
[bin_l] = seg_color(hsv_pts, hsv_thresh_l);
[x_target_l, y_target_l] = gettarget(bin_l);
x_target_l = round(x_target_l); 
y_target_l = round(y_target_l);
x_real_l = x_cords(x_target_l); 
y_real_l = y_cords(y_target_l);

% right target 
[hsv_thresh_r] = getThresh(hsv_pts, mask_r, init_thresh);
[bin_r] = seg_color(hsv_pts, hsv_thresh_r); 
[x_target_r, y_target_r] = gettarget(bin_r); 
x_target_r = round(x_target_r);
y_target_r = round(y_target_r); 
x_real_r = x_cords(x_target_r); 
y_real_r = y_cords(y_target_r);

disp("left target"); 
disp(x_real_l);
disp(y_real_l); 
disp("right target"); 
disp(x_real_r);
disp(y_real_r); 

disp("x target"); 
disp(x_target_l)
disp(x_target_r)
disp("y target:");
disp(y_target_l)
disp(y_target_r)

if option == 1 
         figure 
            imagesc(top_img);
        hold on; 
     
        h_l = plot(x_target_l, y_target_l,'b+', 'markersize', 20,'linewidth',2);  
        h_r = plot(x_target_r, y_target_r,'r+', 'markersize', 20,'linewidth',2);  
end 

end