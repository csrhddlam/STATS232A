clear;
N = 1000000;
worldmin = -1024;
worldmax = 2048;
x_m = 1;
shapeInserter = vision.ShapeInserter('Shape','Lines');

data = zeros(N,4);
data(:,1) = rand(N,1) * (worldmax - worldmin);
data(:,2) = rand(N,1) * (worldmax - worldmin);
data(:,3) = rand(N,1) * pi;
data(:,4) = x_m ./ sqrt(rand(N,1));
data(data(:,4) < 1,:) = [];

x1 = data(:,1) - data(:,4) .* cos(data(:,3));
x2 = data(:,1) + data(:,4) .* cos(data(:,3));
y1 = data(:,2) - data(:,4) .* sin(data(:,3));
y2 = data(:,2) + data(:,4) .* sin(data(:,3));
im1024 = ones(1024);
im1024 = step(shapeInserter, im1024, [x1 y1 x2 y2]);
% figure; imshow(im1024);

data(:,1) = data(:,1) / 2;
data(:,2) = data(:,2) / 2;
data(:,4) = data(:,4) / 2;
data(data(:,4) < 1,:) = [];
x1 = data(:,1) - data(:,4) .* cos(data(:,3));
x2 = data(:,1) + data(:,4) .* cos(data(:,3));
y1 = data(:,2) - data(:,4) .* sin(data(:,3));
y2 = data(:,2) + data(:,4) .* sin(data(:,3));
im512 = ones(512);
im512 = step(shapeInserter, im512, [x1 y1 x2 y2]);
% figure; imshow(im512);

data(:,1) = data(:,1) / 2;
data(:,2) = data(:,2) / 2;
data(:,4) = data(:,4) / 2;
data(data(:,4) < 1,:) = [];
x1 = data(:,1) - data(:,4) .* cos(data(:,3));
x2 = data(:,1) + data(:,4) .* cos(data(:,3));
y1 = data(:,2) - data(:,4) .* sin(data(:,3));
y2 = data(:,2) + data(:,4) .* sin(data(:,3));
im256 = ones(256);
im256 = step(shapeInserter, im256, [x1 y1 x2 y2]);
% figure; imshow(im256);

xy10241 = randi(1024-127,1,2)-1;
xy10242 = randi(1024-127,1,2)-1;
xy5121 = randi(512-127,1,2)-1;
xy5122 = randi(512-127,1,2)-1;
xy2561 = randi(256-127,1,2)-1;
xy2562 = randi(256-127,1,2)-1;
im1 = im1024(xy10241(1)+1:xy10241(1)+128,xy10241(2)+1:xy10241(2)+128);
im2 = im1024(xy10242(1)+1:xy10242(1)+128,xy10242(2)+1:xy10242(2)+128);
im3 = im512(xy5121(1)+1:xy5121(1)+128,xy5121(2)+1:xy5121(2)+128);
im4 = im512(xy5122(1)+1:xy5122(1)+128,xy5122(2)+1:xy5122(2)+128);
im5 = im256(xy2561(1)+1:xy2561(1)+128,xy2561(2)+1:xy2561(2)+128);
im6 = im256(xy2562(1)+1:xy2562(1)+128,xy2562(2)+1:xy2562(2)+128);
figure;
subplot(2,3,1); imshow(im1); title('Crop from 1024×1024','FontSize',20);
subplot(2,3,4); imshow(im2); title('Crop from 1024×1024','FontSize',20);
subplot(2,3,2); imshow(im3); title('Crop from 512×512','FontSize',20);
subplot(2,3,5); imshow(im4); title('Crop from 512×512','FontSize',20);
subplot(2,3,3); imshow(im5); title('Crop from 256×256','FontSize',20);
subplot(2,3,6); imshow(im6); title('Crop from 256×256','FontSize',20);

set(gcf,'PaperPosition',[0 0 16 9]);
print('-depsc2', 'prob3.eps');