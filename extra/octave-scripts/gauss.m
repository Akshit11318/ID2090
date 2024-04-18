% This function returns a 2D array containing a gaussian heat source
% This function should be called as follows:
% z = gauss(x0,y0)
% z will be a [50,50] array
% --------------- ID2090 -----------------------------------------
function z = gauss(x0, y0)
	x=[1:1:50];
	y=x;
	for i=1:size(x,2),
		for j=1:size(y,2),
			rsq = (x(i)-x0)*(x(i)-x0) + (y(j)-y0)*(y(j)-y0);
			z(i,j) = exp(-0.02*rsq);
		end
	end
