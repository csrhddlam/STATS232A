clear;
dir = dir('*.jpg');
img = cell(length(dir),1);
gdt = cell(length(dir),1);
bin = -31:1:31;
lengths = zeros(length(dir),1);

for i = 1:length(dir)
    img{i} = imread(dir(i).name);
    img{i} = rgb2gray(img{i});
    img{i} = idivide(img{i}, 8, 'floor');
end

strides = [1 2 4 8];
hst = cell(length(strides),1);
hst_noise = cell(length(strides),1);
meann = zeros(2,4);
varr = zeros(2,4);
kurtosiss = zeros(2,4);

for k = 1:2
    if k == 2
        for i = 1:length(dir)
            img{i} = randi(32, size(img{i})) - 1;
        end
    end
    for j = 1:length(strides)
        stride = strides(j);
        for i = 1:length(dir)
            gradient = convn(img{i},[-ones(stride) ones(stride)] ./ (stride * stride),'valid');
            gdt{i} = gradient(1:stride:end,1:stride:end) ;
            lengths(i) = numel(gdt{i});
        end
        temp = 0;
        total_gdt = zeros(sum(lengths),1);
        for i = 1:length(dir)
            total_gdt(temp+1:temp+lengths(i)) = reshape(gdt{i},lengths(i),1);
            temp = temp + lengths(i);
        end
        if k == 1
            hst{j} = hist(total_gdt,bin) / length(total_gdt);
        else
            hst_noise{j} = hist(total_gdt,bin) / length(total_gdt);
        end
        meann(k,j) = mean(total_gdt);
        varr(k,j) = var(total_gdt);
        kurtosiss(k,j) = kurtosis(total_gdt);
    end
end

x = lsqcurvefit(@myfun,[1 1],bin,hst{1});
curve = myfun(x,bin);

norm1 = normpdf(bin,meann(1,1),sqrt(varr(1,1)));
norm2 = normpdf(bin,meann(2,1),sqrt(varr(2,1)));
norm3 = normpdf(bin,meann(2,4),sqrt(varr(2,4)));
%%
% figure;
% plot(bin,hst{1});
% ylabel('Frequency','FontSize',22);
% xlabel('Gray level difference','FontSize',22);
% set(gca,'FontSize',17);
% figure;
% semilogy(bin,hst{1});
% ylabel('Frequency','FontSize',22);
% xlabel('Gray level difference','FontSize',22);
% set(gca,'FontSize',17);

figure;
plot(bin,[hst{1};curve;norm1],'LineWidth',2);
ylabel('Frequency','FontSize',22);
xlabel('Gray level difference','FontSize',22);
legend({'Histogram','Generalized Gaussian','Gaussian'},'FontSize',22);
set(gca,'FontSize',17);
set(gcf,'PaperPosition',[0 0 16 9]);
print('-depsc2', 'step1234.eps');
figure;
semilogy(bin,[hst{1};curve;norm1]);
ylabel('Frequency','FontSize',22);
xlabel('Gray level difference','FontSize',22);
legend({'Histogram','Generalized Gaussian','Gaussian'},'FontSize',22);
set(gca,'FontSize',17);
set(gcf,'PaperPosition',[0 0 16 9]);
print('-depsc2', 'step1234log.eps');

figure;
plot(bin,[hst{1};hst{2};hst{3};hst{4}]);
ylabel('Frequency','FontSize',22);
xlabel('Gray level difference','FontSize',22);
legend({'Original','2*2 Average','4*4 Average','8*8 Average'},'FontSize',22);
set(gca,'FontSize',17);
set(gcf,'PaperPosition',[0 0 16 9]);
print('-depsc2', 'step5.eps');
figure;
semilogy(bin,[hst{1};hst{2};hst{3};hst{4}]);
ylabel('Frequency','FontSize',22);
xlabel('Gray level difference','FontSize',22);
legend({'Original','2*2 Average','4*4 Average','8*8 Average'},'FontSize',22);
set(gca,'FontSize',17);
set(gcf,'PaperPosition',[0 0 16 9]);
print('-depsc2', 'step5log.eps');
%%
% figure;
% plot(bin,hst_noise{1});
% ylabel('Frequency','FontSize',22);
% xlabel('Gray level difference','FontSize',22);
% set(gca,'FontSize',17);
% figure;
% semilogy(bin,hst_noise{1});
% ylabel('Frequency','FontSize',22);
% xlabel('Gray level difference','FontSize',22);
% set(gca,'FontSize',17);

figure;
plot(bin,[hst_noise{1};norm2]);
ylabel('Frequency','FontSize',22);
xlabel('Gray level difference','FontSize',22);
legend({'Histogram','Gaussian'},'FontSize',22);
set(gca,'FontSize',17);
set(gcf,'PaperPosition',[0 0 16 9]);
print('-depsc2', 'step6124.eps');
figure;
semilogy(bin,[hst_noise{1};norm2]);
ylabel('Frequency','FontSize',22);
xlabel('Gray level difference','FontSize',22);
legend({'Histogram','Gaussian'},'FontSize',22);
set(gca,'FontSize',17);
set(gcf,'PaperPosition',[0 0 16 9]);
print('-depsc2', 'step6124log.eps');

figure;
plot(bin,[hst_noise{1};hst_noise{2};hst_noise{3};hst_noise{4}]);
ylabel('Frequency','FontSize',22);
xlabel('Gray level difference','FontSize',22);
legend({'Original','2*2 Average','4*4 Average','8*8 Average'},'FontSize',22);
set(gca,'FontSize',17);
set(gcf,'PaperPosition',[0 0 16 9]);
print('-depsc2', 'step65.eps');
figure;
semilogy(bin,[hst_noise{1};hst_noise{2};hst_noise{3};hst_noise{4}]);
ylabel('Frequency','FontSize',22);
xlabel('Gray level difference','FontSize',22);
legend({'Original','2*2 Average','4*4 Average','8*8 Average'},'FontSize',22);
set(gca,'FontSize',17);
set(gcf,'PaperPosition',[0 0 16 9]);
print('-depsc2', 'step65log.eps');

%%
figure;
plot(bin,[hst_noise{4};norm3]);
ylabel('Frequency','FontSize',22);
xlabel('Gray level difference','FontSize',22);
legend({'8*8 Average Noise','Gaussian'},'FontSize',22);
set(gca,'FontSize',17);
set(gcf,'PaperPosition',[0 0 16 9]);
print('-depsc2', 'add.eps');
figure;
semilogy(bin,[hst_noise{4};norm3]);
ylabel('Frequency','FontSize',22);
xlabel('Gray level difference','FontSize',22);
legend({'8*8 Average Noise','Gaussian'},'FontSize',22);
set(gca,'FontSize',17);
set(gcf,'PaperPosition',[0 0 16 9]);
print('-depsc2', 'addlog.eps');