sol_adapt = load('virtualTrial_adaptive.mat');
[osData_adapt,dum] = goKaplan(sol_adapt.SOL,14,25);
kmplot([osData_adapt;dum]')
hold on
sol_cts = load('virtualTrial_cts.mat');
[osData,dum] = goKaplan(sol_cts.SOL,14,25);
kmplot([osData;dum]')
hold off




T0 =  2.2E8; %3E8;% 10E7; %1.7569E8; %2.1214E8; %3E8;   % was 5E7
E0 =  0.02*T0; %3E6; %3.2E5; %0.0431E8; %0.0312E8; %3E6; % it was 3.2E5
S0 =  3*E0; %0.1000E8;%0.0943E8; %3* E0; % was 3*E0
sol_adapt = load('virtualTrial_adaptive.mat');
plotSolutionsNice(sol_adapt.SOL,25,14,T0,E0,S0,'blue')

clf
sol_cts = load('virtualTrial_cts.mat');
plotSolutionsNice(sol_cts.SOL,5,14,T0,E0,S0,'blue')
