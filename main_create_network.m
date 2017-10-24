%create a link table and node table from shape files. You can create a
%directed graph using these tables. If the shape files are from a different
%source or is in a different format other than https://extract.bbbike.org/, 
%check the functions marked with <-. A sample shape file of Amsterdam is 
%attached with this source code

%%
shape = shaperead('shapefiles/roads.shp');
[shape, vertex] = create_vertex_table(shape);                               % <- 
[shape, links] = create_links_table(shape, vertex);
vertex = add_vertex_neighbors(vertex, links);

%%
%if you want to use the type of the road as the weights, you need this part 
%if the shape file already contains numerical value for type, this is not
%necessary
load('lookuptable.mat');                                                    
links = add_meta_info_to_links(links, shape, lookuptable);                  % <-

%%
save('network.mat','shape','links','vertex')
