function ydot = modelBasic(t,y,pars,ton)

%disp(['time is ',num2str(t)]);
T= y(1);
E = y(2);
S = y(3);

lambda1 = pars(1); %mTOR sensitivity decay
lambda2 = pars(2); %TKI sensitivity decay
lambda3 = pars(3); %NIVO sensitivity decay 

alpha = pars(4); K     = pars(5); eta = pars(6); sigma = pars(7); 
rho   = pars(8); gamma = pars(9); mu  = pars(10); epsilon = pars(11);
delta = pars(12);

Rmtor = double(ton(1)>0);
Rmtki = double(ton(2)>0);
Rnivo = double(ton(3)>0);

beta   = 0.05*exp(-lambda1*(t-ton(1)));
phi    = exp(-lambda2*(t-ton(2))); %exp(-((t-ton(2))/lambda2^2));
%psi    = 250* exp(-lambda3*(t-ton(3)));
%psi    = exp(-lambda3*(t-ton(3)));
psi    =  0.5* exp(-lambda3*(t-ton(3))); %exp(-((t-ton(3))/lambda3^2)); % exp(-lambda3*(t-ton(3))); %

dT = (alpha - beta*Rmtor)*T*(1-(T/K)^(1-phi*Rmtki)) - eta*E*T*(1 - (S/(S+E)));
dE = sigma + (1+psi*Rnivo) * (rho*E*T/(gamma + T)) - mu*E*T - delta*E;
dS = rho*S*T/(gamma + T) - epsilon*S;
%dT = (alpha - beta*Rmtor)*T*(1 - (T/(K*(1-phi*Rmtki)))) - eta*E*T*(1 - (S/(S+E)));

ydot =  [double(y(1)>1)*dT; dE; dS]; %[double(y(1)>1)*dT; double(y(2)>1)*dE; double(y(3)>1)*dS];
