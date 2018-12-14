
% Connect to ROS network
setenv('ROS_MASTER_URI','http://10.42.0.1:11311')
setenv('ROS_IP','10.42.0.223')
rosinit; 
% try

disp("Remove robots from the ring. Calibrating ring center. Add boundary marker"); 
pause(5); 
disp("Calibrate and segment ring center");   
RingCenterLiveScript

disp("Flattening Ring Plane. Make sure camera and robots are ready and still and remove boundary marker."); 
pause(30); 
flat_poinits = ringCalibrateLive(1); 
pause(10); 

disp("Creating color calibration model. Robots and camera should be ready and still."); 
[hsv_thresh_l1, hsv_thresh_r1, hsv_thresh_l2, hsv_thresh_r2,start_pos_r1, start_pos_r2] = colorCalibrateLive(1,flat_points);
pause(5); 


disp("Starting match ..."); 
%TODO: Make another version of ringCalibrateLive(1); 
 [track_pos_r1, track_pos_r2]= trackRobotLive(hsv_thresh_l1, hsv_thresh_r1, hsv_thresh_l2, hsv_thresh_r2, x_raw_ctr, y_raw_ctr, 0);
%  catch
% Close ROS network 
disp(" Something went wrong. Closing ros master node "); 
rosshutdown; 
% end 