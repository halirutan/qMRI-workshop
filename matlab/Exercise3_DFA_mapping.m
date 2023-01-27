% Exercise 3: Dual Flip Angle T1 Mapping of In-Vivo FLASH Acquisition
% created: N. Weiskopf, MPI-CBS, Leipzig; 3/6/16

% start spm for helper functions and for displaying results
spm fmri

cwd = pwd;
cd .\data % change to data directory

TR = 25; %ms
alpha1 = 6; % deg
alpha2 = 21; % deg
P_PDw = 'PDw.nii';
P_T1w = 'T1w.nii';
P_B1map = 'B1map.nii';

FLASH_DFA_mapping(P_PDw, P_T1w, P_B1map, alpha1, alpha2, TR);

cd(cwd); % change back to scripts directory