flat_points = ringCalibrate('/home/vader/matlabCode/data/orangeM.bag', 1);
result = colorCalibrate( '/home/vader/matlabCode/data/orangeM.bag', 1)
trackRobot( '/home/vader/matlabCode/data/orangeM.bag', result, 1)