function pc = Metrics_Pearson( Xte_arr, Yte_arr, beta )
%METRICS_AVGERROR Summary of this function goes here
%   Detailed explanation goes here

    batch_num = size(Yte_arr, 2);
    
    pc_total = 0;
    for i = 1:batch_num        
        Xi = Xte_arr{i};
        Yi = Yte_arr{i};
        Yi_est = Xi'*beta;
        [pc, pv] = corr(Yi, Yi_est);
        pc_total = pc_total + pc;
    end
    
    pc = pc_total/batch_num;

end

