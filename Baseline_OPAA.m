function [ beta ] = Baseline_OPAA(Xtr_arr, Ytr_arr, xi)
%BASELINE_ORL Summary of this function goes here
%   Detailed explanation goes here
    block_num = size(Xtr_arr, 2);
    %xi = 10;
    
    p = size(Xtr_arr{1}, 1);
    %beta = 0.001 * randn(p, 1);
    beta = randn(p, 1);
    for b = 1:block_num
        X_i = Xtr_arr{b};
        y_i = Ytr_arr{b};
        
        n = size(X_i, 2);
        
        for i = 1 : n
            x = X_i(:, i);
            y = y_i(i);
            loss = max(abs(y-x'*beta) - xi, 0);
            
            ye = x'*beta;
            tau = loss / (norm(x)^2);
            beta = beta + sign(y-ye)*x*tau;            
        end  
        
        
    end
    
    %beta = beta/norm(beta, 2);

end
