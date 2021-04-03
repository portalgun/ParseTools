function vars=parsePairs(p,varargin)
% good for chaning bad defaults in bulitin functions
% assumes keepUnmatched
    p.KeepUnmatched=1;

    if isempty(varargin) || all(cellfun(@isempty,varargin))
        varargin=cell(0);
        p.parse();
    else
        p.parse(varargin{:});
    end
    vars=horzcat(struct2cells(p.Results),struct2cells(p.Unmatched));
end
