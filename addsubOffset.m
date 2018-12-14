function [rel_pos] = addsubOffset(raw_ctr, rob_pos)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if (raw_ctr > 0)
    rel_pos = rob_pos - raw_ctr;
else
    rel_pos = rob_pos + raw_ctr;
end

end

