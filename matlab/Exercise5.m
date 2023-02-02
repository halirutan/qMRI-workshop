% Exercise 5: relaxivity fit using R1 and MTV maps  of In-Vivo VFA Acquisition
% created: A. Mezer, HIJI, Jerusalem; 2/2/2023

%% Clear workspace
clc 
close all
clear

%% we will use  MDM_toolbox github 
% the software can be download form here:
% https://github.com/MezerLab/MDM_toolbox
% put in the path to where you downloaded the repository and its
% dependencies (add all at once to path)
path_to_gits = '/data/u_jschmidt_software/matlab/workshop_resources/';
addpath(genpath(path_to_gits));

% set data path to examples of MDM git
data_path = fullfile(path_to_gits, 'MDM_toolbox/Example_data/');

%% Load data

R1_path=fullfile(data_path, 'R1_map_Wlin.nii.gz');
MTV_path=fullfile(data_path, 'TV_map.nii.gz');
Seg_path=fullfile(data_path,'segmentation.nii.gz');

%% Load data
R1=readFileNifti(R1_path);  % R1
seg=readFileNifti(Seg_path);% segmentation
MTV=readFileNifti(MTV_path);  % MTV

% Let's visualize the data
showMontage(R1.data(:,:,70:81));clim([0 2]);title('R1 in vivo')
showMontage(MTV.data(:,:,70:81)); title('MTV in vivo');clim([0 0.4]);
showMontage(seg.data(:,:,70:81)); title('Segmentation mask');colormap jet
% we have 5 ROIs on one hemisphere. Can you tell what are the ROIs?

%% Let's calculte the linear dependencies of R1 and MTV

% set path to write the output 
% add the path to your output directory here
outDir = './ex5_output/';
% if you keep it like that we get a new folder in the current dir
if ~exist(outDir,'dir')
    currentDir = pwd;
    mkdir(fullfile(currentDir, outDir))
end

example= MDM_run(R1_path, MTV_path, Seg_path, 1, ...
    outDir, {'Parameter_max',2,'Parameter_min',0,'Parameter_str','R1'});

% Please look on the figures and rank the 5 ROIs according to their R1,
% MTV and relaxivity.
