function [rob_x_pos1, rob_y_pos1, rob_theta1, rob_x_pos2, rob_y_pos2, rob_theta2] = trackRobot(filepath, hsv_thresh_l1, hsv_thresh_r1, hsv_thresh_l2, hsv_thresh_r2, vid_name)
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
    bad = isnan(pcxyz(:,1));
    pcxyz = pcxyz(~bad,:); 
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
    disp("original rob_theta: "); 
    disp(rob_theta1 * (180/pi)); 
    % Want to rotate so bumpers are at pi (180 degrees)
    % use what Prof. Spletzer talked to Jerett about doing rotation
    % want to rotate by 90 degrees 
    rob_theta1 = rob_theta1 + (pi/2); 
    rob_theta1 = atan2(sin(rob_theta1),cos(rob_theta1)); 
    disp("rotated rob_theta: "); 
    disp(rob_theta1 * (180/pi)); 
 
    % robot 2
    % Must ensure -pi to pi 
    rob_theta2 = atan2(rob_y_pos2, rob_x_pos2);
    disp("original rob_theta: "); 
    disp(rob_theta2 * (180/pi)); 
    % Want to rotate so bumpers are at pi (180 degrees)
    % use what Prof. Spletzer talked to Jerett about doing rotation
    % want to rotate by 90 degrees 
    rob_theta2 = rob_theta2 + (pi/2); 
    rob_theta2 = atan2(sin(rob_theta2),cos(rob_theta2)); 
    disp("rotated rob_theta: "); 
    disp(rob_theta2 * (180/pi)); 
    
    rosinit % Do not need this when roscore already running ?

% Ros Publisher robot 1 : 
%msgArray = [rosmessage('std_msgs/Int64') rosmessage('std_msgs/Int64') rosmessage('std_msgs/Float64')];
msgArray1 = [rosmessage('std_msgs/String') rosmessage('std_msgs/String') rosmessage('std_msgs/String')];
msgArray1(1).Data = num2str(rob_x_pos1);
msgArray1(2).Data = num2str(rob_y_pos1); 
msgArray1(3).Data = num2str(rob_theta1);
disp("msgArray:"); 
disp(msgArray1(3).Data ); 
% msgArray(1).Data = 'test1'; 
% msgArray(2).Data = 'test2';
% msgArray(3).Data = 'test3';
allData = {msgArray1.Data};

rob_pub1 = rospublisher('/robot_pos1','std_msgs/String' );
send(rob_pub1, msgArray1);

% Ros Publisher robot 2 : 
%msgArray = [rosmessage('std_msgs/Int64') rosmessage('std_msgs/Int64') rosmessage('std_msgs/Float64')];
msgArray2 = [rosmessage('std_msgs/String') rosmessage('std_msgs/String') rosmessage('std_msgs/String')];
msgArray2(1).Data = num2str(rob_x_pos2);
msgArray2(2).Data = num2str(rob_y_pos2); 
msgArray2(3).Data = num2str(rob_theta2);
disp("msgArray:"); 
disp(msgArray2(3).Data ); 
% msgArray2(1).Data = 'test1'; 
% msgArray2(2).Data = 'test2';
% msgArray2(3).Data = 'test3';
allData = {msgArray2.Data};

rob_pub2 = rospublisher('/robot_pos2','std_msgs/String' );
send(rob_pub2, msgArray2);

% Ros Subscriber: For testing purposes robot 1  
rob_sub1 = rossubscriber('/robot_pos1');
% Receive data from the subscriber as a ROS message. Specify a 10 second timeout.
recArray1 = receive(rob_sub1,100); % is this blocking ? asyc ? 
disp("recArray1:"); 
disp(recArray1(1).Data ); 
disp(rob_x_pos1); 

% Ros Subscriber: For testing purposes robot 2  
rob_sub2 = rossubscriber('/robot_pos2');
% Receive data from the subscriber as a ROS message. Specify a 10 second timeout.
recArray2 = receive(rob_sub2,100); % is this blocking ? asyc ? 
disp("recArray2:"); 
disp(recArray2(1).Data ); 
disp(rob_x_pos2); 

rosshutdown % Do not need this when roscore already running ? 
    

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




