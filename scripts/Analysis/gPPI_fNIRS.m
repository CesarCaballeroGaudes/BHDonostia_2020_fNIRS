
clear; close all;clc

% Add scripts path
path_scripts = ('/Users/irenearrietasagredo/Desktop/BCBL/Brainhack/BrainHack_2020/BHDonostia_2020_fNIRS/scripts');
addpath(genpath(path_scripts))
% Load data
path_data = ('/Users/irenearrietasagredo/Desktop/BCBL/Brainhack/BrainHack_2020/BHDonostia_2020_fNIRS/data_files');
cd(path_data)
load('BH_data2.mat')

%% Objective

% To find PPI at different areas of the brain (Check out the literature on : https://github.com/brainhackorg/global2020/issues/37#issue-727168940)

% Y_i_H = seed_H * beta_1 + FW_H * beta_2 + BW_H * beta_3 + [seed_n *
% FW]_H * beta_4 + [seed_n * BW]_H * beta_5 + e

% Objective day 1
% 1 - without deconvolution

% Objective day 2
% 2 - with deconvolution

% Objective 3. Interpretation of results, play with deconvolution
% parameters, preprocessing parameters, seed choice parameters...
% Final design matrix


% Solve GLM
%%

% How to start? What do we already have?

% FW = yes 
% BW = yes 
% HRF = yes

% seed_H = Which to choose? A priori one from borja's article?

% seed_n = NO, need to devonvolute. I can first just do it without
% deconvolution.



%% Check visually how the signals look like

% Understand data. If any doubts, we can go through tomorrow in 'person'.

sf = data.sf;
time = linspace(0, length(data.OD)/sf/60, length(data.OD))


%% Equation variables: FW and BW. One way of doing it, without taking into account the motion artifacts and global signal regression.
% FW
FW = data.s(:, 2)


% BW
BW = data.s(:, 6)


sf = data.sf;
time = linspace(0, length(data.OD)/sf/60, length(data.OD))
xlabel('Minutes')

% Plot FW and BW
figure; 
plot(time, FW, 'blue'); hold on;
plot(time, BW, 'red'); hold on;
xlabel('Minutes')
ylabel('Activation yes/no')
title('FW and BW psychological vectors')

%%  Create HRF

tau = 0;
sigma = 6;

trange = [-5 25];

% Takes the nT (inverse to sf) and creates a vector of ones which
% introduces in the exponential for creating the cannonical HRF.

t = data.time;
nT = length(t);
dt = t(2)-t(1);
nPre = round(trange(1)/dt);
nPost = round(trange(2)/dt);
nTpts = size(data.OD,1);
tHRF = (1*nPre*dt:dt:nPost*dt)';
ntHRF=length(tHRF);  

tbasis = (exp(1)*(tHRF-tau).^2/sigma^2) .* exp( -(tHRF-tau).^2/sigma^2 );

% Make zero baseline values
lstNeg = find(tHRF<0);
tbasis(lstNeg,1) = 0;

plot(tHRF, tbasis)
xlabel('Seconds')
ylabel('Amplitude, normalized')
title('Canonical HRF')
%% 
%% Seed signal
 
% Choose seed, by channel.

% Define seed signal
seed = 19; % choose seed channel

%% Filtering

% Without filtering by the global signal regression

% y_conc_hbo = data.conc(:, 1, :);
% y_conc_hbR = data.conc(:, 2, :);

% This is oxy
figure; 
plot(data.conc(:, 1, seed), 'blue');

% This is deoxy
% plot(data.conc(:, 2, seed), 'red'); hold on;

% Filtering by global signal regression
figure;
yhbo = data.GSR_oxy(:, seed);

plot(yhbo,'red')

yhbr = data.GSR_deoxy(:, seed);

% Keep only good time_points
yhbo_clean = yhbo(lstInc)

figure; 
plot(yhbo_clean); hold on; plot(yhbo, 'red')
%%  Create FW_H and BW_H (task dependent regressors)
% Take out artifacts and create FW_H and BW_H

% One way to do it
% FW_H = conv(FW, tbasis)
% BW_H = conv(BW, tbasis)

[FW_H, BW_H, lstInc] = glm_model(data);


%% PPI_FW & PPI_BW [seed_n * FW]_H

PPI_FW = conv(yhbo_clean,  FW_H, 'same') % Oxy hemoglobin
PPI_BW = conv(yhbo_clean, BW_H) 

figure; 
plot(PPI_FW)

%% 
% Create psychophysiological interaction terms


% 1 - without deconvolution


% 2 - with deconvolution


% Final design matrix


% Solve GLM












