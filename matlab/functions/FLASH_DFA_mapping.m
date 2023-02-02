function FLASH_DFA_mapping(P_PDw, P_T1w, P_B1map, alpha1, alpha2, TR)
% FLASH_DFA_mapping(P_PDw, P_T1w, P_B1_map, alpha1, alpha2, TR)
% Estimates T1 from dual flip angle FLASH acquisition
% P_PDw, P_T1w, P_B1_map: file names of PDw, T1w images and the B1 map.
% alpha1, alpha2: flip angle of PDw and T1w images
% TR: fixed repetition time of acquisitions
% output: two T1 maps; one apparent T1 map and one corrected for B1+
% inhomogeneities
%
% created: N. Weiskopf, MPI-CBS, Leipzig; 3/6/16

alpha1 = alpha1/180*pi;
alpha2 = alpha2/180*pi;
thresh = 60; % signal threshold for calculating T1 (based on 800um 3T example data)

% read data
V = spm_vol(P_PDw);
Y_PDw = spm_read_vols(V);

V = spm_vol(P_T1w);
Y_T1w = spm_read_vols(V);

V = spm_vol(P_B1map);
Y_B1map = spm_read_vols(V)/100; % B1 map is scaled in p.u. of nominal flip angle

T1=zeros(size(Y_PDw));

for x_nr=1:size(Y_PDw,1)
    disp(['Slice: ', num2str(x_nr)]);
    for y_nr=1:size(Y_PDw,2)
        for z_nr=1:size(Y_PDw,3)
            if abs(Y_PDw(x_nr,y_nr,z_nr))>thresh && abs(Y_T1w(x_nr,y_nr,z_nr))>thresh && Y_B1map(x_nr,y_nr,z_nr)>0.3 % sufficient SNR and B1 field
                x=[Y_PDw(x_nr,y_nr,z_nr)/tan(alpha1), Y_T1w(x_nr,y_nr,z_nr)/tan(alpha2)];
                y=[Y_PDw(x_nr,y_nr,z_nr)/sin(alpha1), Y_T1w(x_nr,y_nr,z_nr)/sin(alpha2)];
                
                % build design matrix with regressors according to y = beta1*x + beta2*1
                X = [ones(length(x), 1), x'];
                beta = X\y';
                % Estimate T1 from slope
                T1(x_nr,y_nr,z_nr)=beta(2);
                M0(x_nr,y_nr,z_nr)=beta(1);

                x=[Y_PDw(x_nr,y_nr,z_nr)/tan(alpha1*Y_B1map(x_nr,y_nr,z_nr)), Y_T1w(x_nr,y_nr,z_nr)/tan(alpha2*Y_B1map(x_nr,y_nr,z_nr))];
                y=[Y_PDw(x_nr,y_nr,z_nr)/sin(alpha1*Y_B1map(x_nr,y_nr,z_nr)), Y_T1w(x_nr,y_nr,z_nr)/sin(alpha2*Y_B1map(x_nr,y_nr,z_nr))];
                
                % build design matrix with regressors according to y = beta1*x + beta2*1
                X = [ones(length(x), 1), x'];
                beta = X\y';
                % Estimate T1 from slope
                T1_corr(x_nr,y_nr,z_nr)=beta(2);
                M0_corr(x_nr,y_nr,z_nr)=beta(1);
                             
            else % SNR too low
                T1(x_nr,y_nr,z_nr)=0;
                T1_corr(x_nr,y_nr,z_nr)=0;
                M0(x_nr,y_nr,z_nr)=0;
                M0_corr(x_nr,y_nr,z_nr)=0;
            end
        end
    end
end

% calculate the T1 and M0 from the linear regression coefficients
T1=1./(-log(T1)/TR);
T1_corr=1./(-log(T1_corr)/TR);

M0=M0./(1-exp(-TR./T1));
M0_corr=M0_corr./(1-exp(-TR./T1_corr));

% write T1 map
V_temp = spm_vol(P_PDw);
V_temp.desc = 'VFA FLASH T1, uncorrected (ms)';
V_temp.fname = 'VFA_T1_uncorrected.img';
V_temp = spm_write_vol(V_temp, T1);

V_temp = spm_vol(P_PDw);
V_temp.desc = 'VFA FLASH T1, B1 corrected (ms)';
V_temp.fname = 'VFA_T1_B1_corrected.img';
V_temp = spm_write_vol(V_temp, T1_corr);

