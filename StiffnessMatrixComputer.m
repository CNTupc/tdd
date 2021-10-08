classdef StiffnessMatrixComputer < handle
    properties (Access = public)
        K
    end
    
    properties (Access = private)
        numberofElements
        nNodesperBar
        DOFperNode
        nodalConnectionMatrix
        nodeCoordinatesMatrix
        materialMatrix
        materialAssignMatrix
        elementStiffnessMatrix
        totalDOF
        connectivityMatrix
    end
    
    methods (Access = public)
        
        function obj = StiffnessMatrixComputer(s)
            obj.init(s);
        end
        
        function compute(obj)
            obj.assembleElementStiffnessMatrix();
            obj.assembleGlobalStiffnessMatrix();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,s)
            obj.numberofElements            = s.numberofElements;
            obj.nNodesperBar                = s.nNodesperBar;
            obj.DOFperNode                  = s.DOFperNode;
            obj.nodalConnectionMatrix       = s.nodalConnectionMatrix;
            obj.nodeCoordinatesMatrix       = s.nodeCoordinatesMatrix;
            obj.materialMatrix              = s.materialMatrix;
            obj.materialAssignMatrix        = s.materialAssignMatrix;
            obj.connectivityMatrix          = s.connectivityMatrix;
            obj.totalDOF                    = s.totalDOF;
        end
        
        function assembleElementStiffnessMatrix(obj)
            noe = obj.numberofElements;
            nnb = obj.nNodesperBar;
            dn = obj.DOFperNode;
            ncm = obj.nodalConnectionMatrix;
            nxm = obj.nodeCoordinatesMatrix;
            mm = obj.materialMatrix;
            mam = obj.materialAssignMatrix;
            obj.elementStiffnessMatrix = zeros(nnb*dn,nnb*dn,noe);
            for ee = 1:noe
                bL = sqrt((nxm(ncm(ee,1),1) - nxm(ncm(ee,2),1))^2 + (nxm(ncm(ee,1),2) - nxm(ncm(ee,2),2))^2);
                eSC = (mm(mam(ee),2)*mm(mam(ee),1))/(bL);
                theta = atan((nxm(ncm(ee,1),2) - nxm(ncm(ee,2),2))/(nxm(ncm(ee,1),1) - nxm(ncm(ee,2),1)));
                c = cos(theta);
                s = sin(theta);
                obj.elementStiffnessMatrix(:,:,ee) = eSC.*[c^2,  s*c,  -c^2,  -c*s;
                                                    s*c,  s^2,  -c*s, -s^2;
                                                    -c^2, -c*s, c^2,   s*c;
                                                    -c*s, -s^2, s*c,   s^2
                                                    ];
            end
        end
        
        function assembleGlobalStiffnessMatrix(obj)
            noe = obj.numberofElements;
            nnb = obj.nNodesperBar;
            dn = obj.DOFperNode;
            td = obj.totalDOF;
            cm = obj.connectivityMatrix;
            obj.K = zeros(td,td);
            for ee = 1:noe
                for ii = 1:nnb*dn
                    I = cm(ee, ii);
                    for jj = 1:nnb*dn
                        J = cm(ee,jj);
                        obj.K(I,J) = obj.K(I,J) + obj.elementStiffnessMatrix(ii,jj,ee);
                    end
                end
            end
        end
        
    end
end