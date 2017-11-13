function [ pc_list, pv_list ] = Metrics_Pearson_Arr( Xte, Yte_arr, Beta_arr )
%METRICS_AVGERROR Summary of this function goes here
%   Detailed explanation goes here

obj_num = size(Yte_arr, 2);
pc_list = zeros(obj_num, 1);
pv_list = zeros(obj_num, 1);

% S = 1:size(Xte, 2);
% for i=1:obj_num
%     Yte_i = Yte_arr{i};
%     beta_i = Beta_arr{i};
%     Yte_est_i = Xte'*beta_i;
%     res_i = abs(Yte_i - Yte_est_i);
%     [sort_arr, sort_idx] = sort(res_i);
%     S_i = sort_idx(1:960);
%     S = intersect(S, S_i);
% end

%S = S(1:750);


%========== for OLS =============%
% S = [];
% for i=1:obj_num
%     Yte_i = Yte_arr{i};
%     beta_i = Beta_arr{i};
%     Yte_est_i = Xte'*beta_i;
%     res_i = abs(Yte_i - Yte_est_i);
%     [sort_arr, sort_idx] = sort(res_i);
%     S_i = sort_idx(995:1000);
%     S = union(S, S_i);
% end



for i=1:obj_num
    Yte_i = Yte_arr{i};
    beta_i = Beta_arr{i};
    [pc, pv] = Metrics_Pearson(Xte, Yte_i, beta_i);
    pc_list(i) = pc;
    pv_list(i) = pv;
end

end

