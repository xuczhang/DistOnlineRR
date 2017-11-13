%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p = 100;
k = 10;
bNoise = 1;
idx = 1;
block_num = 10;
cr = 0.1;

n = 1000*k;
n_o = int16(cr*n);

if bNoise == 1
    noise_str = ''; 
else
    noise_str = 'nn_';
end

data_file = FindDataPath( p, k, cr, bNoise, block_num, idx );
data = load(data_file);
Xtr_arr = data.Xtr_arr;
Ytr_arr = data.Ytr_arr;
beta_truth = data.beta;
batch_num = 7;
%% Test different data sets
tic;
[beta] = OnlineRC(Xtr_arr, Ytr_arr, batch_num);
toc;

fprintf('[%dK|p%d|%.2f] - |w-w*|: %f\n', k, p, cr, norm(beta_truth-beta));