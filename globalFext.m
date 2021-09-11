function Fext = globalFext(dim,fdata)
%Allocates external forces in their corresponding DOF
Fext = zeros(dim.ndof,1);
nforce = size(fdata);
for ii = 1:nforce(1)
    Fext(2*(fdata(ii,1)-1)+fdata(ii,2), 1) = fdata(ii, 3);
end

end