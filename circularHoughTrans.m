function [CHT] = circularHoughTrans(img,rRange,G,Gx,Gy)
% circular hough transform function
% Input: img ~ binary image (edge image)
%		 rRange ~ radius values
%		 G ~ gradient magnitude
%		 Gx ~ gradient image in x-direction
%		 Gy ~ gradient image in y-direction
% Output: CHT ~ CHT accumulation matrix

[nrows,ncols] = size(img);
rNum = length(rRange);

CHT = zeros(nrows,ncols);

ptIdx = find(img);
[yIdx,xIdx] = ind2sub([nrows ncols],ptIdx);
coeff_x = reshape((Gx ./ G),1,[]);
coeff_y = reshape((Gy ./ G),1,[]);
co_x = coeff_x(ptIdx);
co_y = coeff_y(ptIdx);

for i = 1:rNum
    space = zeros(nrows,ncols);
	R = rRange(i);
        xc = round(xIdx' - co_x.*R);
        yc = round(yIdx' - co_y.*R);
        xc = xc .* (xc>=1) .* (xc <= ncols).* (yc>=1) .* (yc <= nrows);
        yc = yc .* (yc>=1) .* (yc <= nrows).* (xc>=1) .* (xc <= ncols);
        xc = xc(xc ~= 0);
        yc = yc(yc ~= 0);
        centerIdx = sub2ind([nrows ncols],yc,xc);
        space(centerIdx) = space(centerIdx) + 1;
              
		CHT = CHT + space; 
end

end
