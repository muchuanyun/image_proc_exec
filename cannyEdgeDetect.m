function [finalImg] = cannyEdgeDetect(inImg,Tr)
%-------------------------------------------------------%
% This is a function that performs Canny Edge Detection.
% Inputs:     inImg ~ grayscale image
%                Tr ~ threshold
% Output: finalImag ~ edge image
% 
% coded by Yaping Sun on Dec 6, 2015.
%
%-------------------------------------------------------%

% Step1: smoothing
% use Gaussian kernel with std = 1.4
kernel = (1/159) * [2,4,5,4,2;4,9,12,9,4;5,12,15,12,5;4,9,12,9,4;2,4,5,4,2];
imFilt = imfilter(inImg,kernel,'conv');

% Step2: finding gradients
% using Sobel operators
kx = [-1,0,1;-2,0,2;-1,0,1];
ky = [-1,-2,-1;0,0,0;1,2,1];
Gx = imfilter(imFilt,kx,'conv'); 
Gy = imfilter(imFilt,ky,'conv');
magG = hypot(Gx,Gy);     % magnitude of gradient
oriTheta = atan2(Gy,Gx) * (180/pi);   % edge direction
Theta_mid = oriTheta < 0;
Theta = oriTheta + Theta_mid *180;    % make range (-180,180) to (0,180)

% Step3: non-maximum suppression (NMS)

% 1: round gradient direction
%   0 <- 0~22.5 & 157.5~180 
%   45 <- 22.5~67.5
%	90 <- 67.5~112.5
%	135 <- 112.5~157.5
discreteTheta = Theta;
discreteTheta(discreteTheta < 22.5 | discreteTheta > 157.5) = 0;
discreteTheta(discreteTheta > 22.5 & discreteTheta < 67.5) = 45;
discreteTheta(discreteTheta > 67.5 & discreteTheta < 112.5) = 90;
discreteTheta(discreteTheta > 112.5 & discreteTheta < 157.5) = 135;

% 2: compare edge strength
[h,v] = size(magG);
[ix,iy] = meshgrid(1:v,1:h);
mask = ones(h,v);

% direction 1: compare current pixel with west and east neighbors
idx = find(discreteTheta == 0 & ix >1 & ix < v);
idxA = idx-h;
idxB = idx+h;
mask(idx(find(magG(idx)<magG(idxA) | magG(idx)<magG(idxB))))=0;

% direction 2: compare current pixel with north and south neighbors
idx = find(discreteTheta == 90 & iy >1 & iy < h);
idxA = idx+1;
idxB = idx-1;
mask(idx(find(magG(idx)<magG(idxA) | magG(idx)<magG(idxB))))=0;

% direction 3: compare current pixel with northeast and southwest neighbors
idx = find(discreteTheta == 45 & ix > 1 & ix < v & iy > 1 & iy < h); idxA = idx-h+1;
idxB = idx+h-1;
mask(idx(find(magG(idx)<magG(idxA) | magG(idx)<magG(idxB))))=0;

% direction 4: compare current pixel with northwest and southeast neighbors
idx = find(discreteTheta == 135 & ix > 1 & ix < v & iy > 1 & iy < h); idxA = idx-h-1;
idxB = idx+h+1;
mask(idx(find(magG(idx)<magG(idxA) | magG(idx)<magG(idxB))))=0;

% gradient magnitude after NMS
nmsG = magG .* mask;
% Step4: thresholding
thrMask = nmsG >= Tr; finalImg = thrMask;

end
