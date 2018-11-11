function [x_pos, y_pos, theta] = trackRobot(filepath, thresh_l, thresh_r, vid_name)
% TODO: ONCE YOU WRITE ROS SUBSCRIBER SWITCH BAG PARAMETER WITH TOPIC
% returns the position and orientation of the robot: x_pos, y_pos and theta 
% trackRobot Summary of this function goes here
%   if vid_name = 1 records a movie
%   Detailed explanation goes here


% filepath = '/home/vader/matlabCode/data/oct5bag.bag'

% Gets ros bag that has the depth and color data (topic)
bag = rosbag(filepath);
bagselect0 = select(bag, 'Topic', '/camera/depth_registered/points');
close all;

% Want to record video
% TODO: Install VLC to view this video format
if(vid_name == 1)
    pause on;  %enable pause function
    v = VideoWriter('robot_tracking_matt_alien.avi');
    open(v);
end

for i=1:bagselect0.NumMessages
    msg = readMessages(bagselect0,i);
    pcrgb = readRGB(msg{1});
    top_img = reshape(pcrgb,640,480,3);
    
    if ( i == 1)
        f = figure;
        im = imagesc(top_img);
        set(gca, 'nextplot', 'replacechild');
        set(gcf, 'Renderer', 'zbuffer');
    end
    
    if (vid_name == 1)
        frame = getframe;
        writeVideo(v,frame);
    end
    
    im = imagesc(top_img);
    image_red = top_img(:,:,1);
    image_green = top_img(:,:,2);
    image_blue = top_img(:,:,3);
    
    
    image_ball = image_red >= thresh(1) & image_red <= thresh(2) & ...
        image_green >= thresh(3) & image_green <= thresh(4) & ...
        image_blue >= thresh(5) & image_blue <= thresh(6);
    image_ball = imclose(image_ball, ones(3));
    
    ind = find(image_ball);
    image_red(ind) = 0;
    top_img(:,:,1) = image_red;
    [rows, cols] = ind2sub([640 480], ind);
    imagesc(top_img);
    
    m_r = median(rows);
    m_c = median(cols);
    
    
    if ( i ~= 1 )
        im = imagesc(top_img);
    end
    
    hold on;
    h = plot(median(cols),median(rows),'b+', 'markersize', 20,'linewidth',2);
    drawnow;
end

if(vid_name == 1)
    close(v);
end




