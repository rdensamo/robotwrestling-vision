%mypath = 'C:/Users/rdens/Desktop/FALL 2018/CSE281/data/noexp2.bag';
%mypath = '/home/vader/capstonedata/four_colormov3.bag';
%mypath = '/home/vader/capstonedata/newcol.bag';

% Selecting the floor for green this time. Need to test this in Steps Lobby
%mypath = '/home/vader/capstonedata/newcol2best.bag'; 
%Testing in steps 1 one of the robots died also red has no target
%mypath = '/home/vader/capstonedata/steps1dead.bag'; 
% debugging red color that has no target in steps - target appears
%mypath = '/home/vader/capstonedata/steps2still1rob.bag';
% changed red color with yellow in steps (works but lighting could change)
mypath = '/home/vader/capstonedata/steps3mov.bag';
flat_points = ringCalibrate(mypath, 1);
pause(20); 
[hsv_thresh_l1, hsv_thresh_r1, hsv_thresh_l2, hsv_thresh_r2,pcxyz] = colorCalibrate(mypath, 1);
pause(20); 
[rob_x_pos1, rob_y_pos1, rob_theta1, rob_x_pos2, rob_y_pos2, rob_theta2] = trackRobot(mypath, hsv_thresh_l1, hsv_thresh_r1, hsv_thresh_l2, hsv_thresh_r2, 1);



