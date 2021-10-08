classdef EquationSolver < handle
    properties (Access = public)
        DOFdisplacementMatrix
        DOFreactionMatrix
    end
    
    properties (Access = private)
        contourConditions
        totalDOF
        fixedDisplacementMatrix
        fixedDOF
        freeDOF
        stiffnessMatrix
        noExternalForceVector
        externalForceVector
        externalForceMatrix
    end
    
    methods (Access = public)
        
        function obj = EquationSolver(s)
            obj.init(s);
        end
        
        function compute(obj)
            obj.generateEquations();
            obj.solveSystem();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,s)
            obj.contourConditions   = s.contourConditions;
            obj.totalDOF            = s.totalDOF;
            obj.stiffnessMatrix     = s.K;
            obj.externalForceMatrix = s.F;
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
        
        function solveSystem(obj)
            vl = obj.freeDOF;
            vr = obj.fixedDOF;
            ur = obj.fixedDisplacementMatrix;
            KG = obj.stiffnessMatrix;
            Kll = zeros(length(vl),length(vl));
            for ii = 1:length(vl)
                Kll(ii, ii) = KG(vl(ii), vl(ii));
                for jj = 1:length(vl)
                    Kll(ii, jj) = KG(vl(ii), vl(jj));
                    Kll(jj, ii) = KG(vl(jj), vl(ii));
                end
            end
            
            Krl = zeros(length(vl),length(vr));
            for ii = 1:length(vl)
                for jj = 1:length(vr)
                    Krl(ii, jj) = KG(vl(ii), vr(jj));
                end
            end
            
            Klr = Krl';
            
            Krr = zeros(length(vr),length(vr));
            for ii = 1:length(vr)
                Krr(ii, ii) = KG(vr(ii), vr(ii));
                for jj = 1:length(vr)
                    Krr(ii, jj) = KG(vr(ii), vr(jj));
                    Krr(jj, ii) = KG(vr(jj), vr(ii));
                end
            end
            
            for ii = 1:length(vl)
                obj.noExternalForceVector(ii,1) = obj.externalForceMatrix(vl(ii));
            end
            
            for ii = 1:length(vr)
                obj.externalForceVector(ii,1) = obj.externalForceMatrix(vr(ii));
            end
            
            FLext = obj.noExternalForceVector;
            FRext = obj.externalForceVector;
            ul = inv(Kll)*(FLext - Krl*ur);
            obj.DOFdisplacementMatrix = zeros(obj.totalDOF,1);
            for ii = 1:length(vl)
                obj.DOFdisplacementMatrix(vl(ii),1) = ul(ii);
            end
            
            Rr = Krr*ur + Klr*ul - FRext;
            obj.DOFreactionMatrix = zeros(obj.totalDOF,1);
            for ii = 1:length(vr)
                obj.DOFreactionMatrix(vr(ii),1) = Rr(ii);
            end
        end
        
    end
end