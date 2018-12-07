
% Connect to ROS network
rosinit; 
% try

disp("Remove robots from the ring. Calibrating ring center. "); 
pause(10); 
disp("Calibrate and segment ring center");   
RingCenterLiveScript

disp("Flattening Ring Plane. Make sure camera and robots are ready and still."); 
pause(5); 
flat_points = ringCalibrateLive(1); 
pause(10); 

disp("Creating color calibration model. Robots and camera should be ready and still."); 
[hsv_thresh_l1, hsv_thresh_r1, hsv_thresh_l2, hsv_thresh_r2,start_pos_r1, start_pos_r2] = colorCalibrateLive(1,flat_points);
pause(15); 


disp("Starting match ..."); 
%TODO: Make another version of ringCalibrateLive(1); 
 [track_pos_r1, track_pos_r2]= trackRobotLive(hsv_thresh_l1, hsv_thresh_r1, hsv_thresh_l2, hsv_thresh_r2, x_raw, y_raw], 0);
%  catch
% Close ROS network 
disp(" Something went wrong. Closing ros master node "); 
rosshutdown; 
% end 