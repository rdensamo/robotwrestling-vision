
rosinit; % Connect to ROS network 
try
disp("Flattening Ring Plane. Make sure camera and robots are ready and still."); 
pause(5); 
flat_points = ringCalibrateLive(1); 
pause(10); 

disp("Calibrate and segment ring center");   % Might want to do this without robots in the frame 
[x_raw, y_raw] = calibrateRingCenterLive(1, flat_points); 
rosshutdown
catch
rosshutdown
end 