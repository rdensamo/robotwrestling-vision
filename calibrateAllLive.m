
% Connect to ROS network
rosinit; 
try
disp("Flattening Ring Plane. Make sure camera and robots are ready and still."); 
pause(5); 
flat_points = ringCalibrateLive(1); %TODO: DO I NEED TO KEEP CALLING THIS OR CALL THIS ONCE AND INDEX ? 
%TODO: NEED TO GET CENTER OF THE RING 
pause(10); 

disp("Creating color calibration model. Robots and camera should be ready and still."); 
[hsv_thresh_l1, hsv_thresh_r1, hsv_thresh_l2, hsv_thresh_r2,start_pos_r1, start_pos_r2] = colorCalibrateLive(1,flat_points);
pause(10); 


disp("Starting match ..."); 
%TODO: DO I NEED TO KEEP CALLING THIS OR CALL THIS ONCE AND INDEX ? 
%[rob_x_pos1, rob_y_pos1, rob_theta1, rob_x_pos2, rob_y_pos2, rob_theta2] = trackRobot(mypath, hsv_thresh_l1, hsv_thresh_r1, hsv_thresh_l2, hsv_thresh_r2, 1);
catch
% Close ROS network 
disp(" Something went wrong. Closing ros master node "); 
rosshutdown; 
end 