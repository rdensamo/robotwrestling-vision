% Ruth Densamo
% CSE 281 - Capstone
%rosbag record /camera/depth_registered/points
%rosrun rviz rviz
% rosbag play 2018-09-25-23-28-52.bag
%% Load a |rosbag|
% 
% function flat_ring(bagselect0, num_messages)
%%
filepath = fullfile(fileparts(which('ROSbagwithRVIZPointcloud')), 'data', 'oct5bag.bag');
bag = rosbag(filepath);
% Select Messages
%TODO: This is not the rigt mapping, need to subscribe to different topic
bagselect0 = select(bag, 'Topic', '/camera/depth_registered/points');
close all; 
for i=1:1
    msg = readMessages(bagselect0,i);
    
    pc = readXYZ(msg{1});
    
    
    bad = isnan(pc(:,1));
    pc = pc(~bad,:);
    
    
    z = pc(:,3);
    
    zfloor = median(z);
    
    %Robot is 7 cm tall approx
    robot_ind=(zfloor-z) > 0.04; %in meters
    
    robot_pts=pc(robot_ind,:);
    floor_pts=pc(~robot_ind, :);
    %
    %     plot3(floor_pts(:,1), floor_pts(:,2), floor_pts(:,3), 'm.');
    %     R hold on
    %     A = plot3(robot_pts(:,1), robot_pts(:,2), robot_pts(:,3), 'c.');
    %     hold on
    
    
    % x = floor_pts(:,1);
    %y = floor_pts(:,2);
    %z = floor_pts(:,3);
    %RANSAC
    ptCloud = pointCloud(pc);
    save('pointCloud.mat', 'ptCloud');
    load('pointCloud.mat')
    figure
    pcshow(ptCloud)
    xlabel('X(m)')
    ylabel('Y(m)')
    zlabel('Z(m)')
    title('Original Point Cloud')
    
    % Set the maximum point-to-plane distance (2cm) for plane fitting.
    maxDistance =  0.01;
    
    % Set the maximum point-to-plane distance (2cm) for plane fitting.
    referenceVector = [0,0,1];
    
    % Set the maximum angular distance to 5 degrees.
    maxAngularDistance = 4;
    
    % Detect the first plane, the table, and extract it from the point cloud
    tic;
%     [model1,inlierIndices,outlierIndices] = pcfitplane(ptCloud,...
%         maxDistance,referenceVector,maxAngularDistance);

     [model1,inlierIndices,outlierIndices] = pcfitplane(ptCloud,...
         maxDistance);

    toc;
    plane1 = select(ptCloud,inlierIndices);
    remainPtCloud = select(ptCloud,outlierIndices);
    
    % Plot the two planes and the remaining points
    figure
    pcshow(plane1) %use this as Ux, Uy, & UZ
    xlabel('X(m)')
    ylabel('Y(m)')
    zlabel('Z(m)')
    title('First Plane')
    hold off;
    % u = abs(surfnorm(plane1.Location));
    %  u_avg = mean(u);
    
    avg_normals = model1.Normal;
    %
    %      mean(abs(pcnormals(plane1,500)));
    Ux = avg_normals(1);
    Uy = avg_normals(2);
    Uz = avg_normals(3);
    %  %   Ux = ptCloud.Location(:,1);
    %  Uy = ptCloud.Location(:,2);
    % Uz = ptCloud.Location(:,3);
    
    % precalculated formulas
    alpha = asin(-Uy);
    beta = atan2(Ux,Uz);
    
    
    % Want to do rotation around z-axis (Z coordinates do not change)
    R =  yaw_rot(beta) * pitch_rot(alpha);
    flat_points = plane1.Location*R;
    
    figure
%     pcshow(flat_points)
%     title('Point Cloud2')
%     xlabel('X(m)')
%     ylabel('Y(m)')
%     zlabel('Z(m)')
    ptCloud2 = pointCloud(flat_points);
%     save('pointCloud2.mat', 'ptCloud2');
%     load('pointCloud2.mat')
%     figure;
    pcshow(ptCloud2);
   % hold off; 
   axis tight; 
   axis equal;
   xlabel('X(m)')
   ylabel('Y(m)')
   title('Flat Plane')
   hold off
% keyboard;    

    
   
   
%     axis equal
%     view(0,0)
    
    
    
%     top = select(bag, 'topic', '/camera/depth/image_raw');
%     msg2 = readMessages(top, 1);
%     top_img = readImage(msg2{1});
    pcrgb = readRGB(msg{1});
    top_img = reshape(pcrgb,640,480,3); 
    figure;
    imagesc(top_img); 
    % allows you to select the pollygone with the organge colors 
    
    mask = roipoly;
    % allows you to visualize selected region
    imagesc(mask); 
    image_red = top_img(:,:,1); 
    image_green = top_img(:,:,2); 
    image_blue = top_img(:,:,3); 
    
    red_img = image_red(mask); 
    green_img = image_green(mask); 
    blue_img = image_blue(mask); 
    
    figure;
    plot3(blue_img, red_img, green_img, '.'); 
    axis( [0 255 0 255 0 255]); 
    xlabel('red'); 
    ylabel('green'); 
    zlabel('blue'); 
    grid on; 
    
    histogram(red_img)
    histogram(blue_img)
    histogram(green_img)
    
    green_std = std(single(green_img)); 
    blue_std = std(single(blue_img)); 
    red_std = std(single(red_img)); 
    green_mean = mean(green_img);
    blue_mean = mean(blue_img);
    red_mean = mean(red_img); 
    
    red_low = (red_mean - (2 * red_std)); 
    red_high = (red_mean + (2 * red_std)); 
    green_low = (green_mean - (2 * green_std)); 
    green_high = (green_mean + (2 * green_std)); 
    blue_low = (blue_mean - (2 * blue_std)); 
    blue_high = (blue_mean + (2 * blue_std)); 

    image_ball = image_red >= red_low & image_red <= red_high & image_green >= green_low & image_green <= green_high & image_blue >= blue_low & image_blue <= blue_high;
    plot3(blue_img, red_img, green_img, '.'); 
    axis( [0 255 0 255 0 255]);
     
    imagesc(top_img); 
    find(image_ball);
    ind = find(image_ball);
    ind = 255;
   
    histogram(red_img)
    top_img(:,:,1) = image_red;
    imagesc(top_img); 
    [rows, cols] = ind2sub([640 480], ind);
    m_r = median(rows);
    m_c = median(cols);
    hold on; 
    h = plot(median(cols),median(rows),'b+', 'markersize', 20,'linewidth',2);  
    

    
    
    
    
    
end