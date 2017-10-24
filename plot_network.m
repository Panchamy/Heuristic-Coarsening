function plot_network(links, vertex)

all_nodes = [vertex.id];
for i = 1:length(links)
    [~, o_index] = ismember(links(i).o_node, all_nodes);
    [~, d_index] = ismember(links(i).d_node, all_nodes);
    a = vertex(o_index).coordinates;
    b = vertex(d_index).coordinates;
    lh = plot([a(1) b(1)],[a(2) b(2)], '-');
    lh.Color = [0 0 1];
    lh.LineWidth = 0.5;
    axis off;
    set(gcf,'color','w');
    hold on;
end

end