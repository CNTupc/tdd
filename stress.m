function sig = stress(dim,x,Tn,mat,Tmat,Td,u)
sig = zeros(dim.nel,1);

for ee = 1:dim.nel
    blen = sqrt((x(Tn(ee,1),1)-x(Tn(ee,2),1))^2+(x(Tn(ee,1),2)-x(Tn(ee,2),2))^2);
    x1 = x(Tn(ee,1),1);
    y1 = x(Tn(ee,1),2);
    x2 = x(Tn(ee,2),1);
    y2 = x(Tn(ee,2),2);
    s = (y2-y1)/blen;
    c = (x2-x1)/blen;
    Rot = [c s 0 0; -s c 0 0; 0 0 c s; 0 0 -s c];
    for ii = 1:dim.nne*dim.ni
        I = Td(ee,ii);
        ugen (ii, 1) = u(I);
    end
    uloc = Rot*ugen;
    epsilon = 1/blen*[-1 0 1 0]*uloc;
    sig(ee,1) = mat(Tmat(ee),1)*epsilon;
end

end