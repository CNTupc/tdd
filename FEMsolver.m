classdef FEMsolver < handle
    %FEMSOLVER code refactoring
    
    properties (Access = public)
        displacement
        stress
    end
    
    properties (Access = private)
        totalDOF
        connectivityMatrix
        StiffnessMatrix
        externalForceConditions
    end
    
     properties (Access = private)
        Area
        contourConditions
        Dimension
        DOFconnectionMatrix
        DOFperNode
        forceData
        materialAssignMatrix
        materialMatrix
        nNodesperBar
        nodalConnectionMatrix
        nodeCoordinatesMatrix
        numberofElements
        numberofNodes
        rho
        youngModulus
    end
    
    methods (Access = public)
%         function obj = FEMsolver(cParams)
%             obj.init(cParams);
%         end
        
        function solve(obj)
            obj.init(cParams);
            obj.computeMesh();
            obj.computeStiffnessMatrix();
            obj.computeConditions();
            obj.solveProblem();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.Area = cParams.Area;
            obj.contourConditions = cParams.contourConditions;
            obj.Dimension = cParams.Dimension;
            obj.DOFconnectionMatrix = cParams.DOFconnectionMatrix;
            obj.DOFperNode = cParams.DOFperNode;
            obj.forceData = cParams.forceData;
            obj.materialAssignMatrix = cParams.materialAssignMatrix;
            obj.materialMatrix = cParams.materialMatrix;
            obj.nNodesperBar = cParams.nNodesperBar;
            obj.nodalConnectionMatrix = cParams.nodalConnectionMatrix;
            obj.nodeCoordinatesMatrix = cParams.nodeCoordinatesMatrix;
            obj.numberofElements = cParams.numberofElements;
            obj.numberofNodes = cParams.numberofNodes;
            obj.rho = cParams.rho;
            obj.youngModulus = cParams.youngModulus;
        end
        
        function computeMesh(obj)
            nDOF = TotalDOFComputer(cParams);
            nDOF.compute();
            obj.totalDOF = nDOF.totalDOF;
            connectivity = ConnectivityMatrixComputer(cParams);
            connectivity.compute();
            obj.connectivityMatrix = connectivity.connectivityMatrix;
        end
                
        function computeStiffnessMatrix(obj)
            cParams.totalDOF = obj.totalDOF;
            cParams.connectivityMatrix = obj.connectivityMatrix;
            stiffness = StiffnessMatrixComputer(cParams);
            stiffness.compute();
            obj.StiffnessMatrix = stiffness.K;
        end
        
        function computeConditions(obj)
            force = ExternalForceAllocator(cParams);
            force.compute();
            obj.externalForceConditions = force.externalForceConditions;
        end
        
        function solveProblem(obj)
            cParams.externalForceConditions = obj.externalForceConditions;
             = EquationSolver(cParams);
            
        end
        
    end
    
    methods (Static)
            
        
        
        function [fixedDisplacementMatrix,fixedDOF,freeDOF] = generateEquations(contour,totalDOF)
            for ii = 1:length(contour)
                fixedDisplacementMatrix(ii,1) = contour(ii,3);
                fixedDOF(ii,1) = contour(ii,2);
            end
            kk = 1;
            for jj = 1:totalDOF
                isDOFfixed = false;
                for ii = 1:length(contour)
                    if jj == fixedDOF(ii,1)
                        isDOFfixed = true;
                        break
                    end
                end
                if isDOFfixed == false
                    freeDOF(kk, 1) = jj;
                    kk = kk + 1;
                end
                
            end
        end
        
        function [DOFreactionMatrix,DOFdisplacementMatrix] = solveSystem(globalStiffMatrix,externalForceinDOF,fixedDisplacementMatrix,fixedDOF,freeDOF,totalDOF)
            stiffFreeSubmatrix = zeros(length(freeDOF),length(freeDOF));
            for ii = 1:length(freeDOF)
                stiffFreeSubmatrix(ii, ii) = globalStiffMatrix(freeDOF(ii), freeDOF(ii));
                for jj = 1:length(freeDOF)
                    stiffFreeSubmatrix(ii, jj) = globalStiffMatrix(freeDOF(ii), freeDOF(jj));
                    stiffFreeSubmatrix(jj, ii) = globalStiffMatrix(freeDOF(jj), freeDOF(ii));
                end
            end
            
            stiffMixedSubmatrix1 = zeros(length(freeDOF),length(fixedDOF));
            for ii = 1:length(freeDOF)
                for jj = 1:length(fixedDOF)
                    stiffMixedSubmatrix1(ii, jj) = globalStiffMatrix(freeDOF(ii), fixedDOF(jj));
                end
            end
            
            stiffMixedSubmatrix2 = stiffMixedSubmatrix1';
            
            stiffFixedSubmatrix = zeros(length(fixedDOF),length(fixedDOF));
            for ii = 1:length(fixedDOF)
                stiffFixedSubmatrix(ii, ii) = globalStiffMatrix(fixedDOF(ii), fixedDOF(ii));
                for jj = 1:length(fixedDOF)
                    stiffFixedSubmatrix(ii, jj) = globalStiffMatrix(fixedDOF(ii), fixedDOF(jj));
                    stiffFixedSubmatrix(jj, ii) = globalStiffMatrix(fixedDOF(jj), fixedDOF(ii));
                end
            end
            
            for ii = 1:length(freeDOF)
                extForceFreeDOF(ii,1) = externalForceinDOF(freeDOF(ii));
            end
            
            for ii = 1:length(fixedDOF)
                extForceFixedDOF(ii,1) = externalForceinDOF(fixedDOF(ii));
            end
            
            freeDOFdisplacement = inv(stiffFreeSubmatrix)*(extForceFreeDOF - stiffMixedSubmatrix1*fixedDisplacementMatrix);
            DOFdisplacementMatrix = zeros(totalDOF,1);
            for ii = 1:length(freeDOF)
                DOFdisplacementMatrix(freeDOF(ii),1) = freeDOFdisplacement(ii);
            end
            
            fixedDOFreaction = stiffFixedSubmatrix*fixedDisplacementMatrix + stiffMixedSubmatrix2*freeDOFdisplacement - extForceFixedDOF;
            DOFreactionMatrix = zeros(totalDOF,1);
            for ii = 1:length(fixedDOF)
                DOFreactionMatrix(fixedDOF(ii),1) = fixedDOFreaction(ii);
            end
        end
        
        function stress = computeStress(numberElements,nodalConnection,nodeCoord,DOFconnectivitiesMatrix,DOFdisplacementMatrix,nNodesinBar,DOFnode,materialMatrix,materialAssignMatrix)
            stress = zeros(numberElements,1);
            for ee = 1:numberElements
                barLength = sqrt((nodeCoord(nodalConnection(ee,1),1) - nodeCoord(nodalConnection(ee,2),1))^2 + (nodeCoord(nodalConnection(ee,1),2) - nodeCoord(nodalConnection(ee,2),2))^2);
                xCoord1 = nodeCoord(nodalConnection(ee,1),1);
                yCoord1 = nodeCoord(nodalConnection(ee,1),2);
                xCoord2 = nodeCoord(nodalConnection(ee,2),1);
                yCoord2 = nodeCoord(nodalConnection(ee,2),2);
                s = (yCoord2-yCoord1)/barLength;
                c = (xCoord2-xCoord1)/barLength;
                localRotationMatrix = [c s 0 0; -s c 0 0; 0 0 c s; 0 0 -s c];
                for ii = 1:nNodesinBar*DOFnode
                    I = DOFconnectivitiesMatrix(ee,ii);
                    globalDisplacement(ii, 1) = DOFdisplacementMatrix(I);
                end
                localDisplacement = localRotationMatrix*globalDisplacement;
                epsilon = 1/barLength*[-1 0 1 0]*localDisplacement;
                stress(ee,1) = materialMatrix(materialAssignMatrix(ee),1)*epsilon;
            end
        end
        
    end
end

