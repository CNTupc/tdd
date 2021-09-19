clc; clear
close all

% load('Input.mat')
cParams = load('Input.mat');

FEM = FEMsolver(cParams);

FEM.solve();

u = FEM.displacement;

sigma = FEM.stress;

