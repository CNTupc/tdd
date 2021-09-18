classdef EquationSolver
    properties (Access = public)
        
    end
    
    properties (Access = private)
        contourConditions
        totalDOF
        fixedDisplacementMatrix
        fixedDOF
        freeDOF
    end
    
    methods (Access = public)
        
        function compute(obj)
            obj.init(cParams);
            obj.generateEquations();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.contourConditions = cParams.contourConditions;
            obj.totalDOF = cParams.totalDOF;
        end
        
        function generateEquations(obj)
            cc = obj.contourConditions;
            td = obj.totalDOF;
            for ii = 1:length(cc)
                obj.fixedDisplacementMatrix(ii,1) = cc(ii,3);
                obj.fixedDOF(ii,1) = cc(ii,2);
            end
            kk = 1;
            for jj = 1:td
                isDOFfixed = false;
                for ii = 1:length(cc)
                    if jj == obj.fixedDOF(ii,1)
                        isDOFfixed = true;
                        break
                    end
                end
                if isDOFfixed == false
                    obj.freeDOF(kk, 1) = jj;
                    kk = kk + 1;
                end
            end
        end
        
    end
end