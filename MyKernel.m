function K = MyKernel( ksize )
%MYKERNEL Create an epanechnikov kernel
% ksize: The size of the kernel

%To be verified

cr = ksize(1) / 2;
cc = ksize(2) / 2;

[gridc, gridr] = meshgrid(1:ksize(2), 1:ksize(1));

gridc = gridc - cc;
gridr = gridr - cr;

gridc = gridc / ksize(2);
gridr = gridr / ksize(1);

norm = sqrt(gridc .^ 2 + gridr .^ 2);

norm(norm > 1) = 0;

norm = 1 - norm;

%Should we normalize?
K = norm;
% 
% figure;
% surf(gridc, gridr, K);
% ret = fspecial('gaussian', ksize, max(ksize));
% figure;
% surf(gridc, gridr, ret);
end

