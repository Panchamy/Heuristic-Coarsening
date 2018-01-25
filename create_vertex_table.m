function [shape, vertex] = create_vertex_table(shape)

%This function creates vertex or node table from the shape struct. This
%assumes the shape struct to contain column X and Y with coordinates. If
%column names of your shape file is different, change where there is a <-
%also add the node id to the shape struct

%create vertex or nodes from shape file
all_vertex = [];
for i = 1:length(shape)
    all_vertex(end+1,:) = [shape(i).X(1); shape(i).Y(1)]';                      % <- X and Y coordinates
    all_vertex(end+1,:) = [shape(i).X(end-1); shape(i).Y(end-1)]';              % <- X and Y coordinates
end
unique_vertex = unique(all_vertex,'rows');
unique_vertex(~any(~isnan(unique_vertex), 2),:)=[];
vertex = struct;
for i = 1:length(unique_vertex)
    vertex(i).id = i;
    vertex(i).coordinates = unique_vertex(i,:);
end

%%
%add vertex id to shape
all_vertex = reshape([vertex.coordinates], 2, [])';
all_vertex_ids = [vertex.id];
[all_vertex_sorted, sortInds] = sortrows(all_vertex);
all_vertex_ids = all_vertex_ids(sortInds);
%%The last elements are not searched
all_vertex_sorted = [all_vertex_sorted; (max(all_vertex(:))*10).*ones(5,2)];
for i = 1:length(shape)
    current = [];
    current(end+1,:) = [shape(i).X(1); shape(i).Y(1)]';                         % <- X and Y coordinates
    current(end+1,:) = [shape(i).X(end-1); shape(i).Y(end-1)]';                 % <- X and Y coordinates
    current(~any(~isnan(current), 2),:)=[];
    index = ismember_custom(current, all_vertex_sorted);
    shape(i).vertex_ids = all_vertex_ids(index);
end

end