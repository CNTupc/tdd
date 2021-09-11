clear
close all

% Input data
H1 = 2;
H2 = 2.5;
L = 1;
F = 7500;
E = 71000e6;
A = 50e-6;

%% PREPROCESS

% 1.1 Define geometry
% Nodal coordinates matrix
x = [
    0 0;
    2*L 0;
    4*L 0;
    L H1;
    4*L H2
];

% Nodal connectivities matrix
Tn = [
    1 4;
    2 5;
    4 5;
    3 5;
    2 4
];

% Material properties matrix
mat = [
    E, A
];
% Material connectivities matrix
Tmat = [
    1;
    1;
    1;
    1;
    1;
];

% 1.2 Define external forces and boundary conditions
% Point loads matrix
fdata = [
    5, 1, F;
];
% Fixed nodes matrix
fixnod = [
    1 1 0;
    1 2 0;
    2 3 0;
    2 4 0;
    3 5 0;
    3 6 0;
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

scale = 10;
X = x(:,1);
Y = x(:,2);
Ux = scale*u(1:dim.ni:end,1);
Uy = scale*u(2:dim.ni:end,1);

figure
hold on;
box on;
axis equal
plot(X(Tn'),Y(Tn'),'--k');
plot(X(Tn')+Ux(Tn'),Y(Tn')+Uy(Tn'),'b');
title(sprintf('Deformation (scale = %.f)',scale))
xlabel('x (m)'); ylabel('y (m)');

figure
hold on;
box on;
axis equal
plot(X(Tn'),Y(Tn'),'--k');
patch(X(Tn')+Ux(Tn'),Y(Tn')+Uy(Tn'),[sig';sig'],'edgecolor','interp');
colormap('jet');
colorbar('Ticks',[min(sig),0,max(sig)]);
title('Stress \sigma (Pa)')
xlabel('x (m)'); ylabel('y (m)');
