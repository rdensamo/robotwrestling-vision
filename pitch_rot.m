%Ry
function [pitch] = pitch_rot(alpha)
pitch = [1 0 0; 
      0 cos(alpha) -sin(alpha); 
      0 sin(alpha) cos(alpha)]; 

end



