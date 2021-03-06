function OPT=OPTparse(OPT,fldsI)

    flds=fieldnames(Opts)
    ind=~ismember(flds,fldsI);
    if any(ind)
        disp('Unrecognized option category')
        Cell.print(flds(ind),4);
        error('See above')
    end

    OPT=OPTinitMissing(OPT);
end
