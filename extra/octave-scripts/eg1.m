function c = myhat(x0, y0)
x=[1:1:20];
y=x;
x0=max(x)/2;
y0=max(y)/2;
for i=1:size(x,2),
  for j=1:size(y,2),
    z(i,j)=exp(-0.1*((i-x0)*(i-x0)+(j-y0)*(j-y0)));
  end
end

