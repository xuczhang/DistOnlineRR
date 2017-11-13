function [ beta, new_beta_arr, new_mc ] = OnlineRC_inc(beta_arr, mc, Xtr, y)
%RLH Summary of this function goes here

p = size(Xtr, 1);

beta_total_all = zeros(p, 1);

[beta_new, ] = SingleHR(Xtr, y);
m = size(beta_arr, 2);
diff_set = setdiff(1:m, mc);
rm_idx = diff_set(1);
% replace the first corrupted block with new block
new_beta_arr = [beta_arr(1:rm_idx-1) beta_arr(rm_idx+1:m) beta_new];


% calculate the distance matrix
dist_matrix = zeros(m, m);

for i = 1:m
    for j = i:m
        dist_ij = norm(new_beta_arr{i}-new_beta_arr{j});
        dist_matrix(i, j) = dist_ij;
        dist_matrix(j, i) = dist_ij;
    end
end

median_num = floor(m/2) + 1;
min_val = 1e4;
for i = 1:m
   dist_i = dist_matrix(:, i);
   [sort_dist, sort_idx] = sort(dist_i);
   median_val = sort_dist(median_num);
   if median_val < min_val
       min_val = median_val;
       new_mc = sort_idx(1:median_num);
   end
end

%disp(new_mc);
for i = 1:median_num
    idx = new_mc(i);
    beta_total_all = beta_total_all + new_beta_arr{idx};
end
beta = beta_total_all / median_num;

end

