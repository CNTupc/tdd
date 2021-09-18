function KG = assemblyK(dim,Kel,Td)
%Global stiffness matrix calculation
KG = zeros(dim.ndof,dim.ndof);
for ee = 1:dim.nel
    for ii = 1:dim.nne*dim.ni
        I = Td(ee, ii);
        for jj = 1:dim.nne*dim.ni
            J = Td(ee,jj);
            KG(I,J) = KG(I,J) + Kel(ii,jj,ee);
        end
    end
end

end