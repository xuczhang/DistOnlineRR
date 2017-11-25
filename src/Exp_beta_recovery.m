p = 200;
k = 10;
b = 20;
bNoise = 0;
idx = 1;

n = 1000*k;

if bNoise == 1
    noise_str = ''; 
else
    noise_str = 'nn_';
end

dup_num = 1;


OLS_result = [];
RLHH_result = [];
OPAA_result = [];
ORL_result = [];
ORL0_result = [];
DRLR_result = [];
ORLR_result = [];
ORLR2_result = [];

fprintf('************ p=%d k=%d b=%d bNoise=%d ************\n', p, k, b, bNoise);

%for cr = 0.35:0.05:0.35
for cr = 0.05:0.05:0.4

    if bNoise == 1
        noise_str = ''; 
    else
        noise_str = 'nn_';
    end
    n_o = int16(cr*n);
    
    OLS_err = 0;
    RLHH_err = 0;
    OPAA_err = 0;
    ORL_err = 0;
    ORL0_err = 0;
    DRLR_err = 0;
    ORLR_err = 0;
    ORLR2_err = 0;
    
    for idx = 1:1:dup_num
            
        %data_file = strcat('D:/Dataset/RLHH/', num2str(k), 'K_', 'p', num2str(p), '_', noise_str, num2str(n_o), '_', num2str(idx), '.mat');
        data_file = FindDataPath( p, k, cr, bNoise, b, idx );
        data = load(data_file);
        Xtr_arr = data.Xtr_arr;
        Ytr_arr = data.Ytr_arr;
        beta_truth = data.beta;

        %% Test different methods
        fprintf('=== [%g] / %d ===\n', cr, idx);

        % OLS: Ordinary Least Square        
        OLS_beta = Baseline_OLS(Xtr_arr, Ytr_arr);
        OLS_err = OLS_err + norm(beta_truth-OLS_beta);
        
        % RLHH 
        RLHH_beta = Baseline_RLHH(Xtr_arr, Ytr_arr);
        RLHH_err = RLHH_err + norm(beta_truth-RLHH_beta);
        
        % OPAA
        xi = 22;
        OPAA_beta = Baseline_OPAA(Xtr_arr, Ytr_arr, xi);
        OPAA_err = OPAA_err + norm(beta_truth-OPAA_beta);
        
        % ORL
        ca = 1.9;
        ORL_beta = Baseline_ORL(Xtr_arr, Ytr_arr, 0.5, ca);
        ORL_err = ORL_err + norm(beta_truth-ORL_beta);
        
        % ORL0
        ca = 1.9;
        ORL0_beta = Baseline_ORL(Xtr_arr, Ytr_arr, cr, ca);
        ORL0_err = ORL0_err + norm(beta_truth-ORL0_beta);
        
        % DRLR
        DRLR_beta = DRLR(Xtr_arr, Ytr_arr);
        DRLR_err = DRLR_err + norm(beta_truth-DRLR_beta);
        
        % ORLR
        batch_num = 7;
        ORLR_beta = ORLR(Xtr_arr, Ytr_arr, batch_num);
        ORLR_err = ORLR_err + norm(beta_truth-ORLR_beta);
        
        % ORLR2
        batch_num = 7;
        ORLR2_beta = ORLR_v2(Xtr_arr, Ytr_arr, batch_num);
        ORLR2_err = ORLR2_err + norm(beta_truth-ORLR2_beta);
    end
    
    fprintf('OLS[%f] RLHH[%f] OPAA[%f] ORL[%f] ORL0[%f] DRLR[%f] ORLR[%f] ORLR2[%f]\n', OLS_err/dup_num, RLHH_err/dup_num, OPAA_err/dup_num, ORL_err/dup_num, ORL0_err/dup_num, DRLR_err/dup_num, ORLR_err/dup_num, ORLR2_err/dup_num);
    OLS_result = [OLS_result OLS_err/dup_num];
    RLHH_result = [RLHH_result RLHH_err/dup_num];
    OPAA_result = [OPAA_result OPAA_err/dup_num];    
    ORL_result = [ORL_result ORL_err/dup_num];
    ORL0_result = [ORL0_result ORL0_err/dup_num];
    DRLR_result = [DRLR_result DRLR_err/dup_num];
    ORLR_result = [ORLR_result ORLR_err/dup_num];
    ORLR2_result = [ORLR2_result ORLR2_err/dup_num];

end
% result_path = 'D:/Dropbox/PHD/publications/ICDM2017_ORLR/experiment/';
% file_output = strcat(result_path, 'beta_', num2str(b), 'B_', num2str(k), 'K_', 'p', num2str(p), '_', noise_str);
% file_output = file_output(1:end-1);
% save(file_output, 'OLS_result', 'RLHH_result', 'OPAA_result', 'ORL_result', 'ORL0_result', 'DRLR_result', 'ORLR_result');
