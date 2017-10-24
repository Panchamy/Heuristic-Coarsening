function index = ismember1D_ws(A, B)
%B have to be unique, A can be a 1D vector
[Bs, sortInds] = sort(B);
% [~,firstInds] = builtin('_ismemberhelper',A,Bs);
lastInds = ismembc2(A,Bs);
if any(lastInds == 0)
    index = [];
else
    index = sortInds(lastInds);
end

end