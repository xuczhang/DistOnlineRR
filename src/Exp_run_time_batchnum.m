p = 100;
cr = 0.4;
k = 5;
bNoise = 1;
idx = 1;

n = 1000*k;

if bNoise == 1
    noise_str = ''; 
else
    noise_str = 'nn_';
end

dup_num = 10;

OLS_result = [];
RLHH_result = [];
OPAA_result = [];
ORL_result = [];
ORL0_result = [];
DRLR_result = [];
ORLR_result = [];

for b = 10:2:30

    %n_o = int16(cr*n);
    
    OLS_time = 0;
    RLHH_time = 0;
    OPAA_time = 0;
    ORL_time = 0;
    ORL0_time = 0;
    DRLR_time = 0;
    ORLR_time = 0;
    
    for idx = 1:1:dup_num
        
        data_file = FindDataPath( p, k, cr, bNoise, b, idx );
        data = load(data_file);
        Xtr_arr = data.Xtr_arr;
        Ytr_arr = data.Ytr_arr;
       

        %% Test different methods
        fprintf('=== [%gB] / %d ===\n', b, idx);
        
        % Ordinary Least Square
        tic;
        OLS_beta = Baseline_OLS(Xtr_arr, Ytr_arr);
        elapsedTime = toc;
        OLS_time = OLS_time + elapsedTime;        
                                
        % RLHH Method
        tic;
        RLHH_beta = Baseline_RLHH(Xtr_arr, Ytr_arr);
        elapsedTime = toc;
        RLHH_time = RLHH_time + elapsedTime;

        % OPAA Method
        tic;
        xi = 22;
        OPAA_beta = Baseline_OPAA(Xtr_arr, Ytr_arr, xi);
        elapsedTime = toc;
        OPAA_time = OPAA_time + elapsedTime;
        
        % ORL
        tic;
        ca = 1.9;
        ORL_beta = Baseline_ORL(Xtr_arr, Ytr_arr, 0.5, ca);
        elapsedTime = toc;
        ORL_time = ORL_time + elapsedTime;
        
        % ORL0
        tic;
        ca = 1.9;
        ORL0_beta = Baseline_ORL(Xtr_arr, Ytr_arr, cr, ca);
        elapsedTime = toc;
        ORL0_time = ORL0_time + elapsedTime;
        
        % DRLR
        tic;
        DRLR_beta = DRLR(Xtr_arr, Ytr_arr);
        elapsedTime = toc;
        DRLR_time = DRLR_time + elapsedTime;
        
        % ORLR
        tic;
        batch_num = 7;
        ORLR_beta = ORLR(Xtr_arr, Ytr_arr, batch_num);
        elapsedTime = toc;
        ORLR_time = ORLR_time + elapsedTime;
        
    
    end
    
    OLS_result = [OLS_result OLS_time/dup_num];
    RLHH_result = [RLHH_result RLHH_time/dup_num];
    OPAA_result = [OPAA_result OPAA_time/dup_num];
    ORL_result = [ORL_result ORL_time/dup_num];
    ORL0_result = [ORL0_result ORL0_time/dup_num];
    DRLR_result = [DRLR_result DRLR_time/dup_num];
    ORLR_result = [ORLR_result ORLR_time/dup_num];
    
end
result_path = 'D:/Dropbox/PHD/publications/ICDM2017_ORLR/experiment/';
file_output = strcat(result_path, 'runtime_cr', num2str(cr*100), '_', num2str(k), 'K_', 'p', num2str(p), '_', noise_str);
file_output = file_output(1:end-1);
save(file_output, 'OLS_result', 'RLHH_result', 'OPAA_result', 'ORL_result', 'ORL0_result', 'DRLR_result', 'ORLR_result');
