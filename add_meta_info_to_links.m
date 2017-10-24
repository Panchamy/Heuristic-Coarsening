function links = add_meta_info_to_links(links, shape, lookuptable)

%This function add meta information to the links table from the shape struct 
% The meta information includes like external link id, in this case osm id 
%and convert the ordinal road type into numerical values based on the lookup 
%table. This assumes the shape struct to contain numerical column osm_id and 
% string column type . If column names of your shape file is different, 
%change where there is a <-

%add section details
all_link_ids = [links.id];
all_link_ids = [all_link_ids, (max(all_link_ids)*10).*ones(1,5)];
types = [{lookuptable.type}];

for i = 1:length(shape)
    link_ids = [shape(i).link_ids];
    index = ismembc2(link_ids, all_link_ids);
    type_index = find(strcmp(types, shape(i).type));                        % <-
    for j = 1:length(index)
        if isfield(links, 'osm_id')
            links(index(j)).osm_id = unique([links(index(j)).osm_id, shape(i).osm_id]);         % <-
            links(index(j)).type = unique([links(index(j)).type, lookuptable(type_index).id]);  % <- 
        else
            links(index(j)).osm_id = shape(i).osm_id;                       % <-
            links(index(j)).type = lookuptable(type_index).id;              % <-
        end
    end    
end

ids = [];
for i = 1:length(links)
    if isempty(links(i).osm_id)                                             % <-
        ids = [ids i];
    end
end
links(ids) = [];

end