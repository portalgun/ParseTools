function obj=parseObj(obj,Opts,p,varargin)
%function obj=parseObj(obj,Opts,p,bIgnore,bQuiet)
if ~exist('obj','var')  || isempty(obj)
    obj=struct();
end

p=parseStruct(Opts,p,varargin{:});
flds=fieldnames(p.Results);
for i = 1:length(flds)
    fld=flds{i};
    obj.(fld)=p.Results.(fld);
end
