%subtest
rosinit; % TODO: remove this. Should happen outside 

while(1)
% Ros Subscriber: For testing purposes robot 1  
rob_sub1 = rossubscriber('/robot_pos1');
% Receive data from the subscriber as a ROS message. Specify a 10 second timeout.
sub_msg1 = receive(rob_sub1,100); % is this blocking ? asyc ? 
disp("rob1:"); 
disp(sub_msg1.X); 
disp(sub_msg1.Y); 
disp(sub_msg1.Theta);

% Ros Subscriber: For testing purposes robot 2  
rob_sub2 = rossubscriber('/robot_pos2');
% Receive data from the subscriber as a ROS message. Specify a 10 second timeout.
sub_msg2 = receive(rob_sub1,100); % is this blocking ? asyc ? 
disp("rob2:"); 
disp(sub_msg2.X); 
disp(sub_msg2.Y); 
disp(sub_msg2.Theta);
end