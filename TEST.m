%% 4) TEST

load('Output.mat')

sSize = length(sig);
uSize = length(u);
rSize = length(R);

sOK = true;
for ii=1:sSize
    if sig(ii) ~= stress(ii)
        sOK = false;
        break
    end
end

uOK = true;
if sOK
    for ii=1:uSize
        if u(ii) ~= DOFdisplacementMatrix(ii)
            uOK = false;
            break
        end
    end
end

rOK = true;
if (sOK && uOK)
    for ii=1:rSize
        if R(ii) ~= DOFreactionMatrix(ii)
            rOK = false;
            break
        end
    end
end

if(sOK && uOK && rOK)
    fprintf(1,'\nOK!\n')
else
    fprintf(2,'\nERROR\n')    
end