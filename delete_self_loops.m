function [links, weights] = delete_self_loops(links, weights, exempt_ids)

    o_nodes = [links.o_node];
    d_nodes = [links.d_node];
    if isempty(exempt_ids)
        indexes = find(o_nodes ~= d_nodes);
        links = links(indexes);
        weights = weights(indexes);
    else
        indexes = find(o_nodes == d_nodes);
        [indexo,~] = ismember(o_nodes(indexes), exempt_ids);
        [indexd,~] = ismember(d_nodes(indexes), exempt_ids);
        c = indexo | indexd;
        d = setdiff(indexes, indexes(c));
        links(d) = [];
        weights(d) = [];
    end
    
    [links, weights] = delete_duplicate_edges(links, weights);
    
end