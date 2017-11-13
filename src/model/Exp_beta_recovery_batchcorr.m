p = 100;
k = 5;
b = 20;
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
BatchRC_result = [];
OnlineRC_result = [];

fprintf('************ p=%d k=%d b=%d bNoise=%d ************\n', p, k, b, bNoise);

%for cr = 0.35:0.05:0.35
batch_cr_list = [0, 0.05, 0.1, 0.2, 0.3, 0.4];
for i = 1:1:size(batch_cr_list, 2)
    
    batch_cr = batch_cr_list(i);
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
    BatchRC_err = 0;
    OnlineRC_err = 0;
    
    fprintf('=== [%g] ===\n', batch_cr);
    
    for idx = 1:1:dup_num
            
        %data_file = strcat('D:/Dataset/RLHH/', num2str(k), 'K_', 'p', num2str(p), '_', noise_str, num2str(n_o), '_', num2str(idx), '.mat');
        data_file = FindDataPath_batchcorr( p, k, batch_cr, bNoise, b, idx );
        data = load(data_file);
        Xtr_arr = data.Xtr_arr;
        Ytr_arr = data.Ytr_arr;
        beta_truth = data.beta;

        %% Test different methods
        %fprintf('=== [%g] / %d ===\n', batch_cr, idx);

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
        
        % BatchRC
        BatchRC_beta = BatchRC(Xtr_arr, Ytr_arr);
        BatchRC_err = BatchRC_err + norm(beta_truth-BatchRC_beta);
        
        % OnlineRC
        batch_num = 7;
        OnlineRC_beta = OnlineRC(Xtr_arr, Ytr_arr, batch_num);
        OnlineRC_err = OnlineRC_err + norm(beta_truth-OnlineRC_beta);
    end
    
    fprintf('OLS[%.3f] RLHH[%.3f] OPAA[%.3f] ORL[%.3f] ORL0[%.3f] BatchRC[%.3f] OnlineRC[%.3f] \n', OLS_err/dup_num, RLHH_err/dup_num, OPAA_err/dup_num, ORL_err/dup_num, ORL0_err/dup_num, BatchRC_err/dup_num, OnlineRC_err/dup_num);
    OLS_result = [OLS_result OLS_err/dup_num];
    RLHH_result = [RLHH_result RLHH_err/dup_num];
    OPAA_result = [OPAA_result OPAA_err/dup_num];    
    ORL_result = [ORL_result ORL_err/dup_num];
    ORL0_result = [ORL0_result ORL0_err/dup_num];
    BatchRC_result = [BatchRC_result BatchRC_err/dup_num];
    OnlineRC_result = [OnlineRC_result OnlineRC_err/dup_num];
    %fprintf('[%d] - |w-w*|: %f outlier_idx:%d \n', n_o, total_error/21, size(S, 1));
    %fprintf('[%d] - |w-w*|: %f outlier_idx:%d \n', n_o, norm(w_truth-TORRENT_w), size(S, 1));
end
% result_path = 'D:/Dropbox/PHD/publications/ICDM2017_OnlineRC/experiment/';
% file_output = strcat(result_path, 'beta_', num2str(b), 'B_', num2str(k), 'K_', 'p', num2str(p), '_', noise_str);
% file_output = file_output(1:end-1);
% save(file_output, 'OLS_result', 'RLHH_result', 'OPAA_result', 'ORL_result', 'ORL0_result', 'BatchRC_result', 'OnlineRC_result');
