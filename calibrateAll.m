flat_points = ringCalibrate('C:/Users/rdens/Desktop/FALL 2018/CSE281/data/noexp2.bag', 1);
[thresh_l, thresh_r] = colorCalibrate( 'C:/Users/rdens/Desktop/FALL 2018/CSE281/data/noexp2.bag', 1);
pause(20); 
trackRobot('C:/Users/rdens/Desktop/FALL 2018/CSE281/data/noexp2.bag', thresh_l, thresh_r, 1);