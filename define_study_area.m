function exempt_ids = define_study_area(vertex, lat_min, lat_max, lon_min, lon_max)
    
    xv = [lat_min lat_min lat_max lat_max lat_min];
    yv = [lon_min lon_max lon_max lon_min lon_min];
    coords = reshape([vertex.coordinates], 2, [])';
    xq = coords(:,1);
    yq = coords(:,2);
    in = inpolygon(coords(:,1),coords(:,2),xv,yv);
    exempt_ids = [vertex(in).id];
    
end