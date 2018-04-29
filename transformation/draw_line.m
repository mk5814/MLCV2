function [] = draw_line(m,c,sz,offset,clr)
ylim = sz(1);
xlim = sz(2);

x = linspace(0,xlim,50);
y = m*x + c;

% Add offset so lines are displayed in right image
x = x(y>0 & y<ylim) + offset;
y = y(y>0 & y<ylim);

plot(x,y,clr,'LineWidth',1)

end