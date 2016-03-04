
dst_img = imread('distroted_image.bmp');
org_img = imread('original_image.bmp');
msk_img = imread('mask_image.bmp');



beta = 1;
h = size(msk_img,1);
w = size(msk_img,2);
pois = find(msk_img == 255);
poix = floor(pois / h);
poiy = pois - poix * h;
poix = poix + 1;

err1 = zeros(1,100);
err2 = zeros(1,100);
err3 = zeros(1,100);
for c = 1:3
    org_one = org_img(:,:,c);
    for m = 1:2
        tmp_img = dst_img(:,:,c);
        err0 = mean((double(org_one(pois)) - double(tmp_img(pois))) .^ 2)
        for s = 1:100
            beta = min(0.05 + s * 0.05,1);
            for i = 1:length(pois)
                x = poix(i);
                y = poiy(i);
                r = rand(1);

                bound = double([tmp_img(y-1,x) tmp_img(y+1,x) tmp_img(y,x-1) tmp_img(y,x+1)]);
                bound = ones(256,1) * bound;
                bound = bound - [0:255]' * ones(1,4);
                if (m == 1)
                    bound = abs(bound);
                else
                    bound = bound .^ 2;
                end
                bound = sum(bound,2);
                prob = -beta * bound;
                prob = prob - max(prob);
                prob = exp(prob);
                prob = prob / sum(prob);
                temp = 0;
                for j = 1:256
                    temp = temp + prob(j);
                    if (r <= temp)
                        tmp_img(y,x) = j - 1;
                        break;
                    end
                end
            end
            err = mean((double(org_one(pois)) - double(tmp_img(pois))) .^ 2)
            if (m == 1)
                err1(s) = err;
            else
                err2(s) = err;
            end
            imshow(tmp_img,[]);
            drawnow;
            if (m == 1 && s == 20)
                set(gcf,'PaperUnits','inches','PaperPosition',[0 0 20 14]);
                print('-dpng', 'plot1_20.png');
            end
            if (m == 2 && s == 20)
                set(gcf,'PaperUnits','inches','PaperPosition',[0 0 20 14]);
                print('-dpng', 'plot2_20.png');
            end
            if (m == 1 && s == 100)
                set(gcf,'PaperUnits','inches','PaperPosition',[0 0 20 14]);
                print('-dpng', 'plot1_100.png');
            end
            if (m == 2 && s == 100)
                set(gcf,'PaperUnits','inches','PaperPosition',[0 0 20 14]);
                print('-dpng', 'plot2_100.png');
            end
        end
    end
    
end
%%
tmp_img = double(dst_img(:,:,1));
cen_img = tmp_img;
for s = 1:100
    cen_img(2:end-1,2:end-1) = -4 * tmp_img(2:end-1,2:end-1) + tmp_img(1:end-2,2:end-1) ...
        + tmp_img(3:end,2:end-1) + tmp_img(2:end-1,1:end-2) + tmp_img(2:end-1,3:end);
    tmp_img(pois) = tmp_img(pois) + cen_img(pois) * 0.25;
    err = mean((double(org_one(pois)) - double(tmp_img(pois))) .^ 2)
    err3(s) = err;
    imshow(tmp_img,[0 255]);
    drawnow;
    if (s == 20)
        set(gcf,'PaperUnits','inches','PaperPosition',[0 0 20 14]);
        print('-dpng', 'plot3_20.png');
    elseif (s == 100)
        set(gcf,'PaperUnits','inches','PaperPosition',[0 0 20 14]);
        print('-dpng', 'plot3_100.png');
    end
end
h = plot(0:20,[err0 err1(1:20);err0 err2(1:20);err0 err3(1:20)]);
ylabel('Per Pixel Error','FontSize',22);
xlabel('Iterations','FontSize',22);
set(h(1),'linewidth',2);
set(h(2),'linewidth',2);
set(h(3),'linewidth',2);
legend({'Gibbs Sampler L1 norm','Gibbs Sampler L2 norm','PDE Heat Equation'},'FontSize',22);
set(gca,'FontSize',17);
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 20 14]);
print('-dpng', 'plot.png');
tmp_img = double(dst_img);
cen_img = tmp_img;
poisss = [pois;pois+numel(dst_img)/3;pois+numel(dst_img)/3*2];
for s = 1:100
    cen_img(2:end-1,2:end-1,:) = -4 * tmp_img(2:end-1,2:end-1,:) + tmp_img(1:end-2,2:end-1,:) ...
        + tmp_img(3:end,2:end-1,:) + tmp_img(2:end-1,1:end-2,:) + tmp_img(2:end-1,3:end,:);
    tmp_img(poisss) = tmp_img(poisss) + cen_img(poisss) * 0.25;
    err = mean((double(org_one(pois)) - double(tmp_img(pois))) .^ 2)
    imshow(uint8(tmp_img));
    drawnow;
end
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 20 14]);
print('-dpng', 'plot3_100.png');