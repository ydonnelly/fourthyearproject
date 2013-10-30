source("plotPDF.m")

# define the Tikhonov probability function
frac  = inline('(2*pi*sqrt(var)).^(-2)','var')
fracb = inline('(besseli(0,frac(var))).^-1','var')
pdf = inline('(transpose(fracb(var)).*ones(1,length(y))).*exp((transpose(frac(var)).*ones(1,length(y))).*cos(2*pi*y).*transpose(ones(1,length(var))))','var','y')

# evaluate the probability of each timing offset
var = 0.0002:0.0002:0.01;
y = timing;
tikhnorm = pdf(var,y)./transpose(ones(30,1)*sum(transpose(pdf(var,y))));

figure(2)
plot(timing,tikhnorm);
grid on
legend(num2str(var,'%.3f\n'))
title('Normalised Tikhonov Distribution for various variences')
xlim([0,0.3])
ylim([0,0.3])

header = "### Obtimum Decision Region Boundaries for simulated timing offsets\n";
#disp(strvcat(header,"Varience  Optimum Boundary\n--------  ----------------",num2str([var',tikhnorm*actlocs'],"%.3f     %.3f\n")))

# determine the optimum d.r.b. for a given pdf variance
finallocs = tikhnorm*actlocs';
figure(3)
plot(var,finallocs,'ok')
title('Plot of optimum d.r.b. over timing offset distribution variance')
xlabel('Tikhonov distribution variance')
ylabel('Optimum Decision Region Boundary')
grid on
hold on

# find best linear fit through (0,2)
#A = var'-0;
#b = finallocs-2;
#slope = A\b
#x = [0,var];
#plot(x,2+slope*x,'r')
hold off
