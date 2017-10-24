function [shape, links] = create_links_table(shape, vertex)

%This function creates link table from the updated shape struct which 
%includes the vertex ids. add link id to the shape struct. add link
%distance and neighbors to links.

%create link table
len_way = length(shape);
all_links = cell(1, len_way);
for i = 1:len_way
    o_nodes = shape(i).vertex_ids(1);
    d_nodes = shape(i).vertex_ids(end);
    temp = [o_nodes; d_nodes]';
    all_links{i} = temp;
end

all_links = vertcat(all_links{:});
unique_links = unique(all_links,'rows');

links = struct;
for i = 1:length(unique_links)
    links(i).id = i;
    links(i).o_node = unique_links(i,1);
    links(i).d_node = unique_links(i,2);
end

%%
%add link id to shape struct
all_links = [links.o_node; links.d_node]';
all_link_ids = [links.id];
[all_links_sorted, sortInds] = sortrows(all_links);
%%The last elements are not searched
all_links_sorted = [all_links_sorted; (max(all_links(:))*10).*ones(5,2)];

for i = 1:length(shape)
    o_nodes = shape(i).vertex_ids(1);
    d_nodes = shape(i).vertex_ids(end);
    temp = [o_nodes; d_nodes]';
    index = ismember_custom(temp, all_links);
    shape(i).link_ids = all_link_ids(index);
end

%%
%add length and neighbors to links
all_vertex = [vertex.id];
all_vertex = [all_vertex, (max(all_vertex)*10).*ones(1,5)];
all_o_nodes = [links.o_node];
all_d_nodes = [links.d_node];
[all_o_nodes_sorted, sortOInds] = sort(all_o_nodes);
[all_d_nodes_sorted, sortDInds] = sort(all_d_nodes);

for i=1:length(links)
    o_index = ismembc2(links(i).o_node, all_vertex);
    d_index = ismembc2(links(i).d_node, all_vertex);
    latlon1 = vertex(o_index).coordinates;
    latlon2 = vertex(d_index).coordinates;
    [d1km ~] = lldistkm(latlon1,latlon2);
    links(i).distance = d1km;
    
    links(i).neighbors = [];
    oo_inds = ismember1D(links(i).o_node, all_o_nodes_sorted, sortOInds);
    do_inds = ismember1D(links(i).o_node, all_d_nodes_sorted, sortDInds);
    od_inds = ismember1D(links(i).d_node, all_o_nodes_sorted, sortOInds);
    dd_inds = ismember1D(links(i).d_node, all_d_nodes_sorted, sortDInds);
    all_ids = [oo_inds,do_inds,od_inds,dd_inds];
    unique_ids = unique(all_ids);
    if isempty(unique_ids)
        continue;
    else
        for j = 1:length(unique_ids)
            if unique_ids(j) ~= i && unique_ids(j) ~= 0
                links(i).neighbors = [links(i).neighbors links(unique_ids(j)).id];
            end
        end
    end
end

end