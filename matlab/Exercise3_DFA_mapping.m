% Exercise 3: Dual Flip Angle T1 Mapping of In-Vivo FLASH Acquisition
% created: N. Weiskopf, MPI-CBS, Leipzig; 3/6/16
%% clearing workspace
clear
clc

% It is assumed or on the qMRI/workshop/matlab path
addpath(genpath('./functions/'))

%% Load data
% provide the path to the data downloaded for the exercises,
% (https://owncloud.gwdg.de/index.php/s/HoY0Kl4aNetZbJA)
% if you copied to the current directory, this is sufficient
data_path = './T1_ex3_data/';

% set values and file names
TR = 25; %ms
alpha1 = 6; % deg
alpha2 = 21; % deg
P_PDw = fullfile(data_path, 'PDw.nii');
P_T1w = fullfile(data_path, 'T1w.nii');
P_B1map = fullfile(data_path, 'B1map.nii');

%% Fit per slice
% start spm for helper functions and for displaying results
spm fmri
FLASH_DFA_mapping(P_PDw, P_T1w, P_B1map, alpha1, alpha2, TR);

% add load in calculated data

% take a look in spm or your favorite .nii viewer
% eg: https://socr.umich.edu/HTML5/BrainViewer/

% or plot a montage (bit weird due to orientation)
plot_data = permute(estimated_T1_B1corr.data, [1 3 2]);
showMontage(plot_data(:,:,155:5:226));clim([0 4000]);title('T1 in vivo')

%% In case of trouble
% you can find the estimated t1 maps in the data folder under 'fallback/'
estimated_T1 = readFileNifti(fullfile(data_path, 'fallback', 'estimated_qt1.nii'));
estimated_T1_B1corr = readFileNifti(fullfile(data_path, 'fallback', 'estimated_qt1_b1-corrected.nii'));

