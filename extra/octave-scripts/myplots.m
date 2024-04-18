x = [1:0.1:5];
for c = 1:40
	f = figure();
	c1 = c*0.1;
	y = myf(x,c);
	p = plot(x,y)
	set(p, 'linewidth', [2]);
	axis([1 5 -5 5])
	xlabel('value of x')
	ylabel('value of y')
	tstr = sprintf("plot at c=%d",c)
	title(tstr)
	fname = sprintf("myplot-%d.png",c);
	print (f, fname, "-dpng")
end

