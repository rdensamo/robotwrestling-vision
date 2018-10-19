%Rx 
function [yaw] = yaw_rot(beta) 
yaw  = [cos(beta) 0 sin(beta); 
        0 1 0; 
        -sin(beta) 0 cos(beta)]; 
end

