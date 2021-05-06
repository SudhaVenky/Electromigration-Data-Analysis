% ------------------ Weibul Fit ---------------------
pkg load statistics

n = 27;
i = 1:22;
t = [ 0.499,0.55,0.561,0.6702,0.708,0.797,0.885,0.938,0.985,1.134,1.281,...
      1.287,1.609,1.747,2.124,2.197,2.251,3.073,3.215,3.874,6.55,7.698 ];
%t = [ 18.948,4.803,18.819,0.842,0.549 ];
t = sort(t);
% Median Ranking
F = (i - 0.3)/(n + 1);
R = 1 - F;

X = log(t);
Y = log(-log(R));

% Weibull Distribution
wblfit = polyfit(X,Y,1);
beta = wblfit(1);
eta = exp(-wblfit(2)/beta); %Time by which 63.2% of samples have failed

% Plotting
figure (1);
set(gca, 'Fontsize', 18)
grid on
hold on
scatter (X,Y);
plot(X, wblfit(1)*X + wblfit(2));
xlabel('ln(t)');
ylabel('ln(ln(-R))');
legend({'Weibull data','Weibull fit'}, 'Location', 'SouthEast');
hold off

%%----------------------------------------------------------------------
% Lognormal Distribution
yln = norminv(F);
lnfit = polyfit(X,yln,1);
sigma = 1/lnfit(1);
mu = -lnfit(2)*sigma;

mttf = exp(mu + (sigma^2)/2);

figure (2);
set(gca, 'Fontsize', 18)
grid on
hold on
scatter (X,yln);
plot(X, lnfit(1)*X + lnfit(2));
xlabel('ln(t)');
ylabel('Z');
legend({'Lognormal data','Lognormal fit'}, 'Location', 'SouthEast');
hold off

%%----------Goodness of fit test-----------
% K-S Test
F_predicted = normcdf(X,mu,sigma);

CDF_diff = abs(F - F_predicted);
CDF_diff_max = max(CDF_diff);

% Chi-square
X_predicted = yln * sigma + mu;
t_predicted = exp(X_predicted);

chi_sq_all = ((t_predicted - t).^2)./t_predicted;
chi_sq = sum(chi_sq_all);


