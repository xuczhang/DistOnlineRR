function [ beta ] = Baseline_RLHH(Xtr_arr, Ytr_arr)
%RLH Summary of this function goes here

    m = size(Xtr_arr, 2);
    p = size(Xtr_arr{1}, 1);

    beta_total_all = zeros(p, 1);

    for i = 1:m
        X_i = Xtr_arr{i};
        y_i = Ytr_arr{i};
        
        beta_i = RLHH( X_i, y_i);
        %beta_i = SingleHR( X_i, y_i);
                
        beta_total_all = beta_total_all + beta_i;
    end
    
    beta = beta_total_all / m;

end

