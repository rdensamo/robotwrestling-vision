function [med_r,med_c] = trackRobot(filepath, rgbVals, vid_name)
% TODO: ONCE YOU WRITE ROS SUBSCRIBER SWITCH BAG PARAMETER WITH TOPIC 
% rgbVals: first row is means, second row is stds (in rgb col order)
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
    v = VideoWriter('robot_tracking.avi');
    open(v);
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
        
 
        frame = getframe; 
        writeVideo(v,frame); 
 im = imagesc(top_img);
        image_red = top_img(:,:,1); 
        image_green = top_img(:,:,2); 
        image_blue = top_img(:,:,3); 
        
        red_low = (rgbVals(1,1) - (2 * rgbVals(2,1))); 
        red_high = (rgbVals(1,1) + (2 * rgbVals(2,1))); 
        green_low = (rgbVals(1,2) - (2 * rgbVals(2,2))); 
        green_high = (rgbVals(1,2) + (2 * rgbVals(2,2))); 
        blue_low = (rgbVals(1,3) - (2 * rgbVals(1,3))); 
        blue_high = (rgbVals(1,3) + (2 * rgbVals(1,3))); 
        
        image_ball = image_red >= red_low & image_red <= red_high & image_green >= green_low & image_green <= green_high & image_blue >= blue_low & image_blue <= blue_high;
        imagesc(top_img); 
        
        ind = find(image_ball);
        image_red(ind) = 1;
        top_img(:,:,1) = image_green;
        [rows, cols] = ind2sub([640 480], ind);
        
       
        m_r = median(rows);
        m_c = median(cols);
 

        if ( i ~= 1 )
            im = imagesc(top_img);
        end 

        hold on; 
        h = plot(median(cols),median(rows),'b+', 'markersize', 20,'linewidth',2); 
        frame = getframe; 
        writeVideo(v,frame);
        pause(.5); 
    end
    close(v);
end

% Do not want to record video
if(vid_name == 0)
    %empty for now 
end 

end
