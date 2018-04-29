clear all
close all
files = dir('results/figs');
files = files(3:end);
for i = 1:length(files)
    name = sprintf('%s//%s',files(i).folder,files(i).name);
    fig = openfig(name);
    newname = split(files(i).name,'.');
    newname = newname{1};
    saveas(gcf,sprintf('results/figs/%s.eps',newname),'epsc');
    close all
end