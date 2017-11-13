function [ beta ] = Baseline_ORL(Xtr_arr, Ytr_arr, cr, ca)
%BASELINE_ORL Summary of this function goes here
%   Detailed explanation goes here
    block_num = size(Xtr_arr, 2);
    %ca = 200;
    
    p = size(Xtr_arr{1}, 1);
    beta = zeros(p, 1);
    %cr_list = [0.05, 0.05, 0.05, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.05, 0.01, 0.01, 0.01, 0.05]';
    cr_list = [0.09, 0.09, 0.09, 0.09, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01]';
    for i = 1:block_num
        X_i = Xtr_arr{i};
        y_i = Ytr_arr{i};
        
        if cr == 1
            beta_i = RL(X_i, y_i, cr_list(i));
        else
            beta_i = RL(X_i, y_i, cr);
        end
        
        
        %eta_i = 1/ca*i;
        eta_i = 1/(ca*i);
        
        w_i = 2*eta_i/norm(beta - beta_i);
        
        beta = (1-w_i)*beta + w_i*beta_i;
        
    end

end