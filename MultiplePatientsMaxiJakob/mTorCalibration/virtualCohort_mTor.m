
clear all, close all, format compact, clc

global ODE_TOL

for tonset = 7%(7 * [1,4,8])

% close all 
pars = load_global;
ton = [0 0 0];
tmax1 = tonset;
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
% initP(initP<0) = 0; % remove out of bound
%initP(initP>1) = 1; % remove out of bound
parsAllPats =  ((1+ wiggleP * randn(size(initP))) .* initP);
parsAllPats(parsAllPats<0) = 0;

options = odeset('RelTol',ODE_TOL,'AbsTol',ODE_TOL); 

%-------------------Allow tumor to grow for 30 days-----------------------
tic, disp(' [[[ starting untreated tumor growth');
for pat = 1:Npatients
 parsThisPatient = pars;
 parsThisPatient(1:3) = parsAllPats(pat,:);
SOL1(pat) = ode45(@modelBasic,[0 tmax1],InitW(pat,:),options,parsThisPatient,ton);
InitSeq(pat,:) = SOL1(pat).y(:,end);
end
toc, disp('finished untreated tumor growth ]]]');

%------------------Add TKI ----------------------------------------------
newline = char(10);
tic, disp([newline,'[[[ START TREATMENT']);
for pat = 1:Npatients
     parsThisPatient = pars;
     parsThisPatient(1:3) = parsAllPats(pat,:);
    ton2{pat} = ton;
    ton2{pat}(1) = SOL1(pat).x(end);   
    SOL2(pat) = ode45(@modelBasic,[tmax1 tmax2],InitSeq(pat,:),options,parsThisPatient,ton2{pat});
end
toc, disp('STOP TREATMENT ]]]');


% concatenate solutions for each patient
for pat = 1:Npatients
SOL(pat).x = [SOL1(pat).x,SOL2(pat).x];
SOL(pat).y = [SOL1(pat).y,SOL2(pat).y];
end

%Init = SOL.y(:,end);

plotSolutionsNice(SOL,Npatients,tmax1,T0,E0,S0);

end

save('virtualTrial_mTor.mat','SOL')