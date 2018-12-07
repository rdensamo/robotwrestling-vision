
%rosinit; % Connect to ROS network 
try
disp("Flattening Ring Plane. Make sure camera and robots are ready and still."); 
pause(5); 
flat_points = ringCalibrateLive(1); 

[x_raw_ctr, y_raw_ctr] = calibrateRingCenterLive(1, flat_points); 
% rosshutdown
catch
% rosshutdown
end 