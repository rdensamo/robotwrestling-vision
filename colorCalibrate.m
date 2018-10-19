function [rgbVals] = colorCalibrate(filepath, option)
%colorCalibrate takes bag file path and opion argument for graphing
%   This function gets the color calibration from a bag file 
%   returns the red, green, blue means and stds 
%TODO: returning the mask might not be necessary 

% filepath = '/home/vader/matlabCode/data/oct5bag.bag'

% Gets ros bag that has the depth and color data (topic) 
bag = rosbag(filepath); 
bagselect0 = select(bag, 'Topic', '/camera/depth_registered/points');
close all;

% Gets the first frame 
msg = readMessages(bagselect0,1);
% Extracts the [r g b] values from all points in the PointCloud2 object,
pcrgb = readRGB(msg{1});
% reshapes the image into the correct pixel dimensions
% TODO: this might need to be 480 by 640 instead and validate comment above
top_img = reshape(pcrgb,640,480,3); 
if option == 1
    figure; 
    imagesc(top_img);
end
% Allows you to select the polygone with the organge colors
mask = roipoly; 
if option == 1
    % Visualize selected region
    imagesc(mask);
end

%TODO: Comment this section 
image_red = top_img(:,:,1); 
image_green = top_img(:,:,2); 
image_blue = top_img(:,:,3);     
red_img = image_red(mask); 
green_img = image_green(mask); 
blue_img = image_blue(mask); 


green_std = std(single(green_img)); 
blue_std = std(single(blue_img)); 
red_std = std(single(red_img)); 
green_mean = mean(green_img);
blue_mean = mean(blue_img);
red_mean = mean(red_img); 

% The return values 
% first row is means 
rgbVals(1,:) = [red_mean; green_mean; blue_mean]; 
% second row is stds 
rgbVals(2,:) = [red_std, green_std, blue_std]; 

% TODO: Might not want to hard code the 2 
red_low = (red_mean - (2 * red_std)); 
red_high = (red_mean + (2 * red_std)); 
green_low = (green_mean - (2 * green_std)); 
green_high = (green_mean + (2 * green_std)); 
blue_low = (blue_mean - (2 * blue_std)); 
blue_high = (blue_mean + (2 * blue_std)); 

image_ball = image_red >= red_low & image_red <= red_high & image_green >= green_low & image_green <= green_high & image_blue >= blue_low & image_blue <= blue_high;
    
if option == 1 
    plot3(blue_img, red_img, green_img, '.'); 
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