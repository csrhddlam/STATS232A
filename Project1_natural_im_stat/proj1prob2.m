clear;
dir = dir('*.jpg');
figure(1); hold on;
figure(2); hold on;
for k = 1:length(dir)
    img = imread(dir(k).name);
    gray = rgb2gray(img);
%     fftt = fft2(gray,4 * size(gray,1),4 * size(gray,2));
    fftt = fft2(gray);
    valid = fftt(1:round(size(fftt,1)/2),1:round(size(fftt,2)/2));
    A = abs(valid);
    A(1,:) = A(1,:) / 4;
    A(:,1) = A(:,1) / 4;
    A2 = A .* A;
%     maxf = sqrt(min(size(A)).^2 + 1);
    Af2 = zeros(1,min(size(A)));
    for i = 1:size(A,1)
        for j = 1:size(A,2)
            n = floor(sqrt((i-1) .^ 2 + (j-1) .^ 2)) + 1;
            if (n <= min(size(A)))
                Af2(n) = Af2(n) + A2(i,j);
            end
        end
    end
    Af = sqrt(Af2);
    fs = 1:1:min(size(A));
    figure(1);
    plot(log(fs(2:end)),log(Af(2:end)));
    
    Sf = zeros(1,floor(min(size(A))/2));
    for i = 1:length(Af)
        Sf(round((i-1)/2)+1:min(i,length(Sf))) = Sf(round((i-1)/2)+1:min(i,length(Sf))) + Af2(i);
    end
    fs = 1:floor(min(size(A))/2);
    figure(2);
    plot(fs(20:end),Sf(20:end));
end
figure(1);
ylabel('log A(f)','FontSize',22);
xlabel('log f','FontSize',22);
legend({'image 1','image 2','image 3','image 4'},'FontSize',22);
set(gca,'FontSize',17);
set(gcf,'PaperPosition',[0 0 16 9]);
print('-depsc2', 'Af.eps');

figure(2);
ylabel('S(f0)','FontSize',22);
xlabel('f0','FontSize',22);
legend({'image 1','image 2','image 3','image 4'},'FontSize',22);
set(gca,'FontSize',17);
set(gcf,'PaperPosition',[0 0 16 9]);
print('-depsc2', 'Sf.eps');