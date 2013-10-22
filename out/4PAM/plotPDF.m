a = dlmread('octave_-3.txt');
b = dlmread('octave_-1.txt');
c = dlmread('octave_1.txt');
d = dlmread('octave_3.txt');
size(d)
x = [-3, -2.095:0.01:-1.905, -1, -0.095:0.01:0.095, 1, 1.905:0.01:2.095, 3];
size(x)
n = sum(a(1,:))
d_ab = (b-a)/n;
d_bc = (c-b)/n;
d_cd = (d-c)/n;
y = [d_ab;d_bc;d_cd];
subplot(1,3,1)
plot(x,y,'r')
xlim([-2,-1.9])
ylim([n/1000])
