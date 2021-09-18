classdef TotalDOFComputer
    properties (Access = public)
        totalDOF
    end
    
    properties (Access = private)
        numberofNodes
        nNodesperBar
    end
    
    methods (Access = public)
        
        function compute(obj)
            obj.init(cParams);
            obj.computeTotalDOF();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.numberofNodes = cParams.numberofNodes;
            obj.nNodesperBar = cParams.nNodesperBar;
        end
        
        function computeTotalDOF(obj)
            obj.totalDOF = obj.numberofNodes*obj.nNodesperBar;
        end
        
    end
end