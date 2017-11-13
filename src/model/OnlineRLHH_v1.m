function [ beta, S ] = OnlineRLHH_v1( X, y, m)
%OnlineRLHH_v1 use the average of all the beta
p = size(X, 1);
n = size(X, 2);
beta = zeros(p, 1);
S = 1:n;
S = S';
%k = n-n_o;
res = zeros(n,1);
tau = n;
MAX_ITER = 100;
MIN_THRES = 1e-2;


for iter=1:MAX_ITER
    
    beta_old = beta;
    
    rand_idx = randperm(n);
    X_arr = {};
    y_arr = {};
    beta_arr = {};
    idx_arr = {};
    S_arr = {};
    beta_total = zeros(p, 1);

    for i = 1:m
        if i~=m
            idx_i = rand_idx(1+(i-1)*n/m:i*n/m);
        else
            idx_i = rand_idx(1+(i-1)*n/m:n);
        end
        idx_arr{i} = idx_i;
        X_arr{i} = X(:,idx_i);
        y_arr{i} = y(idx_i);
    end
    
    
    for i = 1:m
        Xi = X_arr{i};
        yi = y_arr{i};
        
        [beta_i, S_i] = RLHH(Xi, yi);
        beta_arr{i} = beta_i;
        S_arr{i} = S_i;
        
        beta_total = beta_total + beta_i;
    end
    
    beta = beta_total / m;

    

    if(iter == MAX_ITER)
        fprintf('Max Iteration Reached!!!');
    end
    
    %%fprintf('res=%f\n', norm(res(S)-res_old(S)));
    s = size(S, 1);
    fprintf('beta_diff=%f\n', norm(beta - beta_old));
    if norm(beta - beta_old) <= MIN_THRES
    %if norm(res(S))/n <= MIN_THRES
        %fprintf('Finished!!!');
        break;
    end
end
 
end

