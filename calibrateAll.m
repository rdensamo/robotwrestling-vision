flat_points = ringCalibrate('C:/Users/rdens/Desktop/FALL 2018/CSE281/data/noexp2.bag', 1);
[thresh_l, thresh_r] = colorCalibrate( 'C:/Users/rdens/Desktop/FALL 2018/CSE281/data/noexp2.bag', 1);
disp("thresh_l is "); 
disp(thresh_l); 
disp("thresh_r is "); 
disp(thresh_r); 
pause(20); 
trackRobot('C:/Users/rdens/Desktop/FALL 2018/CSE281/data/noexp2.bag', thresh_l, thresh_r, 1);