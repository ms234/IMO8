clear all, close all, format compact, clc
global ODE_TOL
global Lambda1
global tend
global treatment_plan

% close all 
pars = load_global;
ton = [0 0 0];
tmax2 = 200;
T0 =  2.2E8; %3E8;% 10E7; %1.7569E8; %2.1214E8; %3E8;   % was 5E7
E0 =  0.02*T0; %3E6; %3.2E5; %0.0431E8; %0.0312E8; %3E6; % it was 3.2E5
S0 =  3*E0; %0.1000E8;%0.0943E8; %3* E0; % was 3*E0

rng(1);
Npatients = 25; % define the number of patients

% DISTURB INITIAL CONDITIONS
wiggleC = 0.3; % how much do you want to disturb the initial conditions
InitG = repmat([T0 E0 S0],Npatients,1);
InitW =  (1+ wiggleC * randn(size(InitG))) .* InitG;

% DISTURB DRUG SENSITIVITY RECOVERY RATE
wiggleP = 0.75; % how much do you want to disturb the initial conditions
initP = repmat(pars(1:3)',Npatients,1);
parsAllPats =  ((1+ wiggleP * randn(size(initP))) .* initP);
parsAllPats(parsAllPats<0) = 0;

% options = odeset('RelTol',ODE_TOL,'AbsTol',ODE_TOL); 

Lambda1 = 0;
t0 = 0;
tend = 200;
treatment_plan = 1;
load_treatment;
t_segments = treatment1.make();

% T0 = 5E7; E0   = 3.2E5; S0 = E0;
Init = [T0 E0 S0];

% figure('position',get(0,'Screensize'));
for pat = 1:Npatients
    SOL(pat).x = [];
    SOL(pat).y = [];
    for n = 1:t_segments.N
%     disp('---------------');
        tspan = t_segments.tspan{n};
        ton = t_segments.ton{n};
        parsThisPatient = pars;
        parsThisPatient(1:3) = parsAllPats(pat,:);

        options = odeset('RelTol',ODE_TOL,'AbsTol',ODE_TOL);
        sol = ode45(@modelBasic,tspan,InitW(pat,:),options,parsThisPatient,tspan(1),ton);
        if(ton(1)>0)
            Lambda1 = min(Lambda1-pars(1)*(tspan(2)-tspan(1)),0);
        else
            Lambda1 = min(Lambda1+pars(1)*(tspan(2)-tspan(1)),0);
        end
        Init = deval(sol,tspan(2)); % values of the last point will be the init point for the next segment
        SOL(pat).x = [SOL(pat).x,sol.x(2:end)];
        SOL(pat).y = [SOL(pat).y,sol.y(:,2:end)];
    %     plotSolutionsNice(sol,Npatients,tend,T0,E0,S0,color); hold on;
    end
end

save('virtualTrial_adaptive.mat','SOL')
clear SOL

% Continuous
ton = [0 0 0];
Lambda1 = 0;
t0 = 0;
tend = 100;
clear treatment1
clear t_segments
treatment_plan = 4;
load_treatment;
t_segments = treatment1.make();

% T0 = 5E7; E0   = 3.2E5; S0 = E0;
Init = [T0 E0 S0];

% figure('position',get(0,'Screensize'));
for pat = 1:5
    SOL(pat).x = [];
    SOL(pat).y = [];
    for n = 1:t_segments.N
%     disp('---------------');
        tspan = t_segments.tspan{n};
        ton = t_segments.ton{n};
        parsThisPatient = pars;
        parsThisPatient(1:3) = parsAllPats(pat,:);

        options = odeset('RelTol',ODE_TOL,'AbsTol',ODE_TOL);
        sol = ode45(@modelBasic,tspan,InitW(pat,:),options,parsThisPatient,tspan(1),ton);
        if(ton(1)>0)
            Lambda1 = min(Lambda1-pars(1)*(tspan(2)-tspan(1)),0);
        else
            Lambda1 = min(Lambda1+pars(1)*(tspan(2)-tspan(1)),0);
        end
        Init = deval(sol,tspan(2)); % values of the last point will be the init point for the next segment
        SOL(pat).x = [SOL(pat).x,sol.x(2:end)];
        SOL(pat).y = [SOL(pat).y,sol.y(:,2:end)];
    %     plotSolutionsNice(sol,Npatients,tend,T0,E0,S0,color); hold on;
    end
end
save('virtualTrial_cts.mat','SOL')
