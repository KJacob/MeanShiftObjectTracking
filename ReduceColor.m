function out = ReduceColor( frame, ncolor )
%REDUCECOLOR Reduce the color space to ncolor
%@args: frame: The input frame

out = rgb2ind(frame, colorcube(ncolor));
end

