clc; clear
close all

cParams = load('Input.mat');

FEM = FEMsolver(cParams);

FEM.solve(cParams);

u = FEM.displacement;

sigma = FEM.stress;

