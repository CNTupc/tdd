function Kel = stiffnessBars(dim,x,Tn,mat,Tmat)
%Calculates elemental stifness matrices for each bar
Kel = zeros(dim.nne*dim.ni,dim.nne*dim.ni,dim.nel);

for ee = 1:dim.nel
    blen = sqrt((x(Tn(ee,1),1)-x(Tn(ee,2),1))^2+(x(Tn(ee,1),2)-x(Tn(ee,2),2))^2);
    kel = (mat(Tmat(ee),2)*mat(Tmat(ee),1))/(blen);
    theta = atan((x(Tn(ee,1),2)-x(Tn(ee,2),2))/(x(Tn(ee,1),1)-x(Tn(ee,2),1)));
    Kel(:,:,ee) = kel.*[cos(theta)^2, sin(theta)*cos(theta), -cos(theta)^2, -cos(theta)*sin(theta);
        sin(theta)*cos(theta), sin(theta)^2, -cos(theta)*sin(theta), -sin(theta)^2;
        -cos(theta)^2, -cos(theta)*sin(theta), cos(theta)^2, sin(theta)*cos(theta);
        -cos(theta)*sin(theta), -sin(theta)^2, sin(theta)*cos(theta), sin(theta)^2];
end   

end