function R = startSequence(videoFile)
% Determines the position of the object in each frame
%   videoFile: The input video
%   objcentre: The centre of object that we are trying to track
%   objsize: The bounding rectangle

ncolors = 8 * 8 * 8;
eps = 0.000001;

reader = VideoReader(videoFile);

%Comment this line if no offset is required
reader.CurrentTime = 180;

nrframes = ceil(reader.FrameRate * reader.Duration);
R = zeros(2, nrframes);

%Get the first frame and calculate the probabilty
frame = readFrame(reader);
imshow(frame);
rect = getrect;
rect = round(rect);

%Get the bounding rectangle
c = rect(1);
r = rect(2);
width = rect(3);
height = rect(4);

if rem(width, 2) == 0
    width = width - 1;
end

if rem(height, 2) == 0
    height = height - 1;
end

%Get the number of frames to track
n_track = input('Number of frames to track: ');

objcentre = round([r + height / 2, c + width / 2]);
objsize = [height, width];

y = objcentre;

frame = ReduceColor(frame, ncolors);
kernel = MyKernel(objsize);
q_dist = Probability(frame, objcentre, objsize, kernel, ncolors);

i = 1;
figure;

track_size = objsize;
iter_vec = zeros(n_track, 1);
bhat_vec = zeros(n_track, 1);

while (reader.hasFrame())
    %Determine the p-distribution
    origframe = readFrame(reader);
    frame = ReduceColor(origframe, ncolors);
    
    best_rho = 0;
    
    %If scaling is not required, replace with 0:0
    for scale = -10:10
        track_size_test = track_size + track_size * scale / 100;
        track_size_test = round(track_size_test);
        track_size_test = bitor(track_size_test, 1);
        
        kernel_new = MyKernel(track_size_test);
        iter = 0;
        
        while 1
            [p_dist, box] = Probability(frame, y, track_size_test, kernel_new, ncolors);
        
            rho = Bhattacharya(q_dist, p_dist);
            weights = getWeights(box, p_dist, q_dist);
        
            %Get the new location of the target
            [gridc, gridr] = getObjGrid(track_size_test);
        
            newc = gridc .* weights;
            newr = gridr .* weights;
        
            newc = sum(newc(:));
            newr = sum(newr(:));
        
            cdash = newc / sum(weights(:));
            rdash = newr / sum(weights(:));
        
            y1 = round(y + [rdash cdash]);
        
            while 1
                p_dist1 = Probability(frame, y1, track_size_test, kernel_new, ncolors);
            
                rho1 = Bhattacharya(q_dist, p_dist1);
            
                if rho1 < rho
                    y2 = round((y1 + y) * 0.5);
                else
                    break;
                end
            
                if norm(y2 - y1) < eps
                    break;
                end
            
                y1 = y2;
            end
        
            if norm(y1 - y) < eps
                break;
            end
        
            y = y1;
            iter = iter + 1;
        end
        
        if rho1 > best_rho
            best_rho = rho1;
            best_y = y;
            best_track_size = track_size_test;
            best_iter = iter;
        end
    end
    
    y = best_y;
    track_size = best_track_size;
    iter = best_iter;
    rho1 = best_rho;
    
    iter_vec(i) = iter;
    
    bhat_vec(i) = sqrt(1 - rho1);
    
    R(:, i) = y;
    
    shape_top = round(y(1) - track_size(1) / 2);
    shape_left = round(y(2) - track_size(2) / 2);
    
    origframe = insertShape(origframe, 'rectangle', [shape_left, shape_top, track_size(2), track_size(1)], 'LineWidth', 2);
    imshow (origframe);
    pause(0.005);
    i = i + 1;
    
    if i > n_track
        break;
    end
end

figure;
area(bhat_vec);
title('The distance values.');
xlabel('Frame');
ylabel('distance');

figure;
area(iter_vec);
title('The number of iterations.');
xlabel('Frame');
ylabel('Iterations');
end

