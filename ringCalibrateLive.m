function [flat_points] = ringCalibrateLive(option)
%ringCalibrate: Calibrates the ring live rather than making a rosbag file
%   This function extracts the floor from a point cloud and flattens it 
%   returns the flatpoints and the flat point cloud object  
%   Run this code once you have already positioned the camera to desired
%   postion. Gets only one frame. 

close all; 
topic = '/camera/depth_registered/points';
ring_sub = rossubscriber(topic);
% Receive data from the subscriber as a ROS message. Specify a 10 second timeout.
ring_msg1 = receive(ring_sub,100); 

% Extracts XYZ points from PointCloud2 object 
pc = readXYZ(ring_msg1);
% Removing bad points 
bad = isnan(pc(:,1));
pc = pc(~bad,:);    

% Plots the data is this argument is 1  
if (option == 1)
    ptCloud = pointCloud(pc);
    save('pointCloud.mat', 'ptCloud');
    load('pointCloud.mat')
    figure
    pcshow(ptCloud)
    xlabel('X(m)')
    ylabel('Y(m)')
    zlabel('Z(m)')
    title('Original Point Cloud')
end

% Use RANSAC to fit a plane to the ring 

% Set the maximum point-to-plane distance (2cm) for plane fitting.
maxDistance =  0.01;
% Detect the first plane, the table, and extract it from the point cloud
[model1,inlierIndices,outlierIndices] = pcfitplane(ptCloud,...
         maxDistance);
plane1 = select(ptCloud,inlierIndices);
remainPtCloud = select(ptCloud,outlierIndices);


% Plots the data is this argument is 1  
if (option == 1)
    figure
    pcshow(plane1) %use this as Ux, Uy, & UZ
    xlabel('X(m)')
    ylabel('Y(m)')
    zlabel('Z(m)')
    title('First Plane')
    hold off;
end

% Do rotational Matrix on first plane 

% Get normal from RANSAC 
avg_normals = model1.Normal;
Ux = avg_normals(1);
Uy = avg_normals(2);
Uz = avg_normals(3);

% precalculated formulas for doing rotational matrix 
alpha = asin(-Uy);
beta = atan2(Ux,Uz);

% Want to do rotation around z-axis (Z coordinates do not change)
R =  yaw_rot(beta) * pitch_rot(alpha);
flat_points = plane1.Location*R;

% Plots the data is this argument is 1  
if (option == 1)
    figure
    ptCloud2 = pointCloud(flat_points);
    pcshow(ptCloud2);
    axis tight; 
    axis equal;
    xlabel('X(m)')
    ylabel('Y(m)')
    title('Flat Plane')
    hold off;
end

end

