function obj=parse(obj,Opts,names,defaults,tests,rmflds,bIgnore,bQuiet)
% function obj=parse(obj,Opts,names,defaults,tests, bIgnore,bQuiet)
% names and opts are required
% names can contain defaults and tests in columns 2 and 3
%
% names
% defaults
% tests
% size

    if ~exist('obj','var')
        obj=struct();
    end
    if ~exist('defaults','var')
        defaults=[];
    end
    if ~exist('tests','var')
        tests=[];
    end
    if ~exist('Opts','var') || isempty(Opts)
        Opts=struct();
    end

    if exist('rmflds','var') && ~isempty(rmflds)
        Opts=structRmFlds(Opts,rmflds);
    end

    if ~exist('bIgnore','var')
        bIgnore=[];
    end
    if ~exist('bQuiet','var')
        bQuiet=[];
    end

    bTable=size(names,1)>1;

    if bTable && size(names,2) > 1 && isempty(defaults)
        defaults=names(:,2);
    elseif isempty(defaults)
        defaults=cell(size(names,1));
    end

    if bTable && size(names,2) > 2 && isempty(tests)
        tests=names(:,3);
    elseif isempty(tests)
        tests=cell(size(names,1));
    end

    if bTable && size(names,2) > 3
        sizes=names(:,4);
    else
        sizes=cell(size(names,1));
    end

    if bTable && size(names,2) > 2
        names=names(:,1);
    end

    for i = 1:length(tests)
        if isempty(tests{i})
            tests{i}=@istrue;
        elseif ~isa(tests{i}, 'function_handle') && isstr(tests{i})
            tests{i}=str2func(tests{i});
        end
    end

    p=inputParser();
    for i = 1:size(names,1)
        p.addParameter(names{i},defaults{i},tests{i});
    end
    obj=parseObj(obj,Opts,p,bIgnore,bQuiet);

    em=cellfun(@isempty,sizes);
    for i = 1:length(names)
        if em(i);
            continue
        end

        sz=size(obj.(names{i}));
        str=['Size of option ' names{i} ' (' num2strSane(sz) ') does not match parser value size ( ' num2strSane(sizes{i}) ' ).'];
        assert( isequal( sz ,sizes{i}), str);
    end

end
function out=istrue(varargin)
    out=1;
end
%% INT
function out=isLorRorB(in)
    out=ismember(in,{'L','R','B'});
end
function out=isint_e(in)
    out=isint(in) || isempty(in);
end
function out=isallint(in)
    out=all(isint(in(:)));
end
function out=isallint_e(in)
    out=all(isempty(in) || isallint(in));
end
function out=isallintorempty(in)
    out=all(isempty(in) || isallint(in));
end

function out=isbinary_e(in)
    out=isempty(in) || isbinary(in);
end
function out=isallnum(in)
    out=all(isnumeric(in),'all');
end
function out=isallnum_e(in)
    out=isempty(in) || all(isnumeric(in),'all');
end
function out=isallnum1(in)
    out=all(isnumeric(in),'all') && numel(in)==1;
end
function out=isallnum2(in)
    out=all(isnumeric(in),'all') && numel(in)==2;
end
function out=isallnum2_e(in)
    out =isempty(in) || isallnum2(in);
end

function out=isallint2(in)
    out=all(isint(in),'all') && numel(in)==2;
end
function out=isallint3(in)
    out=all(isint(in),'all') && numel(in)==3;
end
function out=isallint1(in)
    out=all(isint(in)) && numel(in)==1;
end
function out=isallint1or2(in)
    out=isallint1(in) | isallint2(in);
end
function out=isallint1orempty(in)
    out=isempty(in) || (all(isint(in)) && numel==1);
end
function out=iscellstruct(in)
%FROM iscellstruct.m
    if ~iscell(in) || isemptyall(in)
        out=0;
        return
    end
    out=all(cellfun(@(x) isstruct(x)| isempty(x),in(:)));
end
function out=iscellstruct_e(in)
    out=isempty(in) | iscellstruct(in);
end
function out=ischarcell(lin)
    if ~iscell(in)
        out=0;
        return
    end
    out=all(cellfun(@(x) ischar(x) & ~isempty(x),in),'all');
end
function out=ischarcell_e(in)
    if isempty(in)
        out=1;
        return
    elseif ~iscell(in)
        out=0;
        return
    end
    out=all(cellfun(@(x) ischar(x) | isempty(x),in),'all');
end
function out=ischar_e(in)
    out=isempty(in) || ischar(in);
end
function out=isstruct_e(in)
    out=isempty(in) || isstruct(in);
end
function out=iscell_e(in)
    out=isempty(in) || iscell(in);
end
