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
d_ab = (a-b)/30000;
y = [d_ab];
