classdef TotalDOFComputer < handle
    properties (Access = public)
        totalDOF
    end
    
    properties (Access = private)
        numberofNodes
        nNodesperBar
    end
     
    methods (Access = public)
        function obj = TotalDOFComputer(s)
            obj.init(s);
        end
        
        function compute(obj)
            obj.computeTotalDOF();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,s)
            obj.numberofNodes   = s.numberofNodes;
            obj.nNodesperBar    = s.nNodesperBar;
        end
        
        function computeTotalDOF(obj)
            obj.totalDOF = obj.numberofNodes*obj.nNodesperBar;
        end
        
    end
end