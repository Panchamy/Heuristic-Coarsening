function [new_links, new_vertex, new_weights] = coarsening(links, vertex, weights, params)

iterations = params.iterations;
new_links = links; new_vertex = vertex; new_weights = weights;
flag = 1;
prev_links = new_links;
iter = 0;
while flag == 1 && iter<iterations
    [new_links, new_vertex, new_weights] = combine_links(new_links, new_vertex, new_weights, params);
    used_nodes = find([new_vertex.neighbor_length] > 0);
    if length(prev_links) == length(new_links) || length(used_nodes) <= 20
        flag = 0;
    else
        flag = 1;
    end
    prev_links = new_links;
    iter = iter + 1;
end

end