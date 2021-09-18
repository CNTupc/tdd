clc; clear
close all

% load('Input.mat')
cParams.fileCase = load('Input.mat');

FEM = FEMsolver(cParams);

FEM.solve();

u = FEM.displacement

sigma = FEM

% totalDOF = FEMsolver.computeTotalDOF(numberNodes,nNodesinBar);
% 
% DOFconnectivitiesMatrix = FEMsolver.assembleDOFconnection(numberElements,nNodesinBar,DOFnode,nodalConnection);
% 
% elementsStiffMatrix = FEMsolver.assembleElementStiffMatrix(nNodesinBar,DOFnode,numberElements,nodeCoord,nodalConnection,materialMatrix,materialAssignMatrix);
% 
% globalStiffMatrix = FEMsolver.assembleGlobalStiffMatrix(totalDOF,numberElements,DOFnode,nNodesinBar,DOFconnectivitiesMatrix,elementsStiffMatrix);
% 
% externalForceinDOF = FEMsolver.allocateExternalForce(totalDOF,forceData);
% 
% [fixedDisplacementMatrix,fixedDOF,freeDOF] = FEMsolver.generateEquations(contour,totalDOF);
% 
% [DOFreactionMatrix,DOFdisplacementMatrix] = FEMsolver.solveSystem(globalStiffMatrix,externalForceinDOF,fixedDisplacementMatrix,fixedDOF,freeDOF,totalDOF);
% 
% stress = FEMsolver.computeStress(numberElements,nodalConnection,nodeCoord,DOFconnectivitiesMatrix,DOFdisplacementMatrix,nNodesinBar,DOFnode,materialMatrix,materialAssignMatrix);