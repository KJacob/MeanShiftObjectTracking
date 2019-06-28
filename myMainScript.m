tic;
%% The object tracker


%% Authors Deepan M, Kurian Jacob

%Get the video details
[f_name, f_path] = uigetfile('*.*', 'Select a video');
f_name = sprintf('%s%s', f_path, f_name);

if isequal(f_name, 0)
    disp('Please enter a file name');
    exit(0);
end

R = startSequence(f_name);
%%
toc;