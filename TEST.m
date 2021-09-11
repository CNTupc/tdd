%% 4) TEST

sSize = length(sig);
xSize = length(Ux);
ySize = length(Uy);

sOK = true;
for ii=1:sSize
    if sig(ii) ~= sigNew(ii)
        sOK = false;
        break
    end
end

xOK = true;
if sOK
    for ii=1:xSize
        if Ux(ii) ~= UxNew(ii)
            xOK = false;
            break
        end
    end
end

yOK = true;
if (sOK && xOK)
    for ii=1:ySize
        if Uy(ii) ~= UyNew(ii)
            yOK = false;
            break
        end
    end
end

if(sOK && xOK && yOK)
    fprintf(1,'\nOK!\n')
else
    fprintf(2,'\nERROR\n')    
end