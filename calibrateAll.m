flat_points = ringCalibrate('/home/vader/matlabCode/data/noexp2.bag', 1);
thresh = colorCalibrate( '/home/vader/matlabCode/data/noexp2.bag', 1);
pause(20); 
trackRobot( '/home/vader/matlabCode/data/noexp2.bag', thresh, 1);