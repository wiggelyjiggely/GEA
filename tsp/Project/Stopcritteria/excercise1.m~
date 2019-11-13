% Prepare matlab and load the data.
clear;clc;
run1 = [1, 3, 5, 7, 6, 2, 5, 9, 9, 9];
run2 = [1, 3, 6, 6, 6, 6, 7, 7, 7, 7];

% Calculate the efficiencies.
E11 = e1(run1);
E12 = e1(run2);
E21 = e2(run1);
E22 = e2(run2);
E31 = e3(run1);
E32 = e3(run2);

% Generate a plot.
x = 1:1:10;
subplot(3,2,1);
plot(x,E11);
title('E1, Run1');
subplot(3,2,2);
plot(x,E12);
title('E1, Run2');
subplot(3,2,3);
plot(x,E21);
title('E2, Run1');
subplot(3,2,4);
plot(x,E22);
title('E2, Run2');
subplot(3,2,5);
plot(x,E31);
title('E3, Run1');
subplot(3,2,6);
plot(x,E32);
title('E3, Run2');

% 