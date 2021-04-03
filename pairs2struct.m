function S=pairs2struct(pairs)
S=struct();
for i = 1:2:length(pairs)
    S.(pairs{i})=pairs{i+1};
end
