function [links, weights] = delete_duplicate_edges(links, weights)

    o_nodes = [links.o_node];
    d_nodes = [links.d_node];
    all_pairs = [[links.o_node];[links.d_node]]';
    [~,indexes ,~] = unique(all_pairs, 'rows');
    duplicate_ind = setdiff(1:length(links), indexes);
    for i = 1:length(duplicate_ind)
        ind = duplicate_ind(i);
        o_node = links(ind).o_node;
        d_node = links(ind).d_node;
        index = ((o_nodes == o_node)&(d_nodes == d_node));
        min_distance = min([links(index).distance]);     %assign the minimum distance for the new edge
        max_weight = max(weights(index));                %assign the maximum weight for the new edge
        rem_nodes = [links(index).removed_nodes];
        rem_links = [links(index).removed_links];
        [links(index).distance] = deal(min_distance);
        [links(index).removed_nodes] = deal(rem_nodes);
        [links(index).removed_links] = deal(rem_links);
        weights(index) = max_weight;
    end
    links = links(indexes);
    weights = weights(indexes);
    
end