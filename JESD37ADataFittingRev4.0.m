% how to determine average and stdev values corrected for right censored data
% 
% formulas and procedure taken from J.A. Lechner, 1991, "Estimators for Type-II Censored (Log)Normal Samples"
% available from https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=106773&casa_token=Poz-A3d7t3IAAAAA:kKbf7mRVgaq9PTE_LPs3d8xw28DxIU5kXxOsDlDbuYUAPub2KlCDK9utpvK4TGWH9ZELSP5Utz4&tag=1
close all
pkg load statistics  % script works with octave only and not matlab

% data which was not interrupted: x ln(times) [[ example data taken from table C.5 in Jedec Std. JESD37A
##x=log([0.499,0.55,0.561,0.6702,0.708,0.797,0.885,0.938,0.985,1.134,1.281,...
##       1.287,1.609,1.747,2.124,2.197,2.251,3.073,3.215,3.874,6.55,7.698 ]);
##% data which was interrupted: y ln(times) 
##y=log([8 8]);

##% BL CORNER
##x=log([0.951,1.545,2.371,2.949,3.347,3.349,3.523,5.765,6.592,13.196,15.108,...
##       23.433 ]);
##% data which was interrupted: y ln(times) 
##y=log([25,25,25,25,25,25,25,25,25,25,25,25]);
##
##%TL CORNER
##x=log([0.698,0.883,1.093,1.167,1.62,2.327,3.786,4.239,5.997,6.549,8.574,...
##       12.799,13.914,14.63,14.808,17.772]);
##% data which was interrupted: y ln(times) 
##y=log([20,20,20,20,20,20,20,20]);
##
##%BR CORNER
##x=log([0.547,0.842,0.868,1.405,1.434,1.596,3.462,4.803,8.393,18.819,18.948,21.617,21.984,24.38]);
##% data which was interrupted: y ln(times) 
##y=log([25,25,25,25,25,25,25,25,25,25]);

##%SnAgCu TR Corner
x=log([0.249,0.311,0.321,0.406,0.433,0.713,0.755,0.768,1.014,1.11,1.626,1.867,2.622,2.698]);
% data which was interrupted: y ln(times) 
y=log([3,3,3,3,3,3,3,3,3,3]);


N=length(x)+length(y);K=length(x);
% normal cumulative distribution function in octave is normcdf  
% normcdf(z0) = 1/2*erfc(-z0/sqrt(2))  [[ see https://en.wikipedia.org/wiki/Error_function#Cumulative_distribution_function ]]
% inverse of normcdf is probit funzction
z0=-norminv(K/N);%-.7128;  % norminv; I had to put a - in front of the probit fct to avoid complex result
% define z0 by gauf(z0)=K/N; % gauf is the cumulative distribution function
% (wikipedia) use the inverse of normcdf  is known as the normal quantile function, or probit function and may be expressed in terms of the inverse error function as

F=K/N;
function retval=gaud(x); % see p. 87pdf, 5-1 section, in https://apps.dtic.mil/dtic/tr/fulltext/u2/a027372.pdf
  retval=exp(-x^2/2)/sqrt(2*pi);
endfunction
M=mean(x);
Cr=y(1);%sqrt([x(end)*y(1)]); % censoring point
S=std(x);% stdev of observed x's
SRML=1/2*(z0*(Cr-M)+(z0^2*(Cr-M)^2+4*((Cr-M)^2+(1-1/K)*S^2))^0.5);
alpha=(N/K)*gaud(z0);
SPR_biased=((K-1)*S^2/K+alpha*(alpha-z0)*SRML^2)^0.5
MPR=M+alpha*SRML
SPR_unbiased=K/(K-1)*(1.8*N+5)/(1.8*N+6)*SPR_biased
CMPR=MPR+(.98/K+.068/K/F-1.15/N)*SPR_unbiased
expSPR=exp(SPR_biased)
expMPR=exp(MPR)
expCSPR=exp(SPR_unbiased)
expCMPR=exp(CMPR)
disp(['biased estimate of  t50 : ' num2str(expMPR) ' units; +-1-sigma range: ' num2str(exp(MPR-SPR_biased)) '-' num2str(exp(MPR+SPR_biased)) ' units'])
disp(['unbiased estimate of t50: ' num2str(expCMPR) ' units; +-1-sigma range: ' num2str(exp(CMPR-SPR_unbiased)) '-' num2str(exp(CMPR+SPR_unbiased)) ' units'])

% KS Test
P=([1:N]-.3)/(N+.4);
P_x = P(1:length(x));
Z = (x - CMPR)/SPR_unbiased;
P_predicted = normcdf(Z);
CDF_diff = abs(P_x - P_predicted);
CDF_diff_max = max(CDF_diff)

% Plotting
figure;
plot([x y],P,'o',[CMPR CMPR],[0 1.1],[CMPR CMPR]-SPR_unbiased,[0 1.1],'--',[CMPR CMPR]+SPR_unbiased,[0 1.1],'--',y,[0 1.1],'k')
set(gca, 'Fontsize', 18)
xlabel('ln(Time)','FontSize',22); 
ylabel('Cumulative Probability','FontSize',22);
title('mean +- stdev corrected for censoring according to Persson-Rootzen','FontSize',22);

%norminv converts cum prob to Z
%normcdf converts Z to cum prob

##[ax,h1,h2] = plotyy(1, 1, 1, 1, @semilogx, @semilogx);
##set(ax,{'ycolor'},{'b';'r'})
##set(ax, 'Fontsize', 18)
##hold(ax(1),'on')
##scatter(ax(1), exp(x), P_x, 'b');
##scatter(ax(1), exp([ y]),P(end-length(y)+1:end),'r')% plot censored data
##line(ax(1), exp([ y]),P(end-length(y)+1:end), "linestyle", "-", "color", "r")% plot censored data
##%line(ax(1), exp(x), yf, "linestyle", "-", "color", "b");% fitting
##%line(ax(1), exp(x), yf+D, "linestyle", "--", "color", "b");% fitting error
##%line(ax(1), exp(x), yf-D, "linestyle", "--", "color", "b");% fitting error
##
##line(ax(1), exp(x), normcdf(Z), "linestyle", "-", "color", "k");% fitting error
##
##normcdf(Zi=[-1.5:.5:2])
##for j=1:length(Zi);
##  line(ax(1),[9 10],[normcdf(Zi(j)) normcdf(Zi(j))],"linestyle", "-", "color", "k");
##  text(10,normcdf(Zi(j)),num2str(Zi(j))) 
##endfor
##
##line(ax(2), exp(x), Z, "linestyle", "--", "color", "r");
##
##xlabel('Time [h]','FontSize',22);
##ylabel(ax(1), 'Cum. Prob','FontSize',22 );
##ylabel(ax(2), 'Z','FontSize',22);
##title('TTF on Log Scale with PR fit line','FontSize',22);


figure;
semilogx(exp([x y]),P,'o',exp([ y]),P(end-length(y)+1:end),'r',exp([ y]),P(end-length(y)+1:end),'r*',exp([CMPR CMPR]),[0 1],exp([CMPR CMPR] - SPR_unbiased),[0 1],'--',exp([CMPR CMPR] + SPR_unbiased),[0 1],'--')
set(gca, 'Fontsize', 18)
xlabel('Time [h]','FontSize',22);
ylabel('Cumulative Probability','FontSize',22);
title('mean +- stdev corrected for censoring as per Persson-Rootzen','FontSize',22);



semilogx(exp(x),Z)
hold on
scatter(exp(x), norminv(P_x), 'b'); 
scatter(exp([ y]),norminv(P(end-length(y)+1:end)),'r')% plot censored data
line([exp(x(end)) exp(x(end))],[-2 2],"linestyle", "--","color",'k')
##line(exp(x), Z+norminv(CDF_diff_max), "linestyle", "--", "color", "b");% fitting error
##line(exp(x), Z-norminv(CDF_diff_max), "linestyle", "--", "color", "b");% fitting error
Pi=[0:.1:1]
for j=1:length(Pi);
  text(0.07,norminv(Pi(j)),strcat(num2str(Pi(j)),'-'),"Fontsize",15) 
endfor
set(gca, 'Fontsize', 22)
ylabel('Z','FontSize',25);
set(gca,'YAxisLocation','right');
xlabel('Time [h]','FontSize',25);
