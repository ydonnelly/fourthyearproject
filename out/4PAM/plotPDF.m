a = dlmread('decregbig/octave_1_1.txt');
a = a + dlmread('decregbig/octave_1_2.txt');
a = a + dlmread('decregbig/octave_1_3.txt');
a = a + dlmread('decregbig/octave_1_4.txt');
b = dlmread('decregbig/octave_3_1.txt');
b = b + dlmread('decregbig/octave_3_2.txt');
b = b + dlmread('decregbig/octave_3_3.txt');
b = b + dlmread('decregbig/octave_3_4.txt');
size(a)
x = [1.5025:0.005:1.9975];
size(x)
timing = 0.01:0.01:0.3;
size(timing)
d_ab = (a-b)/3000000000;
y = [d_ab];
pick = [1,5,10,15,20];

figure(1)
plot(x,y(pick,:))
grid on
xlim([1.86,2.0])
ylim([-0.0002,0.0002])
legend(num2str(timing(pick),"%.2f\n"))

locs = 100*ones(1,30);
for index=3:30
    locs(index) = find(y(index,:)<0,1);
endfor

actlocs = x(locs);
#result = [timing',locs']
