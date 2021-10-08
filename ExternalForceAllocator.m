classdef ExternalForceAllocator < handle
    properties (Access = public)
        externalForceConditions
    end
    
    properties (Access = private)
        forceData
        totalDOF
    end
    
    methods (Access = public)
        
        function obj = ExternalForceAllocator(s)
            obj.init(s);
        end
        
        function compute(obj)
            obj.allocateExternalForce();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,s)
            obj.forceData   = s.forceData;
            obj.totalDOF    = s.totalDOF;
        end
        
        function allocateExternalForce(obj)
            td = obj.totalDOF;
            fd = obj.forceData;
            obj.externalForceConditions = zeros(td,1);
            nf = length(fd);
            for ii = 1:nf
                obj.externalForceConditions(2*(fd(ii,1)-1) + fd(ii,2), 1) = fd(ii, 3);
            end
        end
        
    end
end