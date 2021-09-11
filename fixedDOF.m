function [ur,vr,vl] = fixedDOF(dim,fixnod)
for ii = 1:length(fixnod)
    ur(ii,1) = fixnod(ii,3);
    vr(ii,1) = fixnod(ii,2);
end
kk = 1;
for jj = 1:dim.ndof
    is = false;
    for ii = 1:length(fixnod)
        if jj == vr(ii,1)
            is = true;
            ii = length(fixnod)+1; %force exit for ii
        end
    end
    if is == false
        vl(kk, 1) = jj;
        kk = kk + 1;
end


end