%subtest
rosinit; % TODO: remove this. Should happen outside 
% Need to have rosbag on replay so it loops and keeps publishing for
% testing 
while(1)
% Ros Subscriber: For testing purposes robot 1  
rob_sub1 = rossubscriber('/camera/depth_registered/points');
% Receive data from the subscriber as a ROS message. Specify a 10 second timeout.
sub_msg1 = receive(rob_sub1,100); % is this blocking ? asyc ? 
disp("main rob:"); 
pc = readXYZ(sub_msg1);
disp(pc); 
% disp(sub_msg1.X); 
% disp(sub_msg1.Y); 
% disp(sub_msg1.Theta);

end