function [x_real_ctr, y_real_ctr] = calibrateRingCenterLive(option, flat_points)
%colorCalibrateLive takes flattened points and opion argument 
%   This function gets the color calibration from Live Stream
%   returns thresholds for calibration and starting position of robots 
%   TODO: Starting positions should be in reference to center of the ring (0,0) 

close all; 
topic = '/camera/depth_registered/points';
center_sub = rossubscriber(topic);
% Receive data from the subscriber as a ROS message. Specify a 10 second timeout.
center_msg = receive(center_sub ,100); 

% Extracts the [r g b] values from all points in the PointCloud2 object,
pcrgb = readRGB(center_msg);
% Saved value from ringCalibreateLive 
pcxyz = flat_points; 

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
mask_ctr = roipoly; % select center of the ring 
mask_bound = roipoly; % select center of the ring 

if option == 1
    % Visualize selected region
    % robot 1 
    figure; 
    imagesc(mask_ctr);
  
end


init_thresh = [h_sigma, s_sigma, v_sigma]; 
x_cords = pcxyz(:,1); 
y_cords = pcxyz(:,2); 

% Get Center Coordinate  
[hsv_thresh_l1] = getThresh(hsv_pts, mask_ctr , init_thresh);
[bin_l1] = seg_color(hsv_pts, hsv_thresh_l1);
[x_target_l1, y_target_l1] = gettarget(bin_l1);
x_target_l1 = round(x_target_l1); 
y_target_l1 = round(y_target_l1);
% Index into flattened points 
x_real_ctr = x_cords(x_target_l1); 
y_real_ctr = y_cords(y_target_l1);

% Get Boundary Coordinate
[hsv_thresh_l2] = getThresh(hsv_pts, mask_bound , init_thresh);
[bin_l2] = seg_color(hsv_pts, hsv_thresh_l2);
[x_target_l2, y_target_l2] = gettarget(bin_l2);
x_target_l2 = round(x_target_l2); 
y_target_l2 = round(y_target_l2);
% Index into flattened points 
x_real_bd = x_cords(x_target_l2); 
y_real_bd= y_cords(y_target_l2);


% Return Values and Printing 
raw_center = [x_real_ctr; y_real_ctr]; 
disp("Center of ring is: "); 
fprintf('X1: %d, Y1: %d \n', x_real_ctr, y_real_ctr);
disp("Bound of ring is: "); 
fprintf('X2: %d, Y2: %d \n', x_real_bd, y_real_bd);

if option == 1 
         figure 
            imagesc(top_img);
        hold on; 
        % Plot Center  
        h_c = plot(x_target_l1, y_target_l1,'r+', 'markersize', 20,'linewidth',2);  
          h_c = plot(x_target_l2, y_target_l2,'r+', 'markersize', 20,'linewidth',2);  
        
   
end 

end