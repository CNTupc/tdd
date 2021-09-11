function [u,R] = solveSystem(dim,KG,Fext,ur,vr,vl)
%Definition of KLL, KLR, KRL, KRR, FLext, FRext and system solving

%KLL
Kll = zeros(length(vl),length(vl));
for ii = 1:length(vl)
    Kll(ii, ii) = KG(vl(ii), vl(ii));
    for jj = 1:length(vl)
         Kll(ii, jj) = KG(vl(ii), vl(jj));
         Kll(jj, ii) = KG(vl(jj), vl(ii));
    end
end

%KRL
Krl = zeros(length(vl),length(vr));
for ii = 1:length(vl)
    for jj = 1:length(vr)
         Krl(ii, jj) = KG(vl(ii), vr(jj));
    end
end

%KLR
Klr = Krl';

%KRR
Krr = zeros(length(vr),length(vr));
for ii = 1:length(vr)
    Krr(ii, ii) = KG(vr(ii), vr(ii));
    for jj = 1:length(vr)
         Krr(ii, jj) = KG(vr(ii), vr(jj));
         Krr(jj, ii) = KG(vr(jj), vr(ii));
    end
end

%FLext
for ii = 1:length(vl)
    FLext(ii,1) = Fext(vl(ii));
end

%FRext
for ii = 1:length(vr)
    FRext(ii,1) = Fext(vr(ii));
end

ul = inv(Kll)*(FLext - Krl*ur);
u = zeros(dim.ndof,1);
for ii = 1:length(vl)
    u(vl(ii),1) = ul(ii);
end

Rr = Krr*ur + Klr*ul - FRext;
R = zeros(dim.ndof,1);
for ii = 1:length(vr)
    R(vr(ii),1) = Rr(ii);
end

end