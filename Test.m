classdef Test < handle
    
    properties (Access = public)
        OK
    end
    
    properties (Access = private)
        sSize
        uSize
        sOK
        uOK
    end
    
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
    end
    
    properties (Access = private)
        sigmaOld
        uOld
    end
    
    methods (Access = public)
        
        function obj = Test()
            obj.init();
            cParams = load('Input.mat');
            s = cParams;
            obj.finiteElementsMethod(s);
            obj.equalCheck();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj)
            outputData      = load('Output1.mat');
            obj.sigmaOld    = outputData.sigmaOld;
            obj.uOld        = outputData.uOld;
        end
        
        function finiteElementsMethod(obj,s)
            fem = FEMsolver(s);
            fem.solve(s);
            obj.displacement = fem.displacement;
            obj.stress = fem.stress;
        end
        
        function equalCheck(obj)         
            obj.sSize = length(obj.sigmaOld);
            obj.uSize = length(obj.uOld);
            
            obj.sOK = true;
            for ii=1:obj.sSize
                if obj.sigmaOld(ii) - obj.stress(ii) >= 1e-6
                    obj.sOK = false;
                    break
                end
            end
            
            obj.uOK = true;
            if obj.sOK
                for ii=1:obj.uSize
                    if obj.uOld(ii) - obj.displacement(ii) >= 1e-6
                        obj.uOK = false;
                        break
                    end
                end
            end
            
            if(obj.sOK && obj.uOK)
                obj.OK = 1;
            else
                obj.OK = 0;
            end
        end
        
    end
    
end