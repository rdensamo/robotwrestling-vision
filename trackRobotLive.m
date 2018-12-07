function [track_pos_r1, track_pos_r2] = trackRobotLive(hsv_thresh_l1, hsv_thresh_r1, hsv_thresh_l2, hsv_thresh_r2, x_raw_ctr, y_raw_ctr, vid_name)
% TODO: Fix this function comment 
% TODO: ONCE YOU WRITE ROS SUBSCRIBER SWITCH BAG PARAMETER WITH TOPIC
% returns the position and orientation of the robot: x_pos, y_pos and theta 
% trackRobot Summary of this function goes here
%   if vid_name = 1 records a movie
%   Detailed explanation goes here


close all; 
topic = '/camera/depth_registered/points';
track_sub = rossubscriber(topic);
% Receive data from the subscriber as a ROS message. Specify a 10 second timeout.
track_msg = receive(track_sub,100); 



% Want to record video
% TODO: Install VLC to view this video format
if(vid_name == 1)
    pause on;  %enable pause function
    v = VideoWriter('two robots_yellow_steps.avi');
    open(v);
end
 


while(1) 
    pcrgb = readRGB(track_msg);
    % TODO: Very inefficient, need to optimize 
    pcxyz = ringCalibrateLive(0); 
    top_img = reshape(pcrgb,640,480,3); 
    hsv_pts = rgb2hsv(top_img); 
    x_cords = pcxyz(:,1); 
    y_cords = pcxyz(:,2);
    
    % robot 1 
    % left target
    [bin_l1] = seg_color(hsv_pts, hsv_thresh_l1);
    [x_target_l1, y_target_l1] = gettarget(bin_l1); 
    x_target_l1 = round(x_target_l1); 
    y_target_l1 = round(y_target_l1);
    x_real_l1 = x_cords(x_target_l1); 
    y_real_l1 = y_cords(y_target_l1);

    
    % right target 
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
    
     % robot 2
    % left target
    [bin_l2] = seg_color(hsv_pts, hsv_thresh_l2);
    [x_target_l2, y_target_l2] = gettarget(bin_l2); 
    x_target_l2 = round(x_target_l2); 
    y_target_l2 = round(y_target_l2);
    x_real_l2 = x_cords(x_target_l2); 
    y_real_l2 = y_cords(y_target_l2);

    
    % right target 
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
    
    % robot 1
    % Must ensure -pi to pi 
    rob_theta1 = atan2(rob_y_pos1, rob_x_pos1);
    rob_theta1 = rob_theta1 + (pi/2); 
 
    % robot 2
    % Must ensure -pi to pi 
    rob_theta2 = atan2(rob_y_pos2, rob_x_pos2);
    rob_theta2 = rob_theta2 + (pi/2); 
   
  

% Ros Publisher robot 1 : 
msg1 = rosmessage('geometry_msgs/Pose2D'); 
rob_pub1 = rospublisher('/robot_pos1','geometry_msgs/Pose2D' );
msg1.X = rob_x_pos1; 
msg1.Y = rob_y_pos1; 
msg1.Theta = rob_theta1; 
send(rob_pub1, msg1);

% Ros Publisher robot 2 :
msg2 = rosmessage('geometry_msgs/Pose2D');
msg2.X = rob_x_pos2; 
msg2.Y = rob_y_pos2; 
msg2.Theta = rob_theta2; 
rob_pub2 = rospublisher('/robot_pos2','geometry_msgs/Pose2D' );
send(rob_pub2, msg2);


% Return Values and Printing 
track_pos_r1 = [rob_x_pos1, rob_y_pos1, rob_theta1]; 
track_pos_r2 = [rob_x_pos2, rob_y_pos2, rob_theta2]; 
disp("rob1 tracking pos (printing theta in degrees): "); 
fprintf('X1: %d, Y1: %d, Theta1: %d \n',rob_x_pos1, rob_y_pos1, rob_theta1*(180/pi));
disp("rob2 tracking pos (printing theta in degrees): "); 
fprintf('X2: %d, Y2: %d, Theta2: %d \n',rob_x_pos2, rob_y_pos2, rob_theta2*(180/pi));
 
    

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
         %robot 1 
        h_l1 = plot(x_target_l1, y_target_l1,'g+', 'markersize', 20,'linewidth',2);  
        h_r1 = plot(x_target_r1, y_target_r1,'y+', 'markersize', 20,'linewidth',2);  
        
        %robot 2 
        h_l2 = plot(x_target_l2, y_target_l2,'b+', 'markersize', 20,'linewidth',2);  
        h_r2 = plot(x_target_r2, y_target_r2,'r+', 'markersize', 20,'linewidth',2);  
end


if(vid_name == 1)
    close(v);
end




