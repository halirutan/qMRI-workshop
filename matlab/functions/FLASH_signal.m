function signal = FLASH_signal(TR, alpha, T1)
% signal = FLASH_signal(TR, alpha, T1)
% calculates signal of a FLASH/SPGR acquisition
% TR = repetition time
% alpha = excitation flip angle
% T1 = longitudinal relaxation time
%
% created: N. Weiskopf, MPI-CBS, Leipzig; 4/6/16

alpha = alpha/180*pi; % radians

signal = (1-exp(-TR./T1))./(1-cos(alpha).*exp(-TR./T1)).*sin(alpha);
