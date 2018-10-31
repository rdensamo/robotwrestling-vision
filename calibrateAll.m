flat_points = ringCalibrate('/home/vader/matlabCode/data/noexp2.bag', 1);
thresh = colorCalibrate( '/home/vader/matlabCode/data/noexp2.bag', 1)
trackRobot( '/home/vader/matlabCode/data/noexp2.bag', thresh, 1)