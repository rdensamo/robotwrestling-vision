function [hsv_thresh] = colorCalibrate(filepath, option)
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
h_sigma = 3; 
s_sigma = 3; 
v_sigma = 10; 

% reshapes the image into the correct pixel dimensions
top_img = reshape(pcrgb,640,480,3); 
top_img = imrotate(top_img, 90);
% Converts RGB colors to HSV 
hsv_pts = rgb2hsv(top_img); 

% prepare for image close operation on each color (left and right) -- needs to be in a function
%begin function f1-------------------
figure; 
imagesc(hsv_pts); % this should be hsv_pts not top_img right ?? 
% Allows you to select the polygone with the organge colors
bin_l = roipoly; % select left target 
bin_r = roipoly; % select right target

% do image close operation
%se =  strel('square', 25); %what should be the arguments for this ?? 

%this is a mistake should not close before
%replace with just mask
%bin_l = imclose(mask_l,ones(3)); 
%bin_r = imclose(mask_r,ones(3)); 



if option == 1
    % Visualize selected region
    figure; 
    imagesc(bin_l);
    figure; 
    imagesc(bin_r);
end


%TODO: Comment this section 
% image_red = top_img(:,:,1); 
% image_green = top_img(:,:,2); 
% image_blue = top_img(:,:,3);     
% red_pix = image_red(mask_l); 
% green_pix = image_green(mask_l);
% blue_pix = image_blue(mask_l); 

% TODO: Need to call another function for this --redundant 
%begin f2
%Not do not have red, green, blue values just
% hue, sat, and val 
hsv_hue = hsv_pts(:,:,1);
hsv_sat = hsv_pts(:,:,2); 
hsv_val = hsv_pts(:,:,3); 

% left target
% ----------------------------------------------------call func3
hue_pix_l = hsv_hue(bin_l);
sat_pix_l = hsv_sat(bin_l);
val_pix_l = hsv_val(bin_l);
hue_mean_l = mean(hue_pix_l); 
sat_mean_l = mean(sat_pix_l); 
val_mean_l = mean(val_pix_l); 
hue_std_l = std(single(hue_pix_l)); 
sat_std_l = std(single(sat_pix_l));
val_std_l = std(single(val_pix_l)); 
% threshold calulations 
hue_low_l = (hue_mean_l  - (h_sigma * hue_std_l)); 
hue_high_l = (hue_mean_l  + (h_sigma * hue_std_l)); 
sat_low_l =  (sat_mean_l  - (s_sigma * sat_std_l)); 
sat_high_l = (sat_mean_l  + (s_sigma * sat_std_l)); 
val_low_l = (val_mean_l  - (v_sigma * val_std_l)); 
val_high_l = (val_mean_l  + (v_sigma * val_std_l)); 
%---------------------------------------------------------end func3

%right target
% ----------------------------------------------------call func3
hue_pix_r = hsv_hue(bin_r);
sat_pix_r = hsv_sat(bin_r);
val_pix_r = hsv_val(bin_r);
hue_mean_r = mean(hue_pix_r); 
sat_mean_r = mean(sat_pix_r); 
val_mean_r = mean(val_pix_r); 
hue_std_r = std(single(hue_pix_r)); 
sat_std_r = std(single(sat_pix_r));
val_std_r = std(single(val_pix_r)); 
% threshold calulations 
hue_low_r = (hue_mean_r  - (h_sigma * hue_std_r)); 
hue_high_r = (hue_mean_r  + (h_sigma * hue_std_r)); 
sat_low_r =  (sat_mean_r  - (s_sigma * sat_std_r)); 
sat_high_r = (sat_mean_r  + (s_sigma * sat_std_r)); 
val_low_r = (val_mean_r  - (v_sigma * val_std_r)); 
val_high_r = (val_mean_r  + (v_sigma * val_std_r)); 

% ----------------------------------------------------end func3

%end f2


% We are returning the thresholds to use in tracking the robot
hsv_thresh_l =  [hue_low_l hue_high_l sat_low_l sat_high_l val_low_l val_high_l];
hsv_thresh_r =  [hue_low_r hue_high_r sat_low_r sat_high_r val_low_r val_high_r];


%end function f1 ---------------

hsv_ball_l = hsv_hue >= hue_low_l & hsv_hue <= hue_high_l & hsv_sat>= sat_low_l & hsv_sat <= sat_high_l & hsv_val >= val_low_l & hsv_val <= val_high_l ;
hsv_ball_r = hsv_hue >= hue_low_r & hsv_hue <= hue_high_r & hsv_sat>= sat_low_r & hsv_sat <= sat_high_r & hsv_val >= val_low_r & hsv_val <= val_high_r ;

bin_l = imclose(hsv_ball_l,ones(3)); 
bin_r = imclose(hsv_ball_r, ones(3)); 
% image_ball = image_red >= red_low & image_red <= red_high & image_green >= green_low & image_green <= green_high & image_blue >= blue_low & image_blue <= blue_high;

if option == 1 
     figure 
     plot3(hue_pix_l, sat_pix_l, val_pix_l, '<'); 
     axis( [0 255 0 255 0 255]);
     figure 
     plot3(hue_pix_r, sat_pix_r, val_pix_r, '>'); 
     axis( [0 255 0 255 0 255]);  
%     % Will be redoing this part continually for trackRobot function
%     % However still want to do it in the calibration for verificaiton 
         
         
         
        imagesc(top_img);
%         ind_l = find(hsv_ball_l);
%         ind_r =  find(hsv_ball_r);
        
        % want to use regionprops  instead of finding median value 
    %    reg_lev = 0.3;
        %replaces all values greater than 0.3 with 1 
    %    bin_l = im2bw(closed_mL(ind_l), reg_lev); %may already be binary just closed_mL(ind_l)
       % bin_r = im2bw(closed_mR(ind_r), reg_lev); %may already be binary just closed_mR(ind_r)
        
%        bin_l = bin_l(ind_l); 
%        bin_r = bin_r(ind_r); 
       
        % call another function here 
        %left
        stats_l = regionprops(bin_l, 'Area', 'BoundingBox', 'Centroid'); 
        [max_l,index_l] = max([stats_l.Area]);
        
        % Gets the centroids of all the blobs from the stats struct array 
        %centers_l = cat(1,stats_l.Centroid);
        
        %right
        stats_r = regionprops(bin_r, 'Area', 'BoundingBox', 'Centroid'); 
        stats_l = regionprops(bin_l, 'Area', 'BoundingBox', 'Centroid'); 
        [max_r, index_r] = max([stats_r.Area]);
        [max_l, index_l] = max([stats_l.Area]); 
        
       disp(index_r);
         % Gets the centroids of all the blobs from the stats struct array 
        centers_r = cat(1,stats_r.Centroid);
        centers_l = cat(1,stats_l.Centroid); 
        
        %disp(clocened_mR(ind_r)); 
%        [rows_l, cols_l] = ind2sub([640 480],ind_l);
   %     [rows_r, cols_r] = ind2sub([640 480], ind_r);

%     m_r = median(rows);
%     m_c = median(cols); 
        hold on; 
        %plot(centers_r(index_r,1),centers_r(index_r,2),'r+')
       % h_l = plot(median(cols),median(rows),'b+', 'markersize', 20,'linewidth',2);  
        h_l = plot(centers_l(index_l,1),centers_l(index_l,2),'b+', 'markersize', 20,'linewidth',2);  
        h_r = plot(centers_r(index_r,1),centers_r(index_r,2),'r+', 'markersize', 20,'linewidth',2);  
end 

end