function [hsv_thresh_l1, hsv_thresh_r1, hsv_thresh_l2, hsv_thresh_r2,start_pos_r1, start_pos_r2] = colorCalibrateLive(option, flat_points)
%colorCalibrateLive takes flattened points and opion argument 
%   This function gets the color calibration from Live Stream
%   returns thresholds for calibration and starting position of robots 
%   TODO: Starting positions should be in reference to center of the ring (0,0) 

close all; 
topic = '/camera/depth_registered/points';
start_sub = rossubscriber(topic);
% Receive data from the subscriber as a ROS message. Specify a 10 second timeout.
start_msg = receive(start_sub,100); 

% Extracts the [r g b] values from all points in the PointCloud2 object,
pcrgb = readRGB(start_msg);
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
mask_r1_l = roipoly; % select left target robot 1
mask_r1_r = roipoly; % select right target robot 1 

mask_r2_l = roipoly; % select left target robot 2
mask_r2_r = roipoly; % select right target robot 2 

if option == 1
    % Visualize selected region
    % robot 1 
    figure; 
    imagesc(mask_r1_l);
    figure; 
    imagesc(mask_r1_r);
    
    % robot 2 
    figure; 
    imagesc(mask_r2_l);
    figure; 
    imagesc(mask_r2_r);
end


init_thresh = [h_sigma, s_sigma, v_sigma]; 
x_cords = pcxyz(:,1); 
y_cords = pcxyz(:,2); 

%robot1: 
% left target robot 1 
[hsv_thresh_l1] = getThresh(hsv_pts, mask_r1_l , init_thresh);
[bin_l1] = seg_color(hsv_pts, hsv_thresh_l1);
[x_target_l1, y_target_l1] = gettarget(bin_l1);
x_target_l1 = round(x_target_l1); 
y_target_l1 = round(y_target_l1);
x_real_l1 = x_cords(x_target_l1); 
y_real_l1 = y_cords(y_target_l1);

% right target robot 1 
[hsv_thresh_r1] = getThresh(hsv_pts, mask_r1_r, init_thresh);
[bin_r1] = seg_color(hsv_pts, hsv_thresh_r1); 
[x_target_r1, y_target_r1] = gettarget(bin_r1); 
x_target_r1 = round(x_target_r1);
y_target_r1 = round(y_target_r1); 
x_real_r1 = x_cords(x_target_r1); 
y_real_r1 = y_cords(y_target_r1);
x_reals1 = [x_real_l1, x_real_r1];
y_reals1 = [y_real_l1, y_real_r1]; 
rob_x_pos1 = mean(x_reals1); 
rob_y_pos1 = mean(y_reals1); 

% robot 2:
% left target robot 2
[hsv_thresh_l2] = getThresh(hsv_pts, mask_r2_l , init_thresh);
[bin_l2] = seg_color(hsv_pts, hsv_thresh_l2);
[x_target_l2, y_target_l2] = gettarget(bin_l2);
x_target_l2 = round(x_target_l2); 
y_target_l2 = round(y_target_l2);
x_real_l2 = x_cords(x_target_l2); 
y_real_l2 = y_cords(y_target_l2);

% right target robot 2 
[hsv_thresh_r2] = getThresh(hsv_pts, mask_r2_r , init_thresh);
[bin_r2] = seg_color(hsv_pts, hsv_thresh_r2); 
[x_target_r2, y_target_r2] = gettarget(bin_r2); 
x_target_r2 = round(x_target_r2);
y_target_r2 = round(y_target_r2); 
x_real_r2 = x_cords(x_target_r2); 
y_real_r2 = y_cords(y_target_r2);
x_reals2 = [x_real_l2, x_real_r2];
y_reals2 = [y_real_l2, y_real_r2]; 
rob_x_pos2 = mean(x_reals2); 
rob_y_pos2 = mean(y_reals2); 

% Robot 1 
rob_theta1 = atan2(rob_y_pos1, rob_x_pos1);
rob_theta1 = rob_theta1 + (pi/2); 

% Robot 2
rob_theta2 = atan2(rob_y_pos2, rob_x_pos2);
rob_theta2 = rob_theta2 + (pi/2); 


% Return Values and Printing 
start_pos_r1 = [rob_x_pos1, rob_x_pos1, rob_theta1]; 
start_pos_r2 = [rob_x_pos1, rob_x_pos1, rob_theta1]; 
disp("rob1 start pos: "); 
fprintf('X1: %d, Y1: %d, Theta1: %d \n',rob_x_pos1, rob_y_pos1, rob_theta1);
disp("rob2 start pos: "); 
fprintf('X2: %d, Y2: %d, Theta2: %d \n',rob_x_pos2, rob_y_pos2, rob_theta2);
 
% Need to get middle of the robot and orientation
% TODO: Include error checking for bad estimates 

if option == 1 
         figure 
            imagesc(top_img);
        hold on; 
        %robot 1 
        h_l1 = plot(x_target_l1, y_target_l1,'g+', 'markersize', 20,'linewidth',2);  
        h_r1 = plot(x_target_r1, y_target_r1,'y+', 'markersize', 20,'linewidth',2);  
        
        %robot 2 
        h_l2 = plot(x_target_l2, y_target_l2,'b+', 'markersize', 20,'linewidth',2);  
        h_r2 = plot(x_target_r2, y_target_r2,'r+', 'markersize', 20,'linewidth',2);  
        
end 

end