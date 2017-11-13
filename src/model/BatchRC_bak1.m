function [ beta ] = BatchRC_v1(Xtr_arr, Ytr_arr)
%RLH Summary of this function goes here

m = size(Xtr_arr, 2);
p = size(Xtr_arr{1}, 1);

beta_arr = {};
beta_total_all = zeros(p, 1);

for i = 1:m
    Xi = Xtr_arr{i};
    yi = Ytr_arr{i};

    [beta_i, ] = RLHH(Xi, yi);
    beta_arr{i} = beta_i;

    beta_total_all = beta_total_all + beta_i;
end

beta_all = beta_total_all / m;

var = zeros(m, 1);
for i = 1:m
    var(i) = norm(beta_arr{i} - beta_all);
end

[sort_var, sort_vari] = sort(var);

beta_total_est = zeros(p, 1);
est_num = floor(m/2)+1;
for i = 1:est_num
   %var_i = sort_vari(m-i+1);
   var_i = sort_vari(i);
   beta_var_i = beta_arr{var_i};
   beta_total_est = beta_total_est + beta_var_i;
end
beta = beta_total_est / est_num;
%beta = beta_all;
end

