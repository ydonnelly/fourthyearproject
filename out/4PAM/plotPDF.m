timing = 0.001:0.001:0.01;
a = zeros(length(timing),250);
b = zeros(length(timing),250);

for index=1:length(timing)-1
    a(index,:) = dlmread(strcat('tikhonov/1/octave_',num2str(timing(index),'%.3f'),'_1.txt'));
    b(index,:) = dlmread(strcat('tikhonov/1/octave_',num2str(timing(index),'%.3f'),'_3.txt'));
    for folder=2:5
        a(index,:) = a(index,:) + dlmread(strcat('tikhonov/',num2str(folder),'/octave_',num2str(timing(index),'%.3f'),'_1.txt'));
        b(index,:) = b(index,:) + dlmread(strcat('tikhonov/',num2str(folder),'/octave_',num2str(timing(index),'%.3f'),'_3.txt'));
    end
end
a(10,:) = dlmread(strcat('tikhonov/1/octave_0.01_1.txt'));
b(10,:) = dlmread(strcat('tikhonov/1/octave_0.01_3.txt'));
for folder=2:5
    a(10,:) = a(index,:) + dlmread(strcat('tikhonov/',num2str(folder),'/octave_0.01_1.txt'));
    b(10,:) = b(index,:) + dlmread(strcat('tikhonov/',num2str(folder),'/octave_0.01_3.txt'));
end

size(a)
x = [1.501:0.002:1.999];
size(x)
size(timing)
d_ab = (a-b)/(5*10^7);
y = [d_ab];
size(y)

figure(1)
subplot(1,2,1)
plot(x,y)
grid on
xlim([1.95,2.0])
ylim([-0.0001,0.0001])
legend(num2str(timing,"%.3f\n"))
title('Simulated PDF')

p = zeros(length(timing),2);
for index=1:length(timing)
    p(index,:) = polyfit(x,y(index,:),1);
end
xlinear = 1.5:0.01:2;
ylinear = p(:,1)*xlinear + p(:,2);

%subplot(1,2,2)
%plot(xlinear,ylinear)
%grid on
%xlim([1.95,2.0])
%ylim([-0.0001,0.0001])
%legend(num2str(timing,"%.3f\n"))
%title('Linear Regression')

h = 1+cos((pi/11)*(4-(0:8)));
h = h./sum(h)
lhh = floor(length(h)/2);
yc = y;
dummy=100
size(y)
size(conv(y(1,:),h)(end-249-lhh:end-lhh))
for index=1:length(timing)
    yc(index,:) = conv(y(index,:),h)(end-249-lhh:end-lhh);
end

subplot(1,2,2)
plot(x,yc)
grid on
xlim([1.95,2.0])
ylim([-0.0001,0.0001])
legend(num2str(timing,"%.3f\n"))
title('LPF')

locs = length(y(1,:))*ones(1,length(timing));
size(locs)
size(y)
for index=3:length(timing)
    locs(index) = find(yc(index,:)<0,1);
endfor

actlocs = x(locs)-0.001;
result = [timing',actlocs',-p(:,2)./p(:,1)];
num2str(result,"%.3f\t%.3f\t%.3f\n")

figure(2)
plot(timing(1:end),[x(find(y(1,:)<0,1))-0.001 actlocs(2:end)],'or')
xlim([0,0.01])
ylim([1.95,2])
grid on
