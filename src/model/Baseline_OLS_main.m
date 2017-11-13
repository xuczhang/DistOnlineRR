%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p = 100;
k = 10;
bNoise = 1;
idx = 1;
block_num = 10;
%cr = 0.1;
cr = 1;

data_file = FindDataPath( p, k, cr, bNoise, block_num, idx );
data = load(data_file);
Xtr_arr = data.Xtr_arr;
Ytr_arr = data.Ytr_arr;
beta_truth = data.beta;

%% Test different data sets
tic;
beta = Baseline_OLS(Xtr_arr, Ytr_arr);
toc;

fprintf('[%dK|p%d|%.2f] - |w-w*|: %f\n', k, p, cr, norm(beta_truth-beta));

