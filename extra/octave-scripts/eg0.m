% script to show simple plot in 2D
x=[1:1:10];
y=x.*x;
graphics_toolkit("qt");
figure(1);
plot(x,y,'bo-');
x1=xlabel('x axis');
y1=ylabel('y axis');
t1=title('y=x^2');
h=gca;
set(h,'fontsize',16);
set(h,'linewidth',2);
c1=get(h,'children');
set(c1,'linewidth',2);
set(x1,'fontsize',16);
set(y1,'fontsize',16);
set(t1,'fontsize',16);
print -dpng Example1.png
