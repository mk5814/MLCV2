function [] = draw_line(m,c,sz, offset)
ylim = sz(1);
xlim = sz(2);

x = linspace(0,xlim,50);
y = m*x + c;

x = x(y>0 & y<ylim) + offset;
y = y(y>0 & y<ylim);

plot(x,y,'g')

end