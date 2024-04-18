function c = myhat(x0, y0)
x=[1:1:20];
y=x;
for i=1:size(x,2),
  for j=1:size(y,2),
    z(i,j)=exp(-0.1*((i-x0)*(i-x0)+(j-y0)*(j-y0)));
  end
end
pcolor(z)
shading interp
s=sprintf("x0,y0 = %f, %f", x0, y0)
title(s)
f=sprintf("img-%f-%f.png", x0, y0)
print(f,"-dpng")
