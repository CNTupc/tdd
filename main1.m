clc; clear
close all

%% Input data
F = 720;
E = 68000e6;
A = 150e-6;
rho = 3100;

%% PREPROCESS

% 1.1 Define geometry
% Nodal coordinates matrix
x = [
    0 0;
    0.5 0.2;
    1 0.4;
    1.5 0.6;
    0 0.5;
    0.5 0.6;
    1 0.7;
    1.5 0.8
];

% Nodal connectivities matrix
Tn = [
    1 2;%1
    2 3;%2
    3 4;%3
    5 6;%4
    6 7;%5
    7 8;%6
    1 5;%7
    1 6;%8
    5 2;%9
    2 6;%10
    2 7;%11
    6 3;%12
    3 7;%13
    3 8;%14
    7 4;%15
    4 8%16
];

% Material properties matrix
mat = [
    E, A
];
% Material connectivities matrix
Tmat = [
    1;%1
    1;%2
    1;%3
    1;%4
    1;%5
    1;%6
    1;%7
    1;%8
    1;%9
    1;%10
    1;%11
    1;%12
    1;%13
    1;%14
    1;%15
    1;%16
];

% 1.2 Define external forces and boundary conditions
% Point loads matrix
fdata = [
    2, 2, F;
    3, 2, F;
    4, 2, F
];
% Fixed nodes matrix
fixnod = [
    1 1 0;
    1 2 0;
    5 9 0;
    5 10 0    
];

%% 2) SOLVER

% Dimensions
dim.nd = size(x,2);   % Problem dimension
dim.nel = size(Tn,1); % Number of elements (bars)
dim.nnod = size(x,1); % Number of nodes (joints)
dim.nne = size(Tn,2); % Number of nodes in a bar
dim.ni = 2;           % Degrees of freedom per node
dim.ndof = dim.nnod*dim.ni;  % Total number of degrees of freedom

% 2.1 Create degrees of freedom connectivities matrix
Td = connectDOF(dim, Tn);

% 2.2 Compute element stiffness matrices
Kel = stiffnessBars(dim,x,Tn,mat,Tmat);

% 2.3 Assemble global stiffness matrix
KG = assemblyK(dim,Kel,Td);

% 2.4 Create global external forces vector
Fext = globalFext(dim,fdata);

% 2.5 Create arrays of fixed and free degrees of freedom
[ur,vr,vl] = fixedDOF(dim,fixnod);

% 2.6 Solve system
[u,R] = solveSystem(dim,KG,Fext,ur,vr,vl);

% 2.7 Compute stress
sig = stress(dim,x,Tn,mat,Tmat,Td,u);

%% 3) POSTPROCESS

% Structure weight
[Weigth, weigth] = weightcalc(dim, x, Tn, rho, A);

scale = 10;
X = x(:,1);
Y = x(:,2);
UxNew = scale*u(1:dim.ni:end,1);
UyNew = scale*u(2:dim.ni:end,1);

% figure
% hold on;
% box on;
% axis equal
% plot(X(Tn'),Y(Tn'),'--k');
% plot(X(Tn')+Ux(Tn'),Y(Tn')+Uy(Tn'),'b');
% title(sprintf('Deformation (scale = %.f)',scale))
% xlabel('x (m)'); ylabel('y (m)');
% 
% figure
% hold on;
% box on;
% axis equal
% plot(X(Tn'),Y(Tn'),'--k');
% patch(X(Tn')+Ux(Tn'),Y(Tn')+Uy(Tn'),[sig';sig'],'edgecolor','interp');
% colormap('jet');
% colorbar('Ticks',[min(sig),0,max(sig)]);
% title('Stress \sigma (Pa)')
% xlabel('x (m)'); ylabel('y (m)');
