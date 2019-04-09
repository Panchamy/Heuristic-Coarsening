function [links, nodes, weights, A, max_link_id, i] = rulesets(links, nodes, weights, A, max_link_id, i, var_threshold, constraint_links, pruning, flag_intersection)
    
    incoming = nodes(i).predecessors;
    outgoing = nodes(i).successors;
    node_id = nodes(i).id;
    
    if flag_intersection == 0
        shortcut_size = length(incoming) + length(outgoing);
    else
        shortcut_size = 2; % if greater, its an intersection
    end
    
    if isempty(incoming) || isempty(outgoing)
%         %no incoming or outgoing links - no collapse or delete node
        if pruning == 1
            if isempty(incoming)
                outgoing_index = ismember1D_ws(outgoing, [links.id]);
                weights(outgoing_index) = [];
                links(outgoing_index) = [];
            else
                incoming_index = ismember1D_ws(incoming, [links.id]);
                weights(incoming_index) = [];
                links(incoming_index) = [];
            end
        end
        i = i+1;
    else
        [p,q] = meshgrid(incoming, outgoing);
        pairs = [p(:) q(:)];
        if (constraint_links == 1) && (size(pairs, 1) >= shortcut_size)
            %leads to same or larger number of links - no collapse
            i = i+1;
        else
            incoming_index = ismember1D_ws(incoming, [links.id]);
            outgoing_index = ismember1D_ws(outgoing, [links.id]);
            incoming_weight = weights(incoming_index);
            outgoing_weight = weights(outgoing_index);
            [p,q] = meshgrid(incoming_weight, outgoing_weight);
            weight_pairs = [p(:) q(:)]';
            if any(var(weight_pairs)> var_threshold) 
                %the weight doesnot match - no collapse
                i = i+1;
            else
                [links, nodes, weights, A, max_link_id] = collapse_node(links, nodes, weights, A, node_id, max_link_id, incoming_index, outgoing_index, pruning);
                i = i+1;
            end
        end
    end
    
end