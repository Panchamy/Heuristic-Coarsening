function S = check_connectivity_faster(G)

% Gt = speye(size(G));
% Gtt = G + Gt;
% %How many connex component?
% [~,~,r] = dmperm(Gtt);
% S = numel(r)-1;
%C = cumsum(full(sparse(1,r(1:end-1),1,1,size(G,1))));
%C(p) = C;

[S, ~] = graphconncomp(G, 'Weak', true);

end