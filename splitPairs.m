function [varsA,varsB]=splitPairs(vars,fldsInB)
    %vars={'a',33,'b',44,'cd',55,'ef',100};
    %fldsInB={'a','ef'};
    varsA=vars;

    varsB=cell(1,length(fldsInB)*2);
    ind=zeros(1,length(fldsInB));
    for i = 1:length(fldsInB)
        fld=fldsInB{i};
        ind(i)=find(cellfun(@(x) isequal(x,fld),vars));
        varsB{1,(i*2-1)}=vars{ind(i)};
        varsB{1,i*2}=vars{ind(i)+1};
    end
    ind=sort(ind,'descend');
    for i = ind
        varsA(i+1)=[];
        varsA(i)=[];
    end
end
