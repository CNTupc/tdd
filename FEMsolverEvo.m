classdef FEMsolverEvo < handle
    
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
        area
        contourConditions
        dimension
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
        type
    end
    
    methods (Access = public)
        function obj = FEMsolverEvo(s)
            obj.init(s);
        end
        
        function create(obj,s)
            switch s.type
                case 0
                    obj.directSolver(s);
                case 1
                    obj.iterativeSolver(s);
            end
        end
        
        function directSolver(obj,s)
            obj.computeConnectivityMatrix(s);
            obj.computeStiffnessMatrix(s);
            obj.computeConditions(s);
            obj.solveDisplacementD(s);
            obj.solveStress(s);
        end
        
        function iterativeSolver(obj,s)
            obj.computeConnectivityMatrix(s);
            obj.computeStiffnessMatrix(s);
            obj.computeConditions(s);
            obj.solveDisplacementI(s);
            obj.solveStress(s);
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,s)
            obj.area                    = s.Area;
            obj.contourConditions       = s.contourConditions;
            obj.dimension               = s.Dimension;
            obj.DOFconnectionMatrix     = s.DOFconnectionMatrix;
            obj.DOFperNode              = s.DOFperNode;
            obj.forceData               = s.forceData;
            obj.materialAssignMatrix    = s.materialAssignMatrix;
            obj.materialMatrix          = s.materialMatrix;
            obj.nNodesperBar            = s.nNodesperBar;
            obj.nodalConnectionMatrix   = s.nodalConnectionMatrix;
            obj.nodeCoordinatesMatrix   = s.nodeCoordinatesMatrix;
            obj.numberofElements        = s.numberofElements;
            obj.numberofNodes           = s.numberofNodes;
            obj.rho                     = s.rho;
            obj.youngModulus            = s.youngModulus;
            obj.type                    = s.type;
        end
        
        function computeConnectivityMatrix(obj,s)
            nDOF = TotalDOFComputer(s);
            nDOF.compute();
            obj.totalDOF = nDOF.totalDOF;
            connectivity = ConnectivityMatrixComputer(s);
            connectivity.compute();
            obj.connectivityMatrix = connectivity.connectivityMatrix;
        end
                
        function computeStiffnessMatrix(obj,s)
            s.totalDOF = obj.totalDOF;
            s.connectivityMatrix = obj.connectivityMatrix;
            stiffness = StiffnessMatrixComputer(s);
            stiffness.compute();
            obj.stiffnessMatrix = stiffness.K;
            s.K = obj.stiffnessMatrix;
        end
        
        function computeConditions(obj,s)
            s.K = obj.stiffnessMatrix;
            s.totalDOF = obj.totalDOF;
            s.connectivityMatrix = obj.connectivityMatrix;
            force = ExternalForceAllocator(s);
            force.compute();
            obj.externalForceMatrix = force.externalForceConditions;
            s.F = obj.externalForceMatrix;
        end
        
        function solveDisplacementD(obj,s)
            s.F = obj.externalForceMatrix;
            s.K = obj.stiffnessMatrix;
            s.totalDOF = obj.totalDOF;
            s.connectivityMatrix = obj.connectivityMatrix;
            solution = EquationSolverD(s);
            solution.compute();
            obj.displacement = solution.DOFdisplacementMatrix;  
            s.u = obj.displacement;
        end
        
        function solveDisplacementI(obj,s)
            s.F = obj.externalForceMatrix;
            s.K = obj.stiffnessMatrix;
            s.totalDOF = obj.totalDOF;
            s.connectivityMatrix = obj.connectivityMatrix;
            solution = EquationSolverI(s);
            solution.compute();
            obj.displacement = solution.DOFdisplacementMatrix;  
            s.u = obj.displacement;
        end
        
        function solveStress(obj,s)
            s.u = obj.displacement;
            s.F = obj.externalForceMatrix;
            s.K = obj.stiffnessMatrix;
            s.totalDOF = obj.totalDOF;
            s.connectivityMatrix = obj.connectivityMatrix;
            sigma = StressSolver(s);
            sigma.compute();
            obj.stress = sigma.sigma;
        end
        
    end
    
end