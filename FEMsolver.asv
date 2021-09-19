classdef FEMsolver < handle
    %FEMSOLVER code refactoring
    
    properties (Access = public)
        displacement
        stress
    end
    
    properties (Access = private)
        totalDOF
        connectivityMatrix
        stiffnessMatrix
        externalForceMatrix
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
        function obj = FEMsolver(cParams)
            obj.init(cParams);
        end
        
        function solve(obj)
            obj.computeMesh();
            obj.computeStiffnessMatrix();
            obj.computeConditions();
            obj.solveDisplacement();
            obj.solveStress();
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
            obj.stiffnessMatrix = stiffness.K;
        end
        
        function computeConditions(obj)
            force = ExternalForceAllocator(cParams);
            force.compute();
            obj.externalForceMatrix = force.externalForceConditions;
        end
        
        function solveDisplacement(obj)
            cParams.externalForceConditions = obj.externalForceMatrix;
            cParams.stiffnessMatrix = obj.stiffnessMatrix;
            solution = EquationSolver(cParams);
            solution.compute();
            obj.displacement = solution.DOFdisplacementMatrix;            
        end
        
        function solveStress(obj)
            cParams.displacement = obj.displacement;
            sigma = StressSolver(cParams);
            sigma.compute();
            obj.stress = sigma.sigma;
        end
        
    end
    
end

