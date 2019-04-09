function [links, nodes, weights] = combine_links(links, nodes, weights, params)

% extract the necessary parameter values
exempt_ids = params.exempt_ids;
pruning = params.pruning;

% combine links with one neighbor and similar speed
nodes = sort_nodes(nodes);
[links, weights] = remove_duplicate_edges(links, weights);
G = digraph([links.o_node], [links.d_node]);

if isfield(links,'removed_nodes')
    checked_nodes = unique([links.removed_nodes]);
%     G = rmnode(G,removed_nodes);
else
    checked_nodes = [];%uint64([]);
    [links(:).removed_nodes] = deal([]);
    [links(:).removed_links] = deal([]);
end
unused_nodes = setdiff([1:size(G.Nodes,1)], unique([[links.o_node], [links.d_node]]));
G = rmnode(G,unused_nodes);
A = adjacency(G);
max_link_id = max([links.id])+1;
initial_S = check_connectivity_faster(A);
exempt_ids = sort(exempt_ids);

%%
if pruning == 1
    all = find([nodes.neighbor_length] > 0);
else
    all = find([nodes.neighbor_length] > 1);
end
i = all(1);
prev_links = links;
prev_weights = weights;

while 1
    if i > length(nodes)
        break;
    end 
    if (ismembc2(nodes(i).id, exempt_ids)) || any(ismember1D_ws(nodes(i).id, checked_nodes))        
        i = i+1;
    else
        all_link_ids = [nodes(i).predecessors, nodes(i).successors];
        checked_nodes = [checked_nodes, nodes(i).id];
        if isempty(all_link_ids)
            i = i+1;
        else
            [links, nodes, weights, A, max_link_id, i] = rulesets(links, nodes, weights, A, max_link_id, i, params);
        end     
    end 
end

%%
[links, weights] = delete_duplicate_edges(links, weights);
G = digraph([links.o_node], [links.d_node]);
unused_nodes = setdiff([1:size(G.Nodes,1)], unique([[links.o_node], [links.d_node]]));
G = rmnode(G,unused_nodes);
A = adjacency(G);
S_conn = check_connectivity_faster(A);
if (S_conn == initial_S)
else
    display('Links were pruned');
end
if pruning == 1
    [links, weights] = delete_end_nodes(links, weights, nodes, exempt_ids);
    [links, weights] = delete_self_loops(links, weights, exempt_ids);
end
links = add_link_neighbors(links);
nodes = add_vertex_neighbors(nodes, links);

end
