function [links, weights] = delete_end_nodes(links, weights, nodes, exempt_ids)
    all = find([nodes.neighbor_length] == 1);
    if isempty(exempt_ids)
    else
        [~, indexes] = ismember(exempt_ids, [nodes.id]);
        all = setdiff(all, indexes);
    end
    all_link_ids = [nodes(all).predecessors, nodes(all).successors];
    index = ismember1D_ws(all_link_ids, [links.id]);
    links(index) = [];
    weights(index) = [];
end