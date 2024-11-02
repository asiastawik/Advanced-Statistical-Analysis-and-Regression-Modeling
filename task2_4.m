clear all
close all
clc

%first letter of my surname is S

t = readtable('POLEX.csv');
idx = strcmp(t.FirstLetterOfYourName, 'S');
data = t(idx, :);

%Create a plot to visualize the price series
date = data.Date;
price = data.Price;

plot(date, price);
title('06/2016');
xlabel('Date');
ylabel('Price [$]');

%Upload the data to matlab
save('data.mat', 'data');
load('data.mat')

% Construct a model:
max_log = 168;
Pt24 = data(145:end-24, 4); %1-24+168
Pt48 = data(121:end-48, 4); %1-48+168
Pt72 = data(97:end-72, 4); %1-72+168
Pt96 = data(73:end-96, 4); %1-96+168
Pt120 = data(49:end-120, 4); %1-120+168
Pt144 = data(25:end-144, 4); %1-144+168
Pt168 = data(1:end-168, 4); %1-168+168
Lt = data(max_log+1:end, 5);
Rt = data(max_log+1:end, 6);
Et = data(max_log+1:end, 7);
Nt = data(max_log+1:end, 8);
Pt = data(max_log+1:end, 4);

%Construct autoregressive model using function
lags = [24, 48, 72, 96, 120, 144, 168];
[X, Y] = autoregressive(price, lags);

X_table = array2table(X);
Pt_table = array2table(Pt);

X = horzcat(X_table, Lt, Rt, Et, Nt);
X = table2array(X);

%Run linear regression
[betas L se] = OLS2(X, Y);

%Analyze model with t-test
N = length(Y);
K = size(X,2);
p = myttest(betas, se, N, K);

disp('Irrelevant columns are 2, 4, 6, 7 and 10, because their p-values are larger than 0.05. I excluded column 6 because we have only ones in this column.')
disp('Irrelevant columns are Pt48, Pt96, Pt144, Pt168 and Et.')

%Put the restriction that βi = 0 for irrelevant variables
R = [0 1 0 0 0 0 0 0 0 0 0 ; 0 0 0 1 0 0 0 0 0 0 0 ; 0 0 0 0 0 1 0 0 0 0 0 ; 0 0 0 0 0 0 1 0 0 0 0 ; 0 0 0 0 0 0 0 0 0 1 0 ];
r = [0 ; 0 ; 0 ; 0 ; 0];

%Wald test
temp1 = R*betas-r;
temp2 = var(Y-X*betas)*R*(X'*X)^(-1)*R';
W = temp1'*temp2^(-1)*temp1;
m = length(r);
pW = 1-chi2cdf(W, m)

disp('The p-value from Wald test (pW) is 0.7905 ant it is bigger that 0.05, so constrains are satisfied, so we should NOT reject hypothesis H0.')

%LR test
betaLR = OLS2(X(:, [1,3,5,8,9,11]), Y);
eLR = Y-X(:, [1,3,5,8,9,11])*betaLR; %residuals of LR model
varLR = var(eLR);
e = Y-X*betas; %residuals of unrestricted model
varUR = var(e);

LR = N*(varLR-varUR)/varUR;
pLR = 1 - chi2cdf(LR, m)

disp('The p-value from LR test (pLR) is 0.7880 ant it is bigger that 0.05, so residuals are not autocorrelated, so we should NOT reject hypothesis H0.')

%LM test
betaLR = OLS2(X(:, [1,3,5,8,9,11]), Y);
eLR = Y-X(:, [1,3,5,8,9,11])*betaLR; %residuals of LR model
varLR = var(eLR);

betaLM = OLS2(X, eLR);
eLM = eLR - X*betaLM;
varLM = var(eLM);
LM = N*(1-varLM/varLR);
pLM = 1- chi2cdf(LM, m)

disp('The p-value from LM test (pLM) is 0.7896 ant it is bigger that 0.05, so constrains are satisfied, so we should NOT reject hypothesis H0.')

%Display the list of variables that were excluded from the model
for i = 1:length(p)
    if p(i) > 0.05
        fprintf('Variable with corresponding number %d is irrelevant\n', i);
    end
end

%backward stepwise regression
%Run linear regression
[betas L se] = OLS2(X, Y);

%Analyze model with t-test
N = length(Y);
K = size(X,2);
p = myttest(betas, se, N, K);

%2,4,6,7,10 - irrelevant columns

alpha = 0.05;
i = 0;
j = 0;
[betas L se] = OLS2(X, Y);
p = myttest(betas, se, N, K);
[~, max_p] = max(p);
temp = max_p;

while true
    [betas L se] = OLS2(X, Y);
    p = myttest(betas, se, N, K);

    %find max(p) value
    [~, max_p] = max(p);
    %disp(max_p)
    max_p_value = p(max_p);

    BIC = bic2(L, N, K);
    fprintf('BIC: %f\n', BIC);

    if max_p_value > alpha
        if max_p == temp
            temp_vis = max_p;
            i = i + 1;
        elseif max_p < temp2
            temp_vis = max_p + j;
            i = i + 1;
        elseif max_p == temp - 1
            temp_vis = max_p + i + j;
        else
            temp_vis = max_p + i - 1 + j;
            j = j + 1;
        end
        fprintf('Variable %d removed (p = %f)\n', temp_vis, max_p_value);
        temp2 = max_p;
        X(:,max_p) = [];
    else
        break;
    end
end

%Now we should check if the final step has the lowest BIC
disp('The final model is not the best when it comes to the lowest BIC. The lowest BIC we have at the beggining, before deleting any variables.')
