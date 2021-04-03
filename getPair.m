function [val,varargin]=getPair(name,varargin)
    ind=find(cellfun(@(x) isequal(x,name),varargin));
    if ~isempty(ind)
        val=varargin{ind+1};
        varargin(ind+1)=[];
        varargin(ind)=[];
    else
        val=0;
    end
