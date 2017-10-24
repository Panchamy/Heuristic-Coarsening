function new_nodes = sort_nodes(nodes)

%sort the nodes for heirarchial contraction
[~, ind]=sort([nodes.neighbor_length]);
new_nodes = nodes(ind);

end