classdef ConnectivityMatrixComputer
    properties (Access = public)
        connectivityMatrix
    end
    
    properties (Access = private)
        numberofElements
        nNodesperBar
        DOFperNode
        nodalConnectionMatrix
    end
    
    methods (Access = public)
        
        function compute(obj)
            obj.init(cParams);
            obj.assembleConnectivityMatrix();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.numberofElements = cParams.numberofElements;
            obj.nNodesperBar = cParams.nNodesperBar;
            obj.DOFperNodes = cParams.DOFperNode;
            obj.nodalConnectionMatrix = cParams.nodalConnectionMatrix;
        end
        
        function assembleConnectivityMatrix(obj)
            noe = obj.numberofElements;
            nnb = obj.nNodesperBar;
            dn = obj.DOFperNode;
            ncm = obj.nodalConnectionMatrix;
            obj.connectivityMatrix = zeros(noe,nnb*dn);
            for ee = 1:noe
                for ii = 1:nnb
                    for jj = 1:dn
                        I = dn*(ii - 1) + jj;
                        obj.connectivityMatrix(ee, I) = dn*(ncm(ee, ii) - 1) + jj;
                    end
                end
            end
        end
        
    end
end