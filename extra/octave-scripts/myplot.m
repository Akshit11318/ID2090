t=[1:1:50];
x=t;
y1=x.*sin(x/5);
ymin=min(y1);
ymax=max(y1);
y=(y1-ymin)*50/(ymax-ymin);

for i=1:1:size(t,2),
	x0=x(i);
	y0=y(i);
	z=gauss(x0,y0);
	pcolor(z);
	colorbar
	colormap hot
	shading interp
	tstring=sprintf("At t=%d (x0,y0)=(%f,%f)", i, x0, y0);
	title(tstring)
	fstring=sprintf("fig-%d.png",i);
	print(fstring,"-dpng")
end
