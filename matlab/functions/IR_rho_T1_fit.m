function [T1, rho, I0] = IR_rho_T1_fit(signal, TI)
% function [T1, rho, I0] = IR_T1_fit(signal, TI)
% Estimate T1 from IR signal with different TI
% assumes TR > 5*T1
% signal = signal of inversion recovery acquisition
% TI = inversion time; vector with multiple TI
% output
% T1 = longitudinal relaxation time
% rho = inversion efficiency
% I0 = initial signal
% 
% created: N. Weiskopf, MPI-CBS, Leipzig; 3/6/16

% set up fminsearch Nelder-Mead fit
options = optimset('fzero');
options = optimset(options,'MaxFunEvals',10000);
options = optimset(options,'MaxIter',10000);
options = optimset(options,'Display','iter');

fixpar = {signal, TI}; % data to fit and TI values
% initial guess: [signal with shortest TI, rho (inversion efficiency) = 1, T1 = 1000ms]
init_val = [abs(signal(1)), 1, 1000]; 
% run Nelder-Mead fit
x = fminsearch(@(x) diff_IR(x,fixpar),init_val,options);
T1 = x(3);
rho = x(2);
I0 = x(1);

function sqdiff = diff_IR(varpar, fixpar)
% calculate the objective function for fit of modulus IR data
% squared difference between fitted IR signal and measured signal

T1 = varpar(3);
rho = varpar(2);
I0 = varpar(1);
TI = fixpar{2};
dat = fixpar{1};

fit_signal = t1_ir_rho(TI, T1, rho, I0);
sqdiff = sum((abs(dat) - abs(fit_signal)).^2);

return

