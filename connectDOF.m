function Td = connectDOF(dim, Tn)
%DOF designation based on node designation

Td = zeros(dim.nel,dim.nne*dim.ni);

for ee = 1:dim.nel %n of elements
    for ii = 1:dim.nne %n of nodes in each element
        for jj = 1:dim.ni %n of DOF in each node
            I = dim.ni*(ii - 1) + jj;
            Td(ee, I) = dim.ni*(Tn(ee, ii) - 1) + jj;
        end
    end
end

end