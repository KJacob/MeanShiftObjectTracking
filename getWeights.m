function W = getWeights(window, p_dist, q_dist)
%arg: window: The window in which we are looking for the colors.

w_height = size(window, 1);
w_width = size(window, 2);
W = zeros([w_height, w_width]);

for i = 1:w_height
    for j = 1:w_width
        color = window(i, j);
        
        if color ==0
            continue;
        end
        
        W(i, j) = sqrt(q_dist(color) / p_dist(color));
    end
end
end