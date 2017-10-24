function vertex = add_vertex_neighbors(vertex, links)
%This function add the links neighbors of a vertex to the vertex table

all_o_nodes = [links.o_node];
all_d_nodes = [links.d_node];
[all_o_nodes_sorted, sortOInds] = sort(all_o_nodes);
[all_d_nodes_sorted, sortDInds] = sort(all_d_nodes);

for i = 1:length(vertex)
    sucIDs = ismember1D(vertex(i).id, all_o_nodes_sorted, sortOInds);
    preIDs = ismember1D(vertex(i).id, all_d_nodes_sorted, sortDInds);
    vertex(i).predecessors = [links(preIDs).id];
    vertex(i).successors = [links(sucIDs).id];
    vertex(i).neighbor_length = length(vertex(i).predecessors) + length(vertex(i).successors);
end

end