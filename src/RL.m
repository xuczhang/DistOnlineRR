function beta = RL(X, y, cr)
    
p = size(X, 1);
n = size(X, 2);
beta = zeros(p, 1);
n_o = int16(cr*n);
for j = 1:p
    X_j = X(j,:)';
    beta(j) = trimmed_inner_product(X_j, y, n, n_o);
end
beta = beta/norm(beta, 2);
end

function h = trimmed_inner_product(a, b, N, n1)
    
    q = (a.*b);
    q_abs = abs(q);
    [m, mi] = sort(q_abs);   
    q_idx = mi(1:N-n1);
    q_trim = q(q_idx);
    h = sum(q_trim);

end