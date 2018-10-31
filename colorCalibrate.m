function [rgb_thresh] = colorCalibrate(filepath, option)
%colorCalibrate takes bag file path and opion argument for graphing
%   This function gets the color calibration from a bag file 
%   returns the red, green, blue means and stds 


% filepath = '/home/vader/matlabCode/data/oct5bag.bag'

% Gets ros bag that has the depth and color data (topic) 
bag = rosbag(filepath); 
bagselect0 = select(bag, 'Topic', '/camera/depth_registered/points');
close all;

% Number of standard deviations to use for establishing threshold
num_sigmas = 4;

% Gets the first frame 
msg = readMessages(bagselect0,1);
% Extracts the [r g b] values from all points in the PointCloud2 object,
pcrgb = readRGB(msg{1});



% HSV standard deviation values 
HS_sigma = 3; 
V_sigma = 10; 

% reshapes the image into the correct pixel dimensions
top_img = reshape(pcrgb,640,480,3); 
top_img = imrotate(top_img, 90);
% Converts RGB colors to HSV 
hsv_pts = rgb2hsv(top_img); 

% prepare for image close operation on each color (left and right) -- needs to be in a function
%begin function
figure; 
imagesc(hsv_pts); % this should be hsv_pts not top_img right ?? 
% Allows you to select the polygone with the organge colors
mask_l = roipoly; % select left target 
mask_r = roipoly; % select right target

% do image close operation
se =  strel('square',25); %what should be the arguments for this ?? 
closed_mL = imclose(mask_l,se); 
closed_mR = imclose(mask_r,se); 

if option == 1
    % Visualize selected region
    figure; 
    imagesc(closed_mL);
    figure; 
    imagesc(closed_mR);
end

%end function

%TODO: Comment this section 
image_red = top_img(:,:,1); 
image_green = top_img(:,:,2); 
image_blue = top_img(:,:,3);     
red_pix = image_red(mask_l); 
green_pix = image_green(mask_l);
blue_pix = image_blue(mask_l); 


green_std = std(single(green_pix)); 
blue_std = std(single(blue_pix)); 
red_std = std(single(red_pix)); 
green_mean = mean(green_pix);
blue_mean = mean(blue_pix);
red_mean = mean(red_pix); 

% TODO: Might not want to hard code the 2 
red_low = (red_mean - (num_sigmas * red_std)); 
red_high = (red_mean + (num_sigmas * red_std)); 
green_low = (green_mean - (num_sigmas * green_std)); 
green_high = (green_mean + (num_sigmas * green_std)); 
blue_low = (blue_mean - (num_sigmas * blue_std)); 
blue_high = (blue_mean + (num_sigmas * blue_std)); 

% We are returning the thresholds to use in tracking the robot
rgb_thresh = [red_low red_high green_low green_high blue_low blue_high];

image_ball = image_red >= red_low & image_red <= red_high & image_green >= green_low & image_green <= green_high & image_blue >= blue_low & image_blue <= blue_high;
 
if option == 1 
    plot3(blue_pix, red_pix, green_pix, '.'); 
    axis( [0 255 0 255 0 255]);  
    % Will be redoing this part continually for trackRobot function
    % However still want to do it in the calibration for verificaiton 

    %TODO: might need to chage to 640 by 480 instead 
    imagesc(top_img);
    find(image_ball);
    [rows, cols] = ind2sub([640 480], find(image_ball));
    m_r = median(rows);
    m_c = median(cols); 
    hold on; 
    h = plot(median(cols),median(rows),'b+', 'markersize', 20,'linewidth',2);  
end 

end