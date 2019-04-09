%create the coarsened links and nodes from the link table and node table 
%created from shape files. The network of Amsterdam is saved in folder as
%network-reduction.mat. You can create your own network in 
%main_create_network.m script file

% Coarsening Function
% [new_links, new_vertex, new_weights] = coarsening(links, vertex, weights, exempt_ids, pruning, threshold, iterations, constraint_links, flag_intersection)
% Parameters
% flag_study_area   - default is 0; 0 if you need to coarsen the whole   
%                     area (exempt_ids is empty), 1 for the study area 
%                     application where all nodes in the study area  
%                     (defined in exempt_ids) are preserved. 
% flag_intersection - default is 0; 0 if you want to coarsen all nodes, 
%                     1 for the intersection application where all nodes  
%                     other than the intersections are collapsed.
% constraint_links  - default is 1; 0 if you need to reduce the number of 
%                     nodes, 1 if you need to reduce the number of links
% pruning           - default is 0; 0 for pruning disabled, 1 for pruning enabled
% threshold         - 0 is the minimum threshold, maximum is variance(1,36)
%                     in case of using road type as the weights
% iterations        - 1 is the minimum threshold, set a high value for 
%                     maximum iterations. The iterations will be stopped 
%                     automatically when it converges.

%% 
%load network or create network
% main_create_network                                                       % <- uncomment to create Amsterdam network and then load network
load('network.mat');

%initialize weights. Here the weights are the road type
weights = [];
for i = 1:length(links)
    weights(i) = min(links(i).type);
end   

%intialize the exempt ids
flag_study_area = 0;
flag_intersection = 0;
exempt_ids = [];

if flag_study_area == 1
    load('study_area_boundary.mat');                                        % sample study area boundary of amsterdam
    exempt_ids = define_study_area(vertex, lat_min, lat_max, lon_min, lon_max);
end

% coarsening framework
[new_links, new_vertex, new_weights] = coarsening(links, vertex, weights, exempt_ids, 0, 1000, 1000, 1, flag_intersection);

%Save results
save('network-reduction.mat', 'new_links', 'new_vertex', 'new_weights');

% %Visualise the results
% plot_network(links, vertex);
% figure; plot_network(new_links, new_vertex);