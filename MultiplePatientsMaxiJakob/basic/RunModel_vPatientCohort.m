
clear all, close all, clc

global ODE_TOL

% close all 
rng(1)
pars = load_global;
ton = [0 0 0];
tmax = 500;
T0 = 5E7; E0 = 3.2E5; S0 = E0;

Npatients = 50; % define the number of patients
wiggle = 0.33; % how much do you want to disturb the initial conditions
Init = repmat([T0 E0 S0],Npatients,1);
InitW =  (1+ wiggle * randn(size(Init))) .* Init;

options = odeset('RelTol',ODE_TOL,'AbsTol',ODE_TOL); 

%-------------------Allow tumor to grow for 30 days-----------------------
tic, disp('starting to solve the model');
parfor pat = 1:Npatients
SOL(pat) = ode45(@modelBasic,[0 tmax],InitW(pat,:),options,pars,ton);
end
%------------------Add NIVO ----------------------------------------------

toc, disp('finished to solve the model');
%%

%Init = SOL.y(:,end);

figure(1);

colz = winter(Npatients); % prepare color palette
PlotAlpha = 0.1; % transparency for lines
PlotWidth = 2;

tic, disp('starting to plot');
for pat = 1:Npatients
    currentSol = SOL(pat);
subplot(2,2,1)
hold on; % PLOT TUMOR
 p = plot(currentSol.x, (currentSol.y(1,:)),'linewidth',PlotWidth,'Color',[colz(pat,:),PlotAlpha]);
hold off;
subplot(2,2,2)
hold on; % PLOT EFFECTOR
 p = plot(currentSol.x, (currentSol.y(2,:)),'linewidth',PlotWidth,'Color',[colz(pat,:),PlotAlpha]);
hold off;
subplot(2,2,3)
hold on; % PLOT SUPPRESSOR
 p = plot(currentSol.x, (currentSol.y(3,:)),'linewidth',PlotWidth,'Color',[colz(pat,:),PlotAlpha]);
hold off;
subplot(2,2,4)
hold on; % PLOT S/E RATIO
 p = plot(currentSol.x, (currentSol.y(3,:))./(currentSol.y(2,:)),'linewidth',PlotWidth,'Color',[colz(pat,:),PlotAlpha]);
hold off;
end
toc, disp('finished plotting');

% add decorations
titles = {' T',' E','S','S/E'};
for i=1:4
subplot(2,2,i)
set(gca,'fontsize',20)
title(titles{i});
grid on
axis square tight
end
%%
% Plot phase space
figure(2)
clf
tic, disp('starting to plot');
responsePal = {'red','green'};
for pat = 1:Npatients
    currentSol = SOL(pat);
hold on; % PLOT EFFECTOR
 p = plot(currentSol.y(1,:)/T0, (currentSol.y(3,:)./currentSol.y(2,:)),'linewidth',PlotWidth,'Color',[responsePal((currentSol.y(1,end)>T0)+1),PlotAlpha]);
hold off;
end
ylim([0,3])
xlim([0,11])
xlabel('T/T0')
ylabel('NLR')
toc, disp('finished plotting');
