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
    pcxyz = readXYZ(msg{1});  
    top_img = reshape(pcrgb,640,480,3); 
    hsv_pts = rgb2hsv(top_img); 
    disp("bagselect0.NumMessages:"); 
    disp(bagselect0.NumMessages); 
    x_cords = pcxyz(:,1); 
    y_cords = pcxyz(:,2);

    % left target
    [bin_l] = seg_color(hsv_pts, hsv_thresh_l);
    [x_target_l, y_target_l] = gettarget(bin_l); 
    x_target_l = round(x_target_l); 
    y_target_l = round(y_target_l);
    x_real_l = x_cords(x_target_l); 
    y_real_l = y_cords(y_target_l);

    
    % right target 
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
  
    
    if ( i ~= 1 )
        im = imagesc(top_img);
    end
   
    hold on;
        h_l = plot(x_target_l, y_target_l,'b+', 'markersize', 20,'linewidth',2);  
        h_r = plot(x_target_r, y_target_r,'r+', 'markersize', 20,'linewidth',2);  
end

if(vid_name == 1)
    close(v);
end




