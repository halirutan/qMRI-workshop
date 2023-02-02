% Exercise 1: Inversion Recovery (IR): Signal and Fit
% created: N. Weiskopf, MPI-CBS, Leipzig; 3/6/16

% It is assumed or on the qMRI/workshop/matlab path
addpath(genpath('./functions/'))

%% Typical values for T1, TR, TI, inversion efficiency at 3T
T1 = 900; % ms in gray matter 
TI = 1:100:5000; % ms
TR = 5*T1; % long TR experiment
rho = 1; % optimal inversion efficiency
m_0 = 1.0; % take initial magnetization as normalized to 1

%% Plot curves for different T1 times
signal=[t1_relaxation(TI, 900, 1.0); t1_relaxation(TI, 1600, 1.0); t1_relaxation(TI, 4000, 1.0)];
figure, plot(TI, signal, '.'); 
hold on
title('Different T1 [ms]');
legend(num2str([900 1600 4000]'))

% clean up workspace when moving forward
clearvars signal

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

[T1_long, I0_long] = IR_T1_fit(signal_tr_long, TI)
fit_signal_trl=I0_long*t1_relaxation(TI, T1_long, I0_long);

figure, title('Long TR');
hold on
plot(TI, signal_tr_long, '.');
plot(TI, fit_signal_trl, 'g');
hold off

[T1_short, I0_short] = IR_T1_fit(signal_tr_short, TI)
fit_signal_trs=I0_short*t1_relaxation(TI, T1_short, I0_short);

figure, title('Short TR');
hold on
plot(TI, signal_tr_short, '.');
plot(TI, fit_signal_trs, 'g');
hold off

% clean up workspace when moving forward
clearvars signal_tr_short signal_tr_long T1_short T1_long TR_short TR_long
clearvars m_ss_tr_short m_ss_tr_long I0_short I0_long
clearvars fit_signal_trs fit_signal_trl

%% Inversion Efficiency

%% effect of inversion efficiency

signal=t1_ir_rho(TI, T1, 1.0, m_0); % full inversion with rho = 1
figure, plot(TI, signal, '.'), title('Optimal inversion');

signal=t1_ir_rho(TI, T1, 0.75, m_0); % incomplete inversion with rho = 0.75
figure, plot(TI, signal, '.'), title('Incomplete inversion');

% clean up workspace when moving forward
clearvars signal

%% fitting long TR data with different inversion efficiency rho
% again we consider using the standard t1 relaxation model, i.e. 
% what happens if we dont account for the effect of ineffective inversions

rho_1 = 1.0;    % full inversion with rho = 1
signal_r1=t1_ir_rho(TI, T1, rho_1, m_0);
% fit
[T1_r1, I0_r1] = IR_T1_fit(signal_r1, TI)
fit_signal_r1=t1_relaxation(TI, T1_r1, I0_r1);

figure, title('Full inversion');
hold on
plot(TI, signal_r1, '.');
plot(TI, fit_signal_r1, 'g');
hold off

rho_2 = 0.75;   % incomplete inversion with rho = 0.75
signal_r2=t1_ir_rho(TI, T1, rho_2, m_0); 
% fit
[T1_r2, I0_r2] = IR_T1_fit(signal_r2, TI)
fit_signal_r2=t1_relaxation(TI, T1_r2, I0_r2);

figure, title('Incomplete inversion');
hold on
plot(TI, signal_r2, '.');
plot(TI, fit_signal_r2, 'g');
hold off

% clean up workspace when moving forward
clearvars fit_signal_r2 fit_signal_r1 I0_r2 I0_r1 rho_1 rho_2
clearvars signal_r2 signal_r1 T1_r2 T1_r1

%% fitting data and accounting for incomplete inversion

rho = 0.75; % incomplete inversion with rho = 0.75
signal_r=t1_ir_rho(TI, T1, rho, m_0);
% fit accounting for inefficient inversion
[T1_fit, rho_fit, I0_fit] = IR_rho_T1_fit(signal_r, TI)
fit_signal_r=t1_ir_rho(TI, T1_fit, rho_fit, I0_fit);

figure, title('Incomplete inversion but with rho fit');
hold on
plot(TI, signal_r, '.');
plot(TI, fit_signal_r, 'g');
hold off


%% dont forget to clear workspace when moving on
clear
clc
