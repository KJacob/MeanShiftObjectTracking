function [gridc, gridr] = getObjGrid( objsize )
%GETOBJGRID Returns a grid for the object
%   objsize: The size of the object


height = objsize(1);
width = objsize(2);

hh = round(height / 2);
hw = round(width / 2);

[gridc, gridr] = meshgrid(1:width, 1:height);

gridc = gridc - hw;
gridr = gridr - hh;
end

