function [rho,theta,houghSpace] = houghTrans(img)
%-----------------------------------------------------%
% hough transform function:
% algorithm described in 
%     <Diginal Image Processing 3rd Edition>
%         by Gonzalez and Woods.
%     pp. 733-738.
%
% input: binary edge image
% output: rho ~ [minD:1:maxD]
%		  theta ~ [-90:1:89] degree
%		  houghSpace ~ matrix size [ numRho,numtheta ]
% 
% coded by Yaping Sun.
%-----------------------------------------------------%

[xMax,yMax] = size(img);

rhoLimit = norm([xMax-1 yMax-1]);
rho = (-ceil(rhoLimit):1:ceil(rhoLimit));
theta = (-90:1:89)*(pi/180);

numRho = numel(rho);
numTheta = numel(theta);
houghSpace = zeros(numRho,numTheta);

[xIdx,yIdx] = find(img);

numPoint = length(xIdx);
accumulator = zeros(numPoint,numTheta);

% pre-compute cosine and sine values
cosine = (0:xMax-1)'*cos(theta);
sine = (0:yMax-1)'*sin(theta);

% for each edge pixel, compute rho for all theta
accumulator((1:numPoint),:) = cosine(xIdx,:) + sine(yIdx,:);

for i = 1:numTheta
	houghSpace(:,i) = hist(accumulator(:,i),rho);
end

end

