p = 100;
k = 5;
bNoise = 1;
idx = 1;
block_num = 10;

noise_str = '';
if ~bNoise
   noise_str = 'nn_'; 
end

result_path = 'D:/Dropbox/PHD/publications/ICDM2017_OnlineRC/experiment/result/';
data_file = strcat(result_path, 'beta_', num2str(block_num), 'B_', num2str(k), 'K_', 'p', num2str(p), '_', noise_str);
data_file = data_file(1:end-1);
data_file = strcat(data_file, '.mat');
data = load(data_file);

OLS_result = [];
RLHH_result = [];
OPAA_result = [];
ORL_result = [];
ORL0_result = [];
BatchRC_result = [];
OnlineRC_result = [];

OLS_result = data.OLS_result;
RLHH_result = data.RLHH_result;
OPAA_result = data.OPAA_result;
ORL_result = data.ORL_result;
ORL0_result = data.ORL0_result;
BatchRC_result = data.BatchRC_result;
OnlineRC_result = data.OnlineRC_result;


%DALM_result=[2.4906760053086127E-5	3.7280152736324004E-5	6.017474045675697E-5	1.456688290437281E-4	1.8890984941908115E-4	1.3762897910283455E-4	3.010575562756539E-5	6.338419044563433E-5];
%HOMO_result=[0.7287555205551277	1.0252304984480949	1.2098846634372749	1.4156722615485728	1.584129383333287	1.8587952429908654	2.0543520818995007	2.26959632211357];

save(data_file, 'OLS_result', 'RLHH_result', 'OPAA_result', 'ORL_result', 'ORL0_result', 'BatchRC_result', 'OnlineRC_result');
