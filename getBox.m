function outFrame = getBox(frame, centre, osize)
hh = floor(osize(1) / 2);
hw = floor(osize(2) / 2);

%Apply sentinels
padframe = padarray(frame, osize);
centre = centre + osize;

outFrame = padframe(centre(1) - hh : centre(1) + hh , centre(2) - hw : centre(2) + hw);
end