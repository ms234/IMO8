function pars = load_global

global ODE_TOL
ODE_TOL = 1e-8;

lambda1 = 0.15;
lambda2 = 5E-3;%0.005;
lambda3 = 0.005; %3.1464; %  0.4102; %0.4; %0.4;

alpha = 0.18 * 0.2;  K = 1E13; % 1/(2E-9) *1E4; 
eta   = 1.1E-8; %1.101E-7; 
sigma = 1.3E4; rho = 0.1245;   gamma = 2.019E7; mu = 3.422E-10; % rho/(gamma+K) *10; %
epsilon = 0.5*rho*K/(gamma+K);  delta = 0.0412; %0.04; %0.01412;

pars = [lambda1 lambda2 lambda3 alpha K eta sigma rho gamma mu epsilon delta]';
