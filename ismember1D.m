function index = ismember1D(A, Bs, sortInds)
%B is a 1D vector which does not need to be unique and A is a single value
[~,firstInds] = builtin('_ismemberhelper',A,Bs);
lastInds = ismembc2(A,Bs);
if (firstInds == 0) || (lastInds == 0)
    index = [];
else
    index = sortInds(firstInds:lastInds);
end

end