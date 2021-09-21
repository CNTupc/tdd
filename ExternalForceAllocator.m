classdef ExternalForceAllocator
    properties (Access = public)
        externalForceConditions
    end
    
    properties (Access = private)
        forceData
        totalDOF
    end
    
    methods (Access = public)
        
        function obj = ExternalForceAllocator(cParams)
            obj.init(cParams);
        end
        
        function compute(obj)
            obj.allocateExternalForce();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.forceData = cParams.forceData;
            obj.totalDOF = cParams.totalDOF;
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