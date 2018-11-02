global ODE_TOL

% close all 
pars = load_global;
ton = [0 0 0];

T0 = 5E7; E0   = 3.2E5; S0 = E0;

Init = [T0 E0 S0];

options = odeset('RelTol',ODE_TOL,'AbsTol',ODE_TOL); 
%-------------------Allow tumor to grow for 30 days------------------------
sol = ode45(@modelBasic,[0 30],Init,options,pars,ton);

SOL = sol;

Init = SOL.y(:,end);

% %------------------------------Turn NIVO on--------------------------------
% ton(3) = sol.x(end);
% 
% sol = ode45(@modelBasic,[SOL.x(end) SOL.x(end)+14],Init,options,pars,ton);
% 
% SOL.x = [SOL.x sol.x];
% SOL.y = [SOL.y sol.y];
% 
% Init = SOL.y(:,end);
% 
% lambda3 = pars(3);
% psi = exp(-lambda3*(sol.x-ton(3)));
% 
% figure(4); hold on
% plot(sol.x,psi)

figure(1); hold on;
plot(SOL.x, SOL.y(2,:),'linewidth',6)
plot(SOL.x, SOL.y(3,:),'linewidth',6)
set(gca,'fontsize',30)
grid on
% legend('Effector','Suppressor')
title('Effector & Suppressor Cells')

figure(2); hold on
plot(SOL.x,SOL.y(1,:),'k','linewidth',6)
set(gca,'fontsize',30)
grid on
title('Tumor Cells')

figure(3); hold on
plot(SOL.x,SOL.y(3,:)./SOL.y(2,:))