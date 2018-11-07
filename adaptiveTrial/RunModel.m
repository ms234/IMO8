global ODE_TOL
global Lambda1
global tend

close all
Npatients = 1;
Lambda1 = 0;
t0 = 0;
tend = 200;
pars = load_global;
treatment_plan = 4;
load_treatment;
t_segments = treatment1.make();

T0 = 5E7; E0   = 3.2E5; S0 = E0;
Init = [T0 E0 S0];

figure('position',get(0,'Screensize'));
for n = 1:t_segments.N
    disp('---------------');
    tspan = t_segments.tspan{n}
    ton = t_segments.ton{n}
    
    options = odeset('RelTol',ODE_TOL,'AbsTol',ODE_TOL);
    sol = ode45(@modelBasic,tspan,Init,options,pars,tspan(1),ton);
    if(ton(1)>0)
        Lambda1 = min(Lambda1-pars(1)*(tspan(2)-tspan(1)),0);
    else
        Lambda1 = min(Lambda1+pars(1)*(tspan(2)-tspan(1)),0);
    end
    Init = deval(sol,tspan(2)); % values of the last point will be the init point for the next segment
    plotSolutionsNice(sol,Npatients,tend,T0,E0,S0,color); hold on;
end

figure(gcf);
subplot(2,4,1);
plotDrugApplicationWindow(t_segments);
subplot(2,4,2);
plotDrugApplicationWindow(t_segments);
subplot(2,4,5);
plotDrugApplicationWindow(t_segments);
subplot(2,4,6);
plotDrugApplicationWindow(t_segments);

saveas(gcf,['./figs/plot_plan_',num2str(treatment_plan),'.png']);
