function S=OPTinitMissing(S,fldsI)
    flds=fieldnames(Opts)
    if any(~ismember(flds,fldsI))
        % XXX
        error(' ')
    end

    flds=fieldnames(S);
    ind=~ismember(fldsI,flds);
    flds=fldsI(ind)
    for i = 1:length(flds)
        fld=flds{i}
        S.(fld)=struct();
    end
end
