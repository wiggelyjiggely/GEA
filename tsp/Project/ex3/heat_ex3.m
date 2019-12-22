f = figure;
m = [    0.3870    0.2580    0.1780    0.2650    0.3160    0.3120    0.3630    0.4680    0.6990;
    0.2550    0.5210    0.6910    0.9430    1.1170    1.3670    1.5170    1.7580    1.9490;
    0.5720    1.1180    1.4190    1.9040    2.3140    2.7640    3.1720    3.7660    4.0770];

m = [ 23.0826   18.0529   17.3506   15.7522   15.7052   14.0294   14.8222   13.9865   14.0695
   22.5685   18.5014   16.4402   14.8980   14.9672   13.9236   13.1641   12.8023   12.8382];

xl = [90 80 70 60 50 40 30 20 10];
yl = [20 50 100];
x = [1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 ];
y = [9 8 7 6 5 4 3 2 1 9 8 7 6 5 4 3 2 1 ];

y = flip(y);
t=num2cell(m);

t = cellfun(@num2str, t, 'UniformOutput', false); % convert to string
yes = {'50';'100'};
names = {'0.90'; '0.80'; '0.70'; '0.60'; '0.50';'0.40'; '0.30'; '0.20'; '0.10'};
imagesc(m);
title('cpu time w.r.t elitism and population');

set(gca,'xtick',[1:9],'xticklabel',names);
set(gca,'ytick',[1:5],'yticklabel',yes);
xlabel('elitism');
ylabel('Population');
hold on
colormap(flipud(autumn))
%imshow(m);
text(y,x,t', 'HorizontalAlignment','center')
colorbar;
