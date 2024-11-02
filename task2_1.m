clear all
close all
clc

load ('model2_1.mat')
L = LS_loss(y,x,a);

Lmin = inf();
for a1=-2:0.1:2
    for a2=-2:0.1:2
        for a3=-2:0.1:2
            L1 = LS_loss(y,x,[a1,a2,a3]);
            if L1 < Lmin
                Lmin = L1;
                v = [a1 a2 a3];
            end
        end
    end
end

disp('Vector that minimize LS loss function:')
disp(v)

disp('The loss function:')
disp(L)

function L = LS_loss(y,x,a)
e = y - a(1).*x(:,1).^a(2).*x(:,2).^a(3);
L = sum(e.^2); %e'*e
end