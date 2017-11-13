function [] = DataSampling( p, k, cr, bNoise, block_num, idx)

    %% Initialize the constant
    %p = 100; % feature dimension
    %k = 1;
    %cr = 0.1; % corruption ratio (from 0.1 to 1.2)
    %bNoise = 1;

    n = 1000*k*block_num; % total sample number in training data
    
    % init cell array for X, Y and Beta
    Xtr_arr = {};
    Ytr_arr = {};
    beta = rand(p, 1);
    
    if cr < 1
        b_finish = 0;
        while ~b_finish
            cr_v = rand(block_num, 1);
            cr_v = cr_v/sum(cr_v)*cr;
            
            a = cr_v(cr_v > 1/block_num);
            if size(a,1) == 0
                b_finish = 1;
            end
        end

    else        
        cr_v = [0.09, 0.09, 0.09, 0.09, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01]';
    end
    %disp(cr_v);
    for i=1:block_num
        %% Generate the training sample data
        
        n_i = 1000*k;
        n_o = int16(cr_v(i)*n); % corruption sample number(from 100 to 1200)
        n_u = n_i - n_o;
    
        % sample beta by unit norm vector in p dimension        
        beta_norm = norm(beta);
        beta = beta/beta_norm;
        Beta_arr{i} = beta;
        
        % sample X data by normal distribution with mu=0 and cov=I_p
        X_mu = zeros(p, 1);
        X_cov = eye(p);
        Xtr_a = mvnrnd(X_mu, X_cov, n_u)'; %authetic part X    
        Xtr_o = mvnrnd(X_mu, X_cov, n_o)'; % outlier part X
        Xtr = [Xtr_a, Xtr_o];    
        Xtr_arr{i} = Xtr;
        
        % generate the authentic samples by y_i = <w, x_i> + e_i
        if bNoise
            % sample noise eplison for outliers
            e_mu = zeros(n_u, 1);
            e_cov = eye(n_u) * 0.1;
            e_a = mvnrnd(e_mu, e_cov)';
            ytr_a = Xtr_a'*beta + e_a;
        else
            ytr_a = Xtr_a'*beta;
        end

        %% Generate Training Outlier Data
        if n_o ~= 0
            % sample corruption vector b as b_i ~ U(-5|y*|_inf, 5|y*|_inf)
            u_range = 5*norm(ytr_a, inf);
            %u_range = 100*norm(ytr_a, inf);
            u = -u_range + 2*u_range*rand(n_o,1);

            % generate outlier ytr_o
            if bNoise
                % sample noise eplison for outliers
                e_mu = zeros(n_o, 1);
                e_cov = eye(n_o) * 0.01;
                e_o = mvnrnd(e_mu, e_cov)';
                ytr_o = Xtr_o'*beta + u + e_o;
            else
                ytr_o = Xtr_o'*beta + u;
            end

            ytr = [ytr_a; ytr_o];
            Ytr_arr{i} = ytr;
            
        else
            Ytr_arr{i} = ytr_a;
        end
        

    end
    %z = -ytr_all.*(Xtr_all'*w);
    %t = ytr_all - sigmf(Xtr_all'*w, [1 0]);

    %% Save the results into the output file
    %data_file = strcat(data_path, 'synthetic.mat');
    data_file = FindDataPath( p, k, cr, bNoise, block_num, idx );
    
    save(data_file, 'Xtr_arr', 'Ytr_arr', 'beta');
end

