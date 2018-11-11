function [x_pos, y_pos, theta] = trackRobot(filepath, hsv_thresh_l, hsv_thresh_r, vid_name)
% TODO: Fix this function comment 
% TODO: ONCE YOU WRITE ROS SUBSCRIBER SWITCH BAG PARAMETER WITH TOPIC
% returns the position and orientation of the robot: x_pos, y_pos and theta 
% trackRobot Summary of this function goes here
%   if vid_name = 1 records a movie
%   Detailed explanation goes here



% Gets ros bag that has the depth and color data (topic)
bag = rosbag(filepath);
bagselect0 = select(bag, 'Topic', '/camera/depth_registered/points');
close all;

% Want to record video
% TODO: Install VLC to view this video format
if(vid_name == 1)
    pause on;  %enable pause function
    v = VideoWriter('robot_tracking_matt_alien.avi');
    open(v);
end

for i=1:bagselect0.NumMessages
    msg = readMessages(bagselect0,i);
    pcrgb = readRGB(msg{1});
    top_img = reshape(pcrgb,640,480,3);
    % hue, sat, and val 
    hsv_pts = rgb2hsv(top_img); 
    hsv_hue = hsv_pts(:,:,1);
    hsv_sat = hsv_pts(:,:,2); 
    hsv_val = hsv_pts(:,:,3); 
    
    hsv_ball_l = hsv_hue >= hsv_thresh_l(1) & hsv_hue <= hsv_thresh_l(2) & hsv_sat >= hsv_thresh_l(3) & hsv_sat <= hsv_thresh_l(4) & hsv_val >= hsv_thresh_l(5) & hsv_val <= hsv_thresh_l(6);  
    hsv_ball_r = hsv_hue >= hsv_thresh_r(1) & hsv_hue <= hsv_thresh_r(2) & hsv_sat >= hsv_thresh_r(3) & hsv_sat <= hsv_thresh_r(4) & hsv_val >= hsv_thresh_r(5) & hsv_val <= hsv_thresh_r(6); 
    
    bin_l = imclose(hsv_ball_l,ones(3)); 
    bin_r = imclose(hsv_ball_r, ones(3)); 

    if ( i == 1)
        f = figure;
        im = imagesc(top_img);
        set(gca, 'nextplot', 'replacechild');
        set(gcf, 'Renderer', 'zbuffer');
    end
    
    if (vid_name == 1)
        frame = getframe;
        writeVideo(v,frame);
    end
    
    im = imagesc(top_img);
%     image_red = top_img(:,:,1);
%     image_green = top_img(:,:,2);
%     image_blue = top_img(:,:,3);
%     
%     
%     image_ball = image_red >= thresh(1) & image_red <= thresh(2) & ...
%         image_green >= thresh(3) & image_green <= thresh(4) & ...
%         image_blue >= thresh(5) & image_blue <= thresh(6);
%     image_ball = imclose(image_ball, ones(3));
    
%     ind = find(image_ball);
%     image_red(ind) = 0;
%     top_img(:,:,1) = image_red;
%     [rows, cols] = ind2sub([640 480], ind);
%     imagesc(top_img);
%     
%     m_r = median(rows);
%     m_c = median(cols);
%     
    
    if ( i ~= 1 )
        im = imagesc(top_img);
    end
     stats_l = regionprops(bin_l, 'Area', 'BoundingBox', 'Centroid'); 
     [max_l,index_l] = max([stats_l.Area]);
     stats_r = regionprops(bin_r, 'Area', 'BoundingBox', 'Centroid'); 
        stats_l = regionprops(bin_l, 'Area', 'BoundingBox', 'Centroid'); 
        [max_r, index_r] = max([stats_r.Area]);
        [max_l, index_l] = max([stats_l.Area]); 
        
       %disp(index_r);
         % Gets the centroids of all the blobs from the stats struct array 
        centers_r = cat(1,stats_r.Centroid);
        centers_l = cat(1,stats_l.Centroid); 
        
    hold on;
      h_l = plot(centers_l(index_l,1),centers_l(index_l,2),'b+', 'markersize', 20,'linewidth',2);  
        h_r = plot(centers_r(index_r,1),centers_r(index_r,2),'r+', 'markersize', 20,'linewidth',2);  
end

if(vid_name == 1)
    close(v);
end




