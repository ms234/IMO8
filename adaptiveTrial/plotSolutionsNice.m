function plotSolutionsNice(SOL,Npatients,tmax1,T0,E0,S0,color)
colz = winter(Npatients); % prepare color palette
PlotAlpha = 0.5; % transparency for lines
PlotWidth = 2;

tic, disp('starting to plot');
for pat = 1:Npatients
    currentSol = SOL(pat);
subplot(2,4,1)
hold on; % PLOT TUMOR
% p = plot(currentSol.x, log10(currentSol.y(1,:)),'linewidth',PlotWidth,'Color',[colz(pat,:),PlotAlpha]);
p = plot(currentSol.x, log10(currentSol.y(1,:)),'linewidth',PlotWidth,'Color',color);
hold off;
ylim([0,10]);
subplot(2,4,2)
hold on; % PLOT EFFECTOR
% p = plot(currentSol.x, log10(currentSol.y(2,:)),'linewidth',PlotWidth,'Color',[colz(pat,:),PlotAlpha]);
p = plot(currentSol.x, log10(currentSol.y(2,:)),'linewidth',PlotWidth,'Color',color);
hold off;
ylim([0,10]);
subplot(2,4,5)
hold on; % PLOT SUPPRESSOR
% p = plot(currentSol.x, log10(currentSol.y(3,:)),'linewidth',PlotWidth,'Color',[colz(pat,:),PlotAlpha]);
p = plot(currentSol.x, log10(currentSol.y(3,:)),'linewidth',PlotWidth,'Color',color);
hold off;
ylim([0,10]);
subplot(2,4,6)
hold on; % PLOT S/E RATIO
% p = plot(currentSol.x, (currentSol.y(3,:))./(currentSol.y(2,:)),'linewidth',PlotWidth,'Color',[colz(pat,:),PlotAlpha]);
p = plot(currentSol.x, (currentSol.y(3,:))./(currentSol.y(2,:)),'linewidth',PlotWidth,'Color',color);
hold off;
ylim([0,10]);
subplot(2,4,[3,4,7,8])
hold on; % PLOT T,E,S
s = scatter3(log10(currentSol.y(1,1)), log10(currentSol.y(2,1)),log10(currentSol.y(3,1)),50,colz(pat,:),'filled');
% p = plot3(log10(currentSol.y(1,:)), log10(currentSol.y(2,:)),log10(currentSol.y(3,:)),'linewidth',3,'Color',[colz(pat,:),1]);
p = plot3(log10(currentSol.y(1,:)), log10(currentSol.y(2,:)),log10(currentSol.y(3,:)),'linewidth',3,'Color',color);
hold off;
% subplot(2,3,6)
% hold on; % PLOT T/T0 vs SER
%  p = plot(log10(currentSol.y(1,:)/T0), log10(currentSol.y(2,:)/E0),'linewidth',1,'Color',[colz(pat,:),0.5]);
% hold off;
end
toc, disp('finished plotting');

% add decorations
titles = {'tumor cells','immune effector cells (good)','immune suppressor cells (bad)','S-E-ratio','log10 (T vs E vs S)'};
ccc = 1;
for i=[1,2,5,6,10]
    set(gca,'fontsize',15)
if i<10
subplot(2,4,i)
hold on
% draw line
yy = ylim;
plot([tmax1 tmax1],[0 yy(2)],'k-','LineWidth',1.5);
title(titles{ccc});
xlabel('time (d)');
ylabel('log10 cell number')
else
subplot(2,4,[3,4,7,8])
hold on
title(titles{ccc});
view([31,40])
xlabel('log10 T');ylabel('log10 E');zlabel('log10 S');
end
ccc = ccc+1;
grid on
axis square tight
hold off
end

subplot(2,4,6);
ylabel('ratio');

set(gcf,'Color','w');
drawnow
end

