% Exercise 1: Inversion Recovery (IR): Signal and Fit
% created: N. Weiskopf, MPI-CBS, Leipzig; 3/6/16

addpath(genpath('./functions/'))

%% Typical values for T1, TR, TI, inversion efficiency at 3T
T1 = 900; % ms in gray matter 
TI = 1:100:5000; % ms
TR = 5*T1; % long TR experiment
rho = 1; % optimal inversion efficiency

%% Plot curves for different T1 times
signal=[t1_relaxation(TI, 900, 5*4000); t1_relaxation(TI, 1600, 5*4000); t1_relaxation(TI, 4000, 5*4000)];
figure, plot(TI, signal, '.'); 
hold on
title('Different T1 [ms]');
legend(num2str([900 1600 4000]'))

%% Repetition time TR changes
%% effect of TR
TR_short = 800;
TR_long = 10000;

% calculating effect of insufficient relaxation on available magnetization
m_ss_tr_long = calculate_steady_state_magnetization(T1, TR_long, 1.0);
m_ss_tr_short = calculate_steady_state_magnetization(T1, TR_short, 1.0);

% plot
signal_tr_long=t1_ir_rho(TI, T1, 1.0, m_ss_tr_long);
figure, plot(TI, signal_tr_long, '.'), title('Long TR');

signal_tr_short=t1_ir_rho(TI, T1, 1.0, m_ss_tr_short);
figure, plot(TI, signal_tr_short, '.'), title('Short TR');


%% fitting short and long TR data with standard T1 relaxation model

[T1_long, I0_long] = IR_T1_fit(signal, TI)
fit_signal=I0_long*IR_TR_signal(TI, T1_long, 1000000);

figure, title('Long TR');
hold on
plot(TI, signal, '.');
plot(TI, fit_signal, 'g');
hold off

signal=IR_TR_signal(TI, T1, 1*T1);
[T1_short, I0_short] = IR_T1_fit(signal, TI)
fit_signal=I0_short*IR_TR_signal(TI, T1_short, 1000000);

figure, title('Short TR');
hold on
plot(TI, signal, '.');
plot(TI, fit_signal, 'g');
hold off





%% Inversion Efficiency

%% effect of inversion efficiency
signal=IR_rho_signal(TI, T1, 1.0); % full inversion with rho = 1
figure, plot(TI, signal, '.'), title('Optimal inversion');

signal=IR_rho_signal(TI, T1, 0.8); % incomplete inversion with rho = 0.8
figure, plot(TI, signal, '.'), title('Incomplete inversion');


%% fitting long TR data with different inversion efficiency rho
signal=IR_rho_signal(TI, T1, 1.0); % full inversion with rho = 1
[T1_full, I0_full] = IR_T1_fit(signal, TI)
fit_signal=I0_full*IR_TR_signal(TI, T1_full, 1000000);

figure, title('Full inversion');
hold on
plot(TI, signal, '.');
plot(TI, fit_signal, 'g');
hold off

signal=IR_rho_signal(TI, T1, 0.8); % incomplete inversion with rho = 0.8
[T1_inc, I0_inc] = IR_T1_fit(signal, TI)
fit_signal=I0_inc*IR_TR_signal(TI, T1_inc, 1000000);

figure, title('Incomplete inversion');
hold on
plot(TI, signal, '.');
plot(TI, fit_signal, 'g');
hold off



%% fitting data and accounting for incomplete inversion

signal=IR_rho_signal(TI, T1, 0.8); % incomplete inversion with rho = 0.8
[T1_adj, rho_adj, I0_adj] = IR_rho_T1_fit(signal, TI)
fit_signal=I0_adj*IR_rho_signal(TI, T1_adj, rho_adj);

figure, title('Incomplete inversion but with rho fit');
hold on
plot(TI, signal, '.');
plot(TI, fit_signal, 'g');
hold off


