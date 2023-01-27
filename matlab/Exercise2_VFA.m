% Exercise 2: FLASH with Variable Flip Angle (VFA): Signal and Fit
% created: N. Weiskopf, MPI-CBS, Leipzig; 3/6/16


%% Typical values for T1, TR, TI, inversion efficiency at 3T
T1 = 900; % ms in gray matter 

%% Signal of FLASH acquisition for different TR, excitation flip angle, T1

%% different T1 times
TR = 20; % ms
alpha = 1:1:45; % deg
T1 = [900, 1600, 4000]; % ms for gray, white matter and CSF at 3T

for T1_nr=1:length(T1)
    for alpha_nr=1:length(alpha)
        signal(alpha_nr,T1_nr) = FLASH_signal(TR, alpha(alpha_nr), T1(T1_nr));
    end
end

figure, title('Different T1 times');
hold on
plot(alpha, signal, '.');
xlabel('alpha (deg)');
hold off


%% different TR
TR = [3, 8, 13, 18]; % ms
alpha = 1:1:45; % deg
T1 = 900; % ms for white matter at 3T

for TR_nr=1:length(TR)
    for alpha_nr=1:length(alpha)
        signal(alpha_nr,TR_nr) = FLASH_signal(TR(TR_nr), alpha(alpha_nr), T1);
    end
end

figure, title('Different TR [ms] at T1=900ms');
hold on
plot(alpha, signal, '.');
xlabel('alpha (deg)');
legend(num2str(TR'))
hold off


%% Estimate T1 from VFA using linear fit of transformed variables

TR = 20; % ms
alpha = 1:5:45; % deg
T1 = [900, 1600, 4000]; % ms for gray, white matter and CSF at 3T

for T1_nr=1:length(T1)
    for alpha_nr=1:length(alpha)
        signal(alpha_nr,T1_nr) = FLASH_signal(TR, alpha(alpha_nr), T1(T1_nr));
    end
end

T1_fit = FLASH_VFA_fit(signal(:,1), alpha', TR)
signal_fit = FLASH_signal(TR, 1:45, T1_fit);


figure, title('VFA estimate of T1: linearized version');
hold on
plot(signal(:,1)./tan(alpha/180*pi)',signal(:,1)./sin(alpha/180*pi)', '.');
plot(signal_fit./tan((1:45)/180*pi),signal_fit./sin((1:45)/180*pi), 'g');
xlabel('I/tan(alpha)');
ylabel('I/sin(alpha)');
hold off


figure, title('VFA estimate of T1');
hold on
plot(alpha, signal(:,1), '.');
plot(1:45, signal_fit, 'g');
xlabel('alpha (deg)');
hold off


