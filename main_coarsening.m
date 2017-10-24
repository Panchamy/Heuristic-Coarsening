%% load network or create network
% main_create_network             % <- uncomment to create network and then load network
load('network.mat');
%intialize weights. Here the weights are the type
weights = [];
for i = 1:length(links)
    weights(i) = min(links(i).type);
end
%Intialize parameters
exempt_ids = [];
relax_contraints = 1;           % 0 if you need to reduce the number of nodes, 1 if you need to reduce the number of links
pruning = 0;                    % 0 if connectivity should remain the same, 1 to get more connected and compact network
threshold = 1000;               % 0 is the minimum threshold
iterations = 1;              % number of iterations - 1 is the minimum

%% coarsening framework
tic;
[new_links, new_vertex, new_weights] = coarsening(links, vertex, weights, exempt_ids, pruning, threshold, iterations, relax_contraints);
toc;

%% Results
display('Network Reduction - ');
display(perc_reduction);
%Visualise the results
plot_network(links, vertex);
plot_network(new_links, new_vertex);
perc_reduction = (1 - (length(new_links)/length(links))) * 100;
