function index = ismember_custom(A, B)

[Bs, sortInds] = sort(B);
[~,firstInds] = builtin('_ismemberhelper',A,Bs);
lastInds = ismembc2(A,Bs);
allInds = arrayfun(@(x,y)sortInds(x:y-(x==0)),firstInds(:,1),lastInds(:,1),'uni',0);
cellsz = cellfun(@(x) length(x)>1,allInds,'uni',false);
temp = (cell2mat(cellsz) == 1);
if any(temp)
    for i = 1:length(temp)
        if temp(i) == 1
            allInds{i} = allInds{i}(ismembc2(A(i, 2), B(allInds{i}, 2)));
        end
    end
end
index = cell2mat(allInds);

end