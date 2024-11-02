clear all
close all
clc

t = readtable('report_task_2_3.csv');
y = t.Value;
x(:,1) = t.Flat_area;
x(:,2) = t.building_age;
x(:,3) = t.Distance_from_center;
x(:,4) = t.Additional_facilities_area;
x(:,5) = t.subjective_assessment;
x(:,6) = 1;

[betas L se] = OLS2(x,y);
N = length(y);
K = size(x,2);
p = myttest(betas, se, N, K);

disp('Irrelevant columns are Flat_area and building_age, because their p-values are larger than 0.05. I excluded column 6 because we have only ones in this column.')
%p > 0.05, so these are irrelevant variables
% in our model, but they could be correlated! So if we removed one of them,
% the second one could be relevant from that time
% because of that we have some other tests

%B2 = B3 = B6 = 0
R = [0 1 0 0 0 0 ; 0 0 1 0 0 0 ; 0 0 0 0 0 1; 1 0 0 0 0 0];
r = [0 ; 0 ; 0 ; 10000];

temp1 = R*betas-r;
temp2 = var(y-x*betas)*R*(x'*x)^(-1)*R';
W = temp1'*temp2^(-1)*temp1;
m = length(r);
pW = 1-chi2cdf(W, m)

disp('The p-value from Wald test (pW) is 0.1621 ant it is bigger that 0.05, so constrains are satisfied, so we should NOT reject hypothesis H0.')
% pW >= 0.05(alpha) -> constrains are satisfied, do not reject H0
% pW < 0.05(alpha) -> at least one constraint is wrong, reject
