% Exercise 3: Dual Flip Angle T1 Mapping of In-Vivo FLASH Acquisition
% created: N. Weiskopf, MPI-CBS, Leipzig; 3/6/16

% It is assumed or on the qMRI/workshop/matlab path
addpath(genpath('./functions/'))

% provide the path to the data downloaded for the exercises,
% if you copied to the current directory, this is sufficient
data_path = './data/';

% set values and file names
TR = 25; %ms
alpha1 = 6; % deg
alpha2 = 21; % deg
P_PDw = fullfile(data_path, 'PDw.nii');
P_T1w = fullfile(data_path, 'T1w.nii');
P_B1map = fullfile(data_path, 'B1map.nii');

% start spm for helper functions and for displaying results
spm fmri
FLASH_DFA_mapping(P_PDw, P_T1w, P_B1map, alpha1, alpha2, TR);

%% Pause here if you want to take a look at the data in spm

disp('better take a look before clearing ! :) or you need to run again')


%% dont forget to clear workspace when moving on
clear
clc