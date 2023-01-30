function T1 = FLASH_VFA_fit(signal, alpha, TR)
% function T1 = FLASH_VFA_fit(signal, alpha, TR)
% Estimates T1 from VFA FLASH acquisition
% signal = signal vector for different excitation flip angles alpha
% alpha = vector with flip angles
% TR = fixed repetition time for all acquisitions
%
% created: N. Weiskopf, MPI-CBS, Leipzig; 3/6/16

% transform signal according to Gupta, JMR 1977
alpha = alpha/180*pi;
y = signal./sin(alpha);
x = signal./tan(alpha);

% build design matrix with regressors according to y = beta1*x + beta2*1
X = [ones(length(x), 1), x];
% Solve for regression coefficients/betas
beta = X\y;

% Estimate T1 from slope
slope = beta(2);
T1=1/(-log(slope)/TR);



