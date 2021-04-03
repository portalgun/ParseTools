function [ p ] = parseStruct(Opts,p,bIgnore,bQuiet)
%{
function p = parseStruct(Opts,p,bIgnore,bQuiet)
     examplecall:
         p = inputParser();
         p.addParameter('bByImage', 0, @isnumeric);
         p.addParameter('saveDTB','',@ischar);
         S.saveDTB='/home/dambam/'
         p=parseStruct(S,p)
         S=p.Results; %OPTIONALLY

for input parser, parses struct instead of field pairs
%}

if ~isvar('bIgnore')
    bIgnore=0;
end

if ~isvar('bQuiet')
    bQuiet=0;
end

flds=fieldnames(Opts);
for i = 1:length(flds)
    fld=flds{i};

    %GET FIELD VALUE AND ASSIGN TO VARIABLE WITH NAME OF FIELD
    eval([ fld ' = Opts.(fld);']);
    if isempty(eval(fld))
        continue
    end

    %CREATE STRING PAIR
    vargstr=['''' fld ''','  fld];

    %IGNORE EXTRA FIELDS IF THEY EXIST & WARN
    if bIgnore && ~any(contains(p.Parameters,fld))
        if ~bQuiet
            warning(['parseStruct: Ignoring uninitialized parameter ' fld]);
        end
        continue
    end

    %ADD STRING PAIR TO MASTER STRING
    if ~isvar('VARGSTR')
        VARGSTR=[vargstr ','];
    elseif i == length(flds)
        VARGSTR=[VARGSTR vargstr];
    else
        VARGSTR=[VARGSTR vargstr ','];
    end
end


%PARSE MASTER STRING IF NO PARAMS
if ~isvar('VARGSTR')
    p.parse;
    return
end

%REMOVE LAST CHARACTER IF COMMA
if strcmp(VARGSTR(end),',')
    VARGSTR(end)=[];
end

%PARSE MASTER STRING IF PARAMS
str=['parse(p,' VARGSTR ');'];
eval(str);
