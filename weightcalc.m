function [Weigth, weigth] = weightcalc(dim, x, Tn, rho, A)
%This function calculates the length of each bar, and computes it's weight
Weigth = 0;
for ee = 1:dim.nel
    blen(ee) = sqrt((x(Tn(ee,1),1)-x(Tn(ee,2),1))^2+(x(Tn(ee,1),2)-x(Tn(ee,2),2))^2);
    weigth(ee) = blen(ee)*rho*A;
    Weigth = Weigth + weigth(ee);
end

