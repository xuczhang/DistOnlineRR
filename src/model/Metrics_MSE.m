function mse = Metrics_MSE(Xte_arr, Yte_arr, beta)
    %METRICS_AVGERROR Summary of this function goes here
    %   Detailed explanation goes here
    batch_num = size(Yte_arr, 2);
    
    error_total = 0;
    for i = 1:batch_num        
        Xi = Xte_arr{i};
        Yi = Yte_arr{i};
        Yi_est = Xi'*beta;
        c = Yi_est - Yi;
        a = norm(Yi_est - Yi).^2;
        b = a / size(Xi, 2);
        %error_total = error_total + norm(Yi_est - Yi);
        error_total = error_total + sum(abs(Yi_est - Yi));
    end
    
    mse = sqrt(error_total/(batch_num*size(Xi, 2)));
end
