%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p = 100;
k = 10;
block_num = 10;
cr = 1;
bNoise = 1;
idx = 1;

data_file = FindDataPath( p, k, cr, bNoise, block_num, idx );
data = load(data_file);
Xtr_arr = data.Xtr_arr;
Ytr_arr = data.Ytr_arr;
beta_truth = data.beta;

%% Test different data sets
tic;
%cr = 0.8;
%for ca = 100:1:300
ca = 106;
for ca = 1.1:0.1:3
    beta = Baseline_ORL(Xtr_arr, Ytr_arr, cr, ca);
    fprintf('[%g] %f\n', ca, norm(beta_truth-beta));
end
toc;

fprintf('[%dK|p%d|%.2f] - |w-w*|: %f\n', k, p, cr, norm(beta_truth-beta));

