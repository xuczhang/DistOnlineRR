function [ beta, AS ] = OnlineRLHH_v3(Xtr_arr, Ytr_arr)
%RLH Summary of this function goes here

m = size(Xtr_arr, 2);
X = Xtr_arr{1};
y = Ytr_arr{1};
for i = 2:m
    X = [X Xtr_arr{i}];
    y = [y; Ytr_arr{i}];    
end

p = size(X, 1);
n = size(X, 2);
beta = zeros(p, 1);
AS = 1:n; % Active Set
AS = AS';
%k = n-n_o;
res = zeros(n,1);
res_val = 100;
tau = n;
MAX_ITER = 100;
MIN_THRES = 1e4;
%MIN_THRES = 1e-4;

m = 50;

for iter=1:MAX_ITER
    
    res_val_old = res_val;
    beta_old = beta;
    
    X_arr = {};
    y_arr = {};
    beta_arr = {};
    AS_arr = {};
    S_arr = {};
    beta_total = zeros(p, 1);
    
    as = size(AS, 1);
    rand_idx = randperm(as)';
    for i = 1:m
        
        if i~=m
            idx_i = rand_idx(floor(1+(i-1)*as/m):floor(i*as/m));
        else
            idx_i = rand_idx(floor(1+(i-1)*as/m):as);
        end
        
        AS_i = AS(idx_i);
        AS_arr{i} = AS_i;
        X_arr{i} = X(:,AS_i);
        y_arr{i} = y(AS_i);
    end
    
    S = [];
    parfor i = 1:m
        Xi = X_arr{i};
        yi = y_arr{i};
        
        [beta_i, S_i] = RLHH(Xi, yi);
        beta_arr{i} = beta_i;
        S_arr{i} = AS_arr{i}(S_i);
        S = [S; S_i];
        
        beta_total = beta_total + beta_i;
    end
    
    beta = beta_total / m;
    
    var = zeros(m, 1);
    for i = 1:m
        var(i) = norm(beta_arr{i} - beta);
    end
    
    [sort_var, sort_vari] = sort(var);
    
    for i = 1:floor(m/2)
       %var_i = sort_vari(m-i+1);
       var_i = sort_vari(i);
       AS_i = AS_arr{var_i};
       S_i = S_arr{var_i};
       S_corr_i = setdiff(AS_i, S_i);
       AS = setdiff(AS, S_corr_i);
    end
    
    if(iter == MAX_ITER)
        fprintf('Max Iteration Reached!!!');
    end
    
    as = size(AS,1);
    res_val = norm(y(AS) - X(:,AS)'*beta)/as;
    fprintf('res=%f res_diff=%f |S|=%d\n', res_val, norm(res_val - res_val_old), as);
    if norm(res_val - res_val_old) <= MIN_THRES
    %if norm(res(S))/n <= MIN_THRES
        %fprintf('Finished!!!');
        break;
    end
end
 
end

