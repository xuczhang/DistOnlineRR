function [ beta ] = Baseline_OLS(Xtr_arr, Ytr_arr)
%RLH Summary of this function goes here

    m = size(Xtr_arr, 2);
    p = size(Xtr_arr{1}, 1);

    beta_arr = {};
    beta_total_all = zeros(p, 1);

    for i = 1:m
        Xi = Xtr_arr{i};
        yi = Ytr_arr{i};

        beta_i = regress(yi, Xi');
        %beta_i = lasso(Xi', yi, 'Lambda', 0.005);
        beta_total_all = beta_total_all + beta_i;
    end
    
    beta = beta_total_all / m;

end
