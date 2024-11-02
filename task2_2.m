clear all
close all
clc

data = load('report_task.mat');
y = data.Y;

lags = 1:7;
combos = nchoosek(lags, 3); %prepare list of all lags combinations

n = length(y); % number of observations
bic_vals = zeros(size(combos, 1), 1); % initialize array for BIC values

for i = 1:size(combos, 1) % for each combination of lags
    current_lags = combos(i,:);
    [X,Y] = autoregressive(y, current_lags);
    k = size(X, 2) + 1; % number of parameters to estimate
    [betas, L] = OLS(X, Y); % calculate beta coefficients and RSS
    bic_vals(i,1) = bic2(L, n, k); % calculate BIC
end

% find the combination of lags with the lowest BIC
[min_bic, min_idx] = min(bic_vals);
opt_lags = combos(min_idx, :);

fprintf('Optimal lags: %d, %d, %d\n', opt_lags);
fprintf('BIC value: %f\n', min_bic);


