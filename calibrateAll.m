flat_points = ringCalibrate('C:/Users/rdens/Desktop/FALL 2018/CSE281/robotwrestling-vision/data/noexp2.bag', 1);
thresh = colorCalibrate( 'C:/Users/rdens/Desktop/FALL 2018/CSE281/robotwrestling-vision/data/noexp2.bag', 1);
pause(20); 
trackRobot( 'C:/Users/rdens/Desktop/FALL 2018/CSE281/robotwrestling-vision/data/noexp2.bag', thresh, 1);