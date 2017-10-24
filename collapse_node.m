function [links, nodes, weights, A, max_link_id] = collapse_node(links, nodes, weights, A, node_id, max_link_id, incoming_index, outgoing_index, pruning)

node_ids = [];
[p,q] = meshgrid(incoming_index, outgoing_index);
index_pairs = [p(:) q(:)];
A(node_id, :) = 0;
A(:, node_id) = 0;
for i = 1:size(index_pairs, 1)
    if (pruning == 0) || (links(index_pairs(i,1)).o_node ~= links(index_pairs(i,2)).d_node)
        links(end+1) = links(index_pairs(i,1));
        links(end).id = max_link_id;
        links(end).d_node = links(index_pairs(i,2)).d_node;
        links(end).distance = links(index_pairs(i,1)).distance + links(index_pairs(i,2)).distance;
        links(end).weight = mean([weights(index_pairs(i,1)), weights(index_pairs(i,2))]);
        links(end).removed_nodes = [links(index_pairs(i,1)).removed_nodes, links(index_pairs(i,2)).removed_nodes, node_id];
        links(end).removed_links = [links(index_pairs(i,1)).removed_links, links(index_pairs(i,2)).removed_links, links(index_pairs(i,1)).id, links(index_pairs(i,2)).id];
        weights(end+1) = links(end).weight;
        max_link_id = max_link_id + 1;
        A(links(end).o_node, links(end).d_node) = 1;
        node_ids = [node_ids, links(end).o_node, links(end).d_node];
    end
end
indexes = [p(:); q(:)];
links(indexes) = [];
weights(indexes) = [];
node_ids = [node_ids, node_id];

end