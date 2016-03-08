function [] = visualize_filters(net,category)
 
weights = net.layers{1}.weights{1};
minw = min(min(min(min(weights))));
maxw = max(max(max(max(weights))));
weights = (weights - minw) / (maxw - minw);
 
rows = 10;
columns = 10;
sizes = 90;
margins = 10;
deltas = sizes + margins;
 
filter_img = zeros(rows * deltas + margins, columns * deltas + margins, 3);
for i = 1:size(weights,4)
    row = floor((i - 1) / columns);
    column = mod(i - 1, columns);
    position_row = row * deltas + margins;
    position_column = column * deltas + margins;
    weight = weights(:,:,:,i);
    maxx = max(max(max(weight)));
    minn = min(min(min(weight)));
    if (maxx ~= minn)
        % weight = (weight - minn) / (maxx - minn);
    end
    filter_img(position_row + 1:position_row + sizes, position_column + 1:position_column + sizes, :) = imresize(weight, [sizes sizes], 'nearest');
end
% figure;
% imshow(filter_img, [0 1]);
save([category, '.png']);
imwrite(filter_img, [category, '.png']);