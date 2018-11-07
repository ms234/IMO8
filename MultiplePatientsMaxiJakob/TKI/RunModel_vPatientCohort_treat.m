
clear all, close all, format compact, clc

global ODE_TOL

for tonset = (7 * 1) %[1,4,8])

% close all 
pars = load_global;
ton = [0 0 0];
ton_2 = [0 0 0]; %second treatment time
tmax1 = tonset;
tmax2 = 200;
toff = [tmax1+28 tmax1+70];
tmax3 = tmax1+42;
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
initP(initP<0) = 0; % remove out of bound
%initP(initP>1) = 1; % remove out of bound
parsAllPats =  ((1+ wiggleP * randn(size(initP))) .* initP);

options = odeset('RelTol',ODE_TOL,'AbsTol',ODE_TOL); 

%-------------------Allow tumor to grow for 30 days-----------------------
tic, disp(' [[[ starting untreated tumor growth');
for pat = 1:Npatients
    parsThisPatient = pars;
    parsThisPatient(1:3) = parsAllPats(pat,:);
    SOL(pat) = ode45(@modelBasic,[0 tmax1],InitW(pat,:),options,parsThisPatient,ton,0);
    InitSeq(pat,:) = SOL(pat).y(:,end);
    
    NN(pat) = length(SOL(pat).x);
end
toc, disp('finished untreated tumor growth ]]]');

%--------------------------------Add TKI ----------------------------------
tic, disp([newline,'[[[ START TREATMENT']);

for pat = 1:Npatients
    tstar{pat} = 14;
    for cycnum = 1:4 %should be two
        InitSeq(pat,:) = SOL(pat).y(:,end);
        parsThisPatient = pars;
        parsThisPatient(1:3) = parsAllPats(pat,:);
        ton2{pat} = ton;
        ton2{pat}(2) = SOL(pat).x(end); %turn TKI on
        tstar{pat} = tstar{pat}-14;
        SOL2(pat) = ode45(@modelBasic,[SOL(pat).x(end) SOL(pat).x(end)+28],InitSeq(pat,:),options,parsThisPatient,ton2{pat},tstar{pat});
        tstar{pat} = SOL(pat).x(end)+28;
        InitSeq(pat,:) = SOL2(pat).y(:,end);

        SOL(pat).x = [SOL(pat).x,SOL2(pat).x];
        SOL(pat).y = [SOL(pat).y,SOL2(pat).y];
        
        ton2{pat} = ton;
        ton2{pat}(2) = 0; %turn mTOR off
        SOL2(pat) = ode45(@modelBasic,[SOL(pat).x(end) SOL(pat).x(end)+14],InitSeq(pat,:),options,parsThisPatient,ton2{pat},tstar{pat});

        SOL(pat).x = [SOL(pat).x,SOL2(pat).x];
        SOL(pat).y = [SOL(pat).y,SOL2(pat).y];
        
        %%%% Write as loop!
        InitSeq(pat,:) = SOL(pat).y(:,end);
        parsThisPatient = pars;
        parsThisPatient(1:3) = parsAllPats(pat,:);
        ton2{pat} = ton;
        ton2{pat}(2) = SOL(pat).x(end); %turn TKI on
        tstar{pat} = tstar{pat}-14;
%         tstar{pat} = 14; %Need to move back up along curve (decrease Tx efficacy since patient hasn't fully recovered from Tx)
        SOL2(pat) = ode45(@modelBasic,[SOL(pat).x(end) SOL(pat).x(end)+28],InitSeq(pat,:),options,parsThisPatient,ton2{pat},tstar{pat});
        tstar{pat} = SOL(pat).x(end)+28;
        InitSeq(pat,:) = SOL2(pat).y(:,end);

        SOL(pat).x = [SOL(pat).x,SOL2(pat).x];
        SOL(pat).y = [SOL(pat).y,SOL2(pat).y];
        
        ton2{pat} = ton;
        ton2{pat}(2) = 0; %turn TKI off
        SOL2(pat) = ode45(@modelBasic,[SOL(pat).x(end) SOL(pat).x(end)+14],InitSeq(pat,:),options,parsThisPatient,ton2{pat},tstar{pat});

        SOL(pat).x = [SOL(pat).x,SOL2(pat).x];
        SOL(pat).y = [SOL(pat).y,SOL2(pat).y];
    
    end
    
end
toc, disp('STOP TREATMENT ]]]');

plotSolutionsNice(SOL,Npatients,tmax1,T0,E0,S0,toff,tmax3);

end

save('lastDump.mat','SOL')