
clear all, close all, format compact, clc

global ODE_TOL

for tonset = (30)%(7 * [1,4,16])
% tonset = 30;
% close all 
pars = load_global;
ton = [0 0 0];
tmax1 = tonset;
tmax2 = 1.5*365;
% T0 = 1.5E8;   % was 5E7
% E0 = 2E7; % it was 3.2E5
% S0 = 3* E0; % was 3*E0
T0 = 1.5E9;   % was 5E7
E0 = 2E6; % it was 3.2E5
S0 = 3* E0; % was 3*E0


rng(1);
Npatients = 25; % define the number of patients
wiggle = 0.25; % how much do you want to disturb the initial conditions
InitG = repmat([T0 E0 S0],Npatients,1);
% InitW =  InitG;
InitW =  (1+ wiggle * randn(size(InitG))) .* InitG;

options = odeset('RelTol',ODE_TOL,'AbsTol',ODE_TOL); 

%-------------------Control with no treatment-----------------------
tic, disp(' [[[ starting untreated tumor growth');
for pat = 1:Npatients
SOL_Ctrl(pat) = ode45(@modelBasic,[0 tmax2],InitW(pat,:),options,pars,[0,0,0]);
end
toc, disp('finished untreated tumor growth ]]]');

%-------------------Allow tumor to grow for 30 days-----------------------
tic, disp(' [[[ starting untreated tumor growth');
for pat = 1:Npatients
SOL1(pat) = ode45(@modelBasic,[0 tmax1],InitW(pat,:),options,pars,ton);
InitSeq(pat,:) = SOL1(pat).y(:,end);
end
toc, disp('finished untreated tumor growth ]]]');

NN = length(SOL1(pat).x);
%------------------Add TKI ----------------------------------------------
newline = char(10)
tic, disp([newline,'[[[ START TKI']);
for pat = 1:Npatients
ton2{pat} = ton;
ton2{pat}(2) = SOL1(pat).x(end);   
SOL2(pat) = ode45(@modelBasic,[tmax1 tmax2],InitSeq(pat,:),options,pars,ton2{pat});
end
toc, disp('STOP TKI ]]]');

% concatenate solutions for each patient
for pat = 1:Npatients
SOL(pat).x = [SOL1(pat).x,SOL2(pat).x(2:end)];
SOL(pat).y = [SOL1(pat).y,SOL2(pat).y(:,2:end)];
end

%Init = SOL.y(:,end);

figure;

colz = winter(Npatients); % prepare color palette
PlotAlpha = 0.2; % transparency for lines
PlotWidth = 2;

tic, disp('starting to plot');
for pat = 1:Npatients
    currentSol = SOL(pat);
    currentSol_Ctrl = SOL_Ctrl(pat);
subplot(2,3,1)
hold on; % PLOT TUMOR
 p = plot(currentSol.x, (currentSol.y(1,:)),'linewidth',PlotWidth,'Color',[colz(pat,:),PlotAlpha]);
%  p = plot(currentSol_Ctrl.x, log10(currentSol_Ctrl.y(1,:)),'linewidth',PlotWidth,'Color',[colz(pat,:),PlotAlpha],'Linestyle','--');
hold off;
subplot(2,3,2)
hold on; % PLOT EFFECTOR
 p = plot(currentSol.x, (currentSol.y(2,:)),'linewidth',PlotWidth,'Color',[colz(pat,:),PlotAlpha]);
hold off;
subplot(2,3,3)
hold on; % PLOT SUPPRESSOR
 p = plot(currentSol.x, (currentSol.y(3,:)),'linewidth',PlotWidth,'Color',[colz(pat,:),PlotAlpha]);
hold off;
subplot(2,3,4)
hold on; % PLOT S/E RATIO
 p = plot(currentSol.x, (currentSol.y(3,:))./(currentSol.y(2,:)),'linewidth',PlotWidth,'Color',[colz(pat,:),PlotAlpha]);
hold off;
subplot(2,3,5)
% hold on; % PLOT T/T0 vs SER
%  p = plot(currentSol.y(1,:)/T0, (currentSol.y(3,:))./(currentSol.y(2,:)),'linewidth',1,'Color',[colz(pat,:),1]);
% hold off;
hold on; % PLOT T,E,S
s = scatter3(log10(currentSol.y(1,1)/T0), log10(currentSol.y(2,1)/E0),log10(currentSol.y(3,1)/S0),20,colz(pat,:),'filled');
p = plot3(log10(currentSol.y(1,:)/T0), log10(currentSol.y(2,:)/E0),log10(currentSol.y(3,:)/S0),'linewidth',1,'Color',[colz(pat,:),1]);
hold off;
subplot(2,3,6)
hold on; % PLOT T/T0 vs SER
 p = plot(log10(currentSol.y(1,:)/T0), log10(currentSol.y(2,:)/E0),'linewidth',1,'Color',[colz(pat,:),0.5]);
hold off;
end
toc, disp('finished plotting');

% add decorations
titles = {'log10 T','log10 E','log10 S','S/E','T/T0 vs SER','T/T0 vs E/E0'};
for i=1:6
subplot(2,3,i)
hold on
set(gca,'fontsize',20)
yy = ylim;
% draw line
if i<5
plot([tmax1 tmax1],[0 yy(2)],'k-','LineWidth',1.5);
end
title(titles{i});
grid on
axis square tight
hold off
end

lambda1 = 0.18;
lambda2 = 0.001;
lambda3 = 0.4; %0294

alpha = 0.18 * 0.2;  K = 1/(2E-9) *1E4; eta   = 0;%1.1E-8; %1.101E-7; 
sigma = 1.3E4; rho = 0.1245;   gamma = 2.019E7; mu = 3.422E-10; % rho/(gamma+K) *10; %
epsilon = 0.99*rho*K/(gamma+K);  delta = 0.0412; %0.04; %0.01412;

phi1 = 3;
phi = exp(-lambda2*(SOL(pat).x(NN+1:end)-ton(2)));
% y1 = alpha*SOL(pat).y(1,1:NN).*(1-(SOL(pat).y(1,1:NN)/K));
y1 = (1-(SOL(pat).y(1,1:NN)/K));
y2 = (1-(SOL(pat).y(1,NN+1:end)/K).^(1-phi));

figure(10); hold on; plot(SOL(pat).x(1:NN),y1,SOL(pat).x(NN+1:end),y2)

drawnow
% saveas(gcf,['TKI_ton_',num2str(tonset), '_phi1e-10_l3_',num2str(pars(2)),'.png'])
end

save('patientRecord_TKI.mat','SOL')