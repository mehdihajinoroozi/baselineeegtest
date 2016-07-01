clear all
close all
addpath(genpath(pwd));          % Add to the path all subdirectories
clc

load feature_result
EEG_states = feature.sign;
channel_locations = feature.channel;
freq_range = feature.frequency;

% Time Comparison
% disp('Launching version 2: moviein - getframe - movie2avi');
% tic
% LAB_show_bandfeature2(EEG_states, channel_locations, freq_range, 1920,1080);
% toc
% disp('Launching version 3: avifile - addframe - close');
% tic
% LAB_show_bandfeature3(EEG_states, channel_locations, freq_range, 1920,1080);
% toc
disp('Launching version 4: VideoWriter - getframe - writeVideo');
tic
LAB_show_bandfeature4(EEG_states, channel_locations, freq_range, 1920,1080);
toc