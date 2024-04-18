infile = fopen("f.txt");
n_lines = fskipl(infile,Inf);
frewind(infile);
lines=cell(n_lines,1);
for n=1:n_lines,
	lines{n}=fscanf(infile,'%s',1);
end

for i=1:n_lines,
	fields=strsplit(lines{i},",");
	fstring=sprintf("function y=myf(x); y=%s;", fields{1});
	eval(fstring);
	xmin=str2num(fields{2});
	xmax=str2num(fields{3});
	delta=(xmax-xmin)/10;
	x=[xmin:delta:xmax];
	y=myf(x);
	figure(i)
	p=plot(x,y)
	set(p,'linewidth',[2]);
	xlabel('value of x');
	ylabel('f(x)');
	tstr=sprintf("f(x)=%s", fields{1});
	title(tstr);
	fstr = sprintf("print -dpng f-%d.png", i);
	eval(fstr);
end
