mex getHistogram.c
mex Julesz.c
addpath ../Images
im_width = 256;
im_height = 256;
num_bins = 15;

rows = 4;
columns = 8;
sizes = 64;
margins = 4;
deltas = sizes + margins;

w = [8 7 6 5 4 3 2 1 2 3 4 5 6 7 8];
% w = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

% pic = rgb2gray(imread('fur_obs.jpg'));
% pic = int32(imresize(pic(2:end,1:end-1),[im_height im_width]));
% pic = int32(imresize(rgb2gray(imread('stucco.bmp')),[im_height im_width]));
% pic = idivide(pic, 32, 'floor');
pic = int32(imresize(imread('grass_obs.bmp'),[im_height im_width]));

[F, filters, width, height] = myfilters; %Calculate filter sets.
width = int32(width);
height = int32(height);

num_filters = size(filters,1);
lower = zeros(1,num_filters);
upper = zeros(1,num_filters);

filter_img = zeros(rows * deltas + margins, columns * deltas + margins);
for i = 1:num_filters
    row = floor((i - 1) / columns);
    column = mod(i - 1, columns);
    position_row = row * deltas + margins;
    position_column = column * deltas + margins;
    filter_i = F{i};
    maxx = max(max(filter_i));
    minn = min(min(filter_i));
    if (maxx ~= minn)
        filter_i = (filter_i - minn) / (maxx - minn);
    end
    filter_img(position_row + 1:position_row + sizes, position_column + 1:position_column + sizes) = imresize(filter_i, [sizes sizes]);
end
imshow(filter_img, [0 1]);

for i = 1:num_filters
    if (i == 26)
        i = 26;
    end
    filter = reshape(filters(i,1:width(i) * height(i)),height(i),width(i));
    cpic = repmat(double(pic),2,2);
    result = conv2(cpic,filter,'valid');
    lower(i) = min(min(result));
    % lower(i) = -4;
    upper(i) = max(max(result));
    % upper(i) = 4;
end
last = randi(8, 256, 256,'int32') - 1;

unchosen_filters = 1:num_filters;
chosen_filters = [];
org_histo = getHistogram(pic, filters(unchosen_filters, :)', width(unchosen_filters), height(unchosen_filters), lower(unchosen_filters), upper(unchosen_filters)); %Compute histograms.
org_histo = reshape(org_histo, num_bins, length(unchosen_filters));
diff_history = [];
for i = 1:num_filters
    % f_index = 1:num_filters;
    f_index = find(unchosen_filters ~= 0);
    histo = getHistogram(last, filters(f_index, :)', width(f_index), height(f_index), lower(f_index), upper(f_index)); %Compute histograms.
    histo = reshape(histo, num_bins, length(f_index));
    diff_histo = abs(org_histo(:,f_index) - histo);
    diff_histo = w * diff_histo;
    [~, index] = max(diff_histo);
    index = f_index(index);
    
    unchosen_filters(index) = 0;
    chosen_filters = [chosen_filters index];
    chosen_org_histo = abs(org_histo(:,chosen_filters));
    histo = Julesz(chosen_org_histo, filters(chosen_filters, :)', width(chosen_filters), height(chosen_filters), lower(chosen_filters), upper(chosen_filters), w, last); %Sampling.
    syn_org_histo = histo' * im_width * im_height;
    
    diff_histo = abs(chosen_org_histo - syn_org_histo);
    diff_histo = w * diff_histo / num_bins;
    diff_histo = mean(diff_histo);
    
    diff_history = [diff_history diff_histo];
    plot(diff_history);
    drawnow;
    imwrite(uint8(last * 32 + 15), ['syn',num2str(i),'.bmp'], 'bmp');
end

% temp_histo = abs(org_histo);
% histo2 = Julesz(reshape(temp_histo', 15, 1), filters(1, :)', width(1), height(1), lower(1), upper(1), w, last); %Sampling.
% imwrite(uint8(last2 * 32 + 15), 'syn1.bmp', 'bmp');

% histo2 = getHistogram(pic, filters(1:2, :)', width(1:2), height(1:2), lower(1:2), upper(1:2));
% [last, histo2a] = Julesz(reshape(histo2', 15, 2), filters(1:2, :)', width(1:2), height(1:2), lower(1:2), upper(1:2), w, last);
% imwrite(uint8(last * 32 + 15), 'syn2.bmp', 'bmp');
% 
% histo3 = getHistogram(pic, filters(1:3, :)', width(1:3), height(1:3));
% [synthesized3, histo3a] = Julesz(reshape(histo3', 15, 3), filters(1:3, :)', width(1:3), height(1:3));
% imwrite(uint8(synthesized3 * 32 + 15), 'syn3.bmp', 'bmp');
% 
% histo4 = getHistogram(pic, filters(1:4, :)', width(1:4), height(1:4));
% [synthesized4, histo4a] = Julesz(reshape(histo4', 15, 4), filters(1:4, :)', width(1:4), height(1:4));
% imwrite(uint8(synthesized4 * 32 + 15), 'syn4.bmp', 'bmp');
% 
% histo5 = getHistogram(pic, filters(1:5, :)', width(1:5), height(1:5));
% [synthesized5, histo5a] = Julesz(reshape(histo5', 15, 5), filters(1:5, :)', width(1:5), height(1:5));
% imwrite(uint8(synthesized5 * 32 + 15), 'syn5.bmp', 'bmp');
