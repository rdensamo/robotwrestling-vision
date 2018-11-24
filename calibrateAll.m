%mypath = 'C:/Users/rdens/Desktop/FALL 2018/CSE281/data/noexp2.bag';
mypath = '/home/vader/capstonedata/four_colorstat2.bag';
flat_points = ringCalibrate(mypath, 1);
[thresh_l, thresh_r, pcxyz] = colorCalibrate(mypath, 1);
%pause(20); 
%[rob_x_pos, rob_y_pos, rob_theta] = trackRobot(mypath, thresh_l, thresh_r, 1);



