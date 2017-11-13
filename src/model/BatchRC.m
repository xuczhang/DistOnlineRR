function [ beta, beta_arr, mc] = BatchRC(Xtr_arr, Ytr_arr)
%RLH Summary of this function goes here

m = size(Xtr_arr, 2);
p = size(Xtr_arr{1}, 1);

beta_arr = {};
beta_total_all = zeros(p, 1);

for i = 1:m
    Xi = Xtr_arr{i};
    yi = Ytr_arr{i};

    [beta_i, ] = SingleHR(Xi, yi);
    beta_arr{i} = beta_i;
end

% calculate the distance matrix
dist_matrix = zeros(m, m);

for i = 1:m
    for j = i:m
        dist_ij = norm(beta_arr{i}-beta_arr{j});
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
       mc = sort_idx(1:median_num); % majority clique which contains the estimated uncorrupted blocks
   end
end

%beta_mdarray = {};
for i = 1:median_num
    idx = mc(i);
    %beta_mdarray{i} = beta_arr{idx};
    beta_total_all = beta_total_all + beta_arr{idx};
end
beta = beta_total_all / median_num;

end

