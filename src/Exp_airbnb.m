data_dir = 'D:/Dataset/OnlineRC/airbnb/NY/';
data_dir = 'D:/Dataset/OnlineRC/airbnb/LA/';
cr = 0.4;
%train_file = strcat(data_dir, 'NY_train_cr40');
dup_num = 10;

OLS_err = [];
RLHH_err = [];
OPAA_err = [];
ORL_err = [];
ORL0_err = [];
BatchRC_err = [];
OnlineRC_err = [];

test_file = strcat(data_dir, 'NY_test');
data = load(test_file);
Xte_arr = data.Xte_arr;
Yte_arr = data.Yte_arr;

fprintf('=== cr:[%g] ===\n', cr);
for idx = 1:1:dup_num

    fprintf('=== [%g] ===\n', idx);
    
    train_file = strcat(data_dir, 'NY_train_cr', num2str(int16(cr*100)), '_', num2str(idx), '.mat');
    data = load(train_file);
    Xtr_arr = data.Xtr_arr;
    Ytr_arr = data.Ytr_arr;

    % OLS: Ordinary Least Square 
    OLS_beta = Baseline_OLS(Xtr_arr, Ytr_arr);
    OLS_err = [OLS_err Metrics_MSE(Xte_arr, Yte_arr, OLS_beta)];

    % RLHH 
    RLHH_beta = Baseline_RLHH(Xtr_arr, Ytr_arr);
    RLHH_err = [RLHH_err Metrics_MSE(Xte_arr, Yte_arr, RLHH_beta)];

    % OPAA
    xi = 22;
    OPAA_beta = Baseline_OPAA(Xtr_arr, Ytr_arr, xi);
    OPAA_err = [OPAA_err Metrics_MSE(Xte_arr, Yte_arr, OPAA_beta)];

    % ORL
    ca = 1.9;
    ORL_beta = Baseline_ORL(Xtr_arr, Ytr_arr, 0.5, ca);
    ORL_err = [ORL_err Metrics_MSE(Xte_arr, Yte_arr, ORL_beta)];

    % ORL0
    ca = 1.9;
    ORL0_beta = Baseline_ORL(Xtr_arr, Ytr_arr, cr, ca);
    ORL0_err = [ORL0_err Metrics_MSE(Xte_arr, Yte_arr, ORL0_beta)];

    % BatchRC
    BatchRC_beta = BatchRC(Xtr_arr, Ytr_arr);
    BatchRC_err = [BatchRC_err Metrics_MSE(Xte_arr, Yte_arr, BatchRC_beta)];

    % OnlineRC
    batch_num = 7;
    OnlineRC_beta = OnlineRC(Xtr_arr, Ytr_arr, batch_num);
    OnlineRC_err = [OnlineRC_err Metrics_MSE(Xte_arr, Yte_arr, OnlineRC_beta)];

end

%fprintf('OLS_mse:[%f] RLHH_mse:[%f] OPAA_mse:[%f] ORL_mse:[%f] ORL0_mse:[%f] BatchRC_mse:[%f] OnlineRC_pc:[%f]\n', OLS_err/dup_num, RLHH_err/dup_num, OPAA_err/dup_num, ORL_err/dup_num, ORL0_err/dup_num, BatchRC_err/dup_num, OnlineRC_err/dup_num);
fprintf('OLS mean %.3f\t%.3f\n', mean(OLS_err), std(OLS_err));
fprintf('RLHH mean %.3f\t%.3f\n', mean(RLHH_err), std(RLHH_err));
fprintf('OPAA mean %.3f\t%.3f\n', mean(OPAA_err), std(OPAA_err));
fprintf('ORL mean %.3f\t%.3f\n', mean(ORL_err), std(ORL_err));
fprintf('ORL0 mean %.3f\t%.3f\n', mean(ORL0_err), std(ORL0_err));
fprintf('BatchRC mean %.3f\t%.3f\n', mean(BatchRC_err), std(BatchRC_err));
fprintf('OnlineR mean %.3f\t%.3f\n', mean(OnlineRC_err), std(OnlineRC_err));
