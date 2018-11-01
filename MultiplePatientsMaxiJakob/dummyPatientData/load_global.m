function pars = load_global

global ODE_TOL
ODE_TOL = 1e-8;

lambda1 = 0.18;
lambda2 = 0.15;
lambda3 = 0.4; %0294

alpha = 0.18 * 0.2;  K = 1/(2E-9) *1E4; eta   = 1.1E-8; %1.101E-7; 
sigma = 1.3E4; rho = 0.1245;   gamma = 2.019E7; mu = 3.422E-10; % rho/(gamma+K) *10; %
epsilon = 0.99*rho*K/(gamma+K);  delta = 0.0412; %0.04; %0.01412;


pars = [lambda1 lambda2 lambda3 alpha K eta sigma rho gamma mu epsilon delta]';
