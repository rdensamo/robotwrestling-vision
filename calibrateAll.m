%mypath = 'C:/Users/rdens/Desktop/FALL 2018/CSE281/data/noexp2.bag';
mypath = '/home/vader/capstonedata/four_colorstat2.bag';
flat_points = ringCalibrate(mypath, 1);
[hsv_thresh_l1, hsv_thresh_r1, hsv_thresh_l2, hsv_thresh_r2,pcxyz] = colorCalibrate(mypath, 1);
pause(20); 
[rob_x_pos1, rob_y_pos1, rob_theta1, rob_x_pos2, rob_y_pos2, rob_theta2] = trackRobot(mypath, hsv_thresh_l1, hsv_thresh_r1, hsv_thresh_l2, hsv_thresh_r2, 1);



