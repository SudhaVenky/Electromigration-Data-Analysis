% In this document the time-to-failure data points are manually entered
% into the arrays. Weibull and Lognormal analysis is conducted on the
% arrays
%--------------------Failure Times------------------------
% t = [ 0.499,0.55,0.561,0.6702,0.708,0.797,0.885,0.938,0.985,1.134,1.281,...
%       1.287,1.609,1.747,2.124,2.197,2.251,3.073,3.215,3.874,6.55,7.698, 17.035]; % T-R Corner
% t = [ 0.951,1.545,2.371,2.949,3.347,3.349,3.523,5.765,6.592,13.196,15.108,...
%       23.433 ]; % B-L Corner
% t = [ 2.327,12.799,3.786,14.63,6.549,4.239,0.698,1.62,0.883,17.772,5.997,...
%       1.167,8.574,13.914,1.093,14.808 ]; % T-L Corner
 t = [ 18.948,4.803,18.819,0.842,0.547,8.393,3.462,0.868,21.617,21.984,...
       1.434,1.405,24.38,1.596]; % B-R Corner
% t = [ 0.249, 0.713, 0.311, 0.768, 1.11, 0.406, 0.321, 2.622, 1.014, 0.755,... 
%       0.433, 2.698, 1.626, 1.867]; % SAC-305 T-R 
n = 24;
i = 1:length(t);
t = sort(t);
% Median Ranking - [Used to take into account the probability density of the
% failure times]
F = (i - 0.3)/(n + 1);
R = 1 - F;
 
 
%% ------------------ Weibull Fit ---------------------

X = log(t);
Y = log(-log(R));

% Weibull Distribution
wblfit = polyfit(X,Y,1);
beta = wblfit(1);
eta = exp(-wblfit(2)/beta); % Time by which 63.2% of samples have failed

% Plotting
figure (1);
set(gca, 'Fontsize', 22)
grid on
hold on
scatter (X,Y);
plot(X, wblfit(1)*X + wblfit(2));
xlabel('ln(t)','FontSize',22);
ylabel('ln(ln(-R))','FontSize',22);
legend({'Weibull data','Weibull fit'}, 'Location', 'SouthEast');
hold off

% ----------Goodness of fit test-----------
% K-S Test
F_predicted = 1 - exp(- ((t./eta).^beta)) ;

CDF_diff = abs(F - F_predicted);
CDF_diff_max = max(CDF_diff);

% Chi-square
X_predicted = Y / beta + log(eta);
t_predicted = exp(X_predicted);

chi_sq_all = ((t_predicted - t).^2)./t_predicted;
chi_sq = sum(chi_sq_all);

fprintf('Weibull Fit Data')
fprintf('No. of Failures: %d\n', i(end))
fprintf('Eta: %d\n', eta)
fprintf('Beta: %d\n', beta)
fprintf('KS Fit: %d\n', CDF_diff_max)
fprintf('Chi_sq: %d\n', chi_sq)
fprintf('')

%% ----------------------------------------------------------------------
% ---------------------Lognormal Distribution----------------------------
X = log(t);
yln = norminv(F);
lnfit = polyfit(X,yln,1);
sigma = 1/lnfit(1);
mu = -lnfit(2)*sigma;

mttf = exp(mu + (sigma^2)/2); % Time by which 50% of samples have failed

figure (2);
set(gca, 'Fontsize', 22)
grid on
hold on
scatter (X,yln);
plot(X, lnfit(1)*X + lnfit(2));
xlabel('ln(t)','FontSize',22);
ylabel('Z','FontSize',22);
legend({'Lognormal data','Lognormal fit'}, 'Location', 'SouthEast');
hold off

% ----------Goodness of fit test-----------
% K-S Test
F_predicted = normcdf(X,mu,sigma);

CDF_diff = abs(F - F_predicted);
CDF_diff_max = max(CDF_diff);

% Chi-square
X_predicted = yln * sigma + mu;
t_predicted = exp(X_predicted);

chi_sq_all = ((t_predicted - t).^2)./t_predicted;
chi_sq = sum(chi_sq_all);

fprintf('Lognormal Fit Data')
fprintf('No. of Failures: %d\n', i(end))
fprintf('Mttf: %d\n', mttf)
fprintf('Mu: %d\n', mu)
fprintf('Sigma: %d\n', sigma)
fprintf('KS Fit: %d\n', CDF_diff_max)
fprintf('Chi_sq: %d\n', chi_sq)
fprintf('')

%% ----------Fusion Current Char.----------------%
R0 = [17.12 14.21 14.78 16.59 18.16 20.38 15.89 12.95 12.61 10.79 11.16 12.93 13.95];
Ifuse = [5 6.1 5.8 5.1 4.8 4 5.5 6.25 6.4 7.2 6.9 6.25 6.1];

fusefit = polyfit(R0,Ifuse,1);
slope = fusefit(1);
int = fusefit(2);

figure (3);
set(gca, 'Fontsize', 22)
grid on
hold on
scatter (R0,Ifuse);
plot(R0, slope*R0 + int);
xlabel('R_0 @ 22C, 0.1A, [mΩ]','FontSize',22);
ylabel('Fusion Current [A]','FontSize',22);
legend({'Fuse Point','Fusion Fit'}, 'Location', 'NorthEast');
hold off


