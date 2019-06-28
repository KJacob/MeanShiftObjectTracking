function [R, box] = Probability( frame, tc, ts, kernel, ncolor )
%Probability Returns the probability distribution of with respect to
%epanechnikov kernel
%   arguments:
%   frame: The input frame. The frame must be color-reduced.
%   tc: The target centre
%   ts: The size of the target
%   kernel: The (epanechnikov) kernel

%Compute the histogram and return.

box = getBox(frame, tc, ts);
hist = linspace(0, 0, ncolor);

for i = 1:ncolor
    color = (box == i);
    
    weighed_color = kernel .* color;
    hist(i) = sum(weighed_color(:));
end

%Normalize
R = hist / sum(hist);
end

