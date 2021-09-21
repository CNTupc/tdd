classdef StressSolver
    properties (Access = public)
        sigma
    end
    
    properties (Access = private)
        numberofElements
        nodeCoordinatesMatrix
        nodalConnectionMatrix
        nNodesperBar
        DOFperNode
        connectivityMatrix
        displacement
        materialMatrix
        materialAssignMatrix
    end
    
    methods (Access = public)
        
        function obj = StressSolver(cParams)
            obj.init(cParams);
        end
        
        function compute(obj)
            obj.computeStress();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.numberofElements = cParams.numberofElements;
            obj.nodeCoordinatesMatrix = cParams.nodeCoordinatesMatrix;
            obj.nodalConnectionMatrix = cParams.nodalConnectionMatrix;
            obj.nNodesperBar = cParams.nNodesperBar;
            obj.DOFperNode = cParams.DOFperNode;
            obj.connectivityMatrix = cParams.connectivityMatrix;
            obj.displacement = cParams.displacement;
            obj.materialMatrix = cParams.materialMatrix;
            obj.materialAssignMatrix = cParams.materialAssignMatrix;
        end
        
        function computeStress(obj)
            obj.sigma = zeros(dim.nel,1);
            noe = obj.numberofElements;
            nxm = obj.nodeCoordinatesMatrix;
            ncm = obj.nodalConnectionMatrix;
            nnb = obj.nNodesperBar;
            dn = obj.DOFperNode;
            cm = obj.connectivityMatrix;
            u = obj.displacement;
            mat = obj.materialMatrix;
            Tmat = obj.materialAssignMatrix;            
            for ee = 1:noe
                bL = sqrt((nxm(ncm(ee,1),1) - nxm(ncm(ee,2),1))^2 + (nxm(ncm(ee,1),2) - nxm(ncm(ee,2),2))^2);
                x1 = nxm(ncm(ee,1),1);
                y1 = nxm(ncm(ee,1),2);
                x2 = nxm(ncm(ee,2),1);
                y2 = nxm(ncm(ee,2),2);
                s = (y2-y1)/bL;
                c = (x2-x1)/bL;
                Rot = [c s 0 0; -s c 0 0; 0 0 c s; 0 0 -s c];
                for ii = 1:nnb*dn
                    I = cm(ee,ii);
                    ugen (ii, 1) = u(I);
                end
                uloc = Rot*ugen;
                epsilon = 1/bL*[-1 0 1 0]*uloc;
                obj.sigma(ee,1) = mat(Tmat(ee),1)*epsilon;
            end
            
        end
    end
end