% Exercise 4: VFA PD map fit using T1 map regularization of In-Vivo FLASH Acquisition
% created: A. Mezer, HIJI, Jerusalem; 2/2/2023


%% we will use M0_to_PD github 
% the software can be download form here: https://github.com/MezerLab/M0_to_PD

clc 
close all
%% Load data
%Please make sure to cd to the location of /M0_to_PD-main/Example Data

%Load M0, Brain mask, segmentaion map and T1 map of in vivo VFA data

M0=readFileNifti('M0.nii.gz');  % M0
BM=readFileNifti('BM.nii.gz');  % BM
seg=readFileNifti('seg.nii.gz');% segmentation
T1=readFileNifti('T1.nii.gz');  % T1


%%
% Let's visualize the data
showMontage(T1.data(:,:,70:81));clim([0.4 4]);title('T1 in vivo')

showMontage(BM.data(:,:,70:81)); title('Brain mask');
showMontage(seg.data(:,:,70:81)); title('Segmentation mask');
showMontage(M0.data(:,:,70:81)); title('M0 in vivo');clim([0 4000]);

% Can you notice the coil gain bias on the M0 image?

%% close figures
close all
%% 
% set path to write the output 
outDir= % add the path to your output directory here


% %Please make sure you are still cd to the location of /M0_to_PD-main/Example Data
% running the PD anaysis may take 5-20 minutes.
%in case it take too long on your computer you can look on pre calculate results
tic;
M0_ToPD(outDir, 'T1.nii.gz', 'M0.nii.gz', 'BM.nii.gz','seg.nii.gz',1);
toc;

%% visualize the results

cd (outDir)
%load the outcome PD and coil Gain
PD=readFileNifti('PD.nii.gz');  % BM

%
% Let's visualize the outcome
showMontage(PD.data(:,:,70:81)); title('PD in vivo');clim([0 2]);

%% In case it takes to long we can  visualize the pre calculate results
 %Please make sure to cd to the location of /M0_to_PD-main/Example Data


PD=readFileNifti('WF_expected.nii.gz');  % BM
showMontage(PD.data(:,:,70:81)); title('PD in vivo');clim([0 2]);


%% Let's visualize the estimated Coil gain:
%M0=G.*PD therere he Gain is define as G=M0,/PD
 G=M0.data./PD.data;

showMontage(G(:,:,70:81)); title('Coil gain estimates');clim([0 4000]);

%% The last step in find the WF and MTV.
% in this step we need to calculate the water refernce. using an appropriate ventrical ROI
% we estimate the normailzation is this data to be 1.2 using a ventrical ROI.
WF=PD.data./1.2; 
%
%Let's visualize the WM map and the typical values in GM and WM
showMontage(WF(:,:,70:81)); title('WF in vivo');clim([0.1 1]);
figure;boxplot(WF(seg.data==1000),'symbol',''); title(['WM median value ' num2str(median(WF(seg.data==1000))) ]);ylim([0.4 1]);ylabel( 'WF') ;xlabel('WM')
figure;boxplot(WF(seg.data==2000),'symbol',''); title(['GM median value ' num2str(median(WF(seg.data==2000))) ]);ylim([0.4 1]);ylabel( 'WF') ;xlabel('GM')

% MTV is define as 1-WF
MTV=1-WF; 
%
%Let's visualize the MTV map and the typical values in GM and WM
showMontage(MTV(:,:,70:81)); title('MTV in vivo');clim([0 0.5]);
figure;boxplot(MTV(seg.data==1000),'symbol',''); title(['WM median value ' num2str(median(MTV(seg.data==1000))) ]);ylim([0 0.6]);ylabel( 'MTV') ;xlabel('WM')

figure;boxplot(MTV(seg.data==2000),'symbol',''); title(['GM median value ' num2str(median(MTV(seg.data==2000))) ]);ylim([0 0.6]);ylabel( 'MTV') ;xlabel('GM')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5


