p = 200;
k = 5;
b = 10;
bNoise = 0;
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

for cr = 0.05:0.05:0.4

    %n_o = int16(cr*n);
    
    OLS_time = 0;
    RLHH_time = 0;
    OPAA_time = 0;
    ORL_time = 0;
    ORL0_time = 0;
    BatchRC_time = 0;
    OnlineRC_time = 0;
    
    for idx = 1:1:dup_num
        
        data_file = FindDataPath( p, k, cr, bNoise, b, idx );
        data = load(data_file);
        Xtr_arr = data.Xtr_arr;
        Ytr_arr = data.Ytr_arr;
       

        %% Test different methods
        fprintf('=== [%g] / %d ===\n', cr, idx);
        
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
        
        % BatchRC
        tic;
        BatchRC_beta = BatchRC(Xtr_arr, Ytr_arr);
        elapsedTime = toc;
        BatchRC_time = BatchRC_time + elapsedTime;
        
        % OnlineRC
        tic;
        batch_num = 7;
        OnlineRC_beta = OnlineRC(Xtr_arr, Ytr_arr, batch_num);
        elapsedTime = toc;
        OnlineRC_time = OnlineRC_time + elapsedTime;
        
    
    end
    
    OLS_result = [OLS_result OLS_time/dup_num];
    RLHH_result = [RLHH_result RLHH_time/dup_num];
    OPAA_result = [OPAA_result OPAA_time/dup_num];
    ORL_result = [ORL_result ORL_time/dup_num];
    ORL0_result = [ORL0_result ORL0_time/dup_num];
    BatchRC_result = [BatchRC_result BatchRC_time/dup_num];
    OnlineRC_result = [OnlineRC_result OnlineRC_time/dup_num];
    
end
result_path = 'D:/Dropbox/PHD/publications/ICDM2017_OnlineRC/experiment/';
file_output = strcat(result_path, 'runtime_', num2str(b), 'B_', num2str(k), 'K_', 'p', num2str(p), '_', noise_str);
file_output = file_output(1:end-1);
save(file_output, 'OLS_result', 'RLHH_result', 'OPAA_result', 'ORL_result', 'ORL0_result', 'BatchRC_result', 'OnlineRC_result');
