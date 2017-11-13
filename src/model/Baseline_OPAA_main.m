%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p = 100;
k = 5;
bNoise = 0;
idx = 1;
block_num = 10;
%cr = 0.45;
cr = 0.00;

data_file = FindDataPath( p, k, cr, bNoise, block_num, idx );
data = load(data_file);
Xtr_arr = data.Xtr_arr;
Ytr_arr = data.Ytr_arr;
beta_truth = data.beta;

%% Test different data sets
tic;
for xi = 0.001:0.001:1
%for xi = 0.01:0.001:0.1
    beta = Baseline_OPAA(Xtr_arr, Ytr_arr, xi);
    fprintf('%g: %f\n', xi, norm(beta_truth-beta));
end
toc;

fprintf('[%dK|p%d|%.2f] - |w-w*|: %f\n', k, p, cr, norm(beta_truth-beta));

