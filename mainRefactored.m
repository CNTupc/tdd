clc; clear
close all

cParams = load('Input.mat');

FEM = FEMsolver(cParams);

FEM.solve(cParams);

u = FEM.displacement;

sigma = FEM.stress;

%% TEST

load('Output1.mat');

sSize = length(sigmaOld);
uSize = length(uOld);

sOK = true;
for ii=1:sSize
    if sigmaOld(ii) ~= sigma(ii)
        sOK = false;
        break
    end
end

uOK = true;
if sOK
    for ii=1:uSize
        if uOld(ii) ~= u(ii)
            uOK = false;
            break
        end
    end
end

if(sOK && uOK)
    fprintf(1,'\nOK!\n')
else
    fprintf(2,'\nERROR\n')    
end