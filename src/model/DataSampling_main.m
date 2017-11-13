p = 100; % feature dimension
k = 5;
b = 10;

bNoise = 1;
idx = 1;

% generate the single data
%cr = 0.4;
%DataSampling( p, k, cr, bNoise, b, idx);

% generate the data per different corruption ratio

%% Beta Recovery Settings
% p = 100; k = 5; b = 10; bNoise = 1;
% p = 100; k = 10; b = 10; bNoise = 1;
% p = 400; k = 10; b = 10; bNoise = 1;
% p = 100; k = 10; b = 30; bNoise = 1;
% p = 100; k = 5; b = 10; bNoise = 0;
% p = 200; k = 10; b = 20; bNoise = 0;
%{
for cr = 0.05:0.05:0.4
    for idx = 1:1:10
        DataSampling( p, k, cr, bNoise, b, idx);
    end    
end
%}

%% Efficiency Settings
%{
p = 200; k = 5; b = 10; bNoise = 0;
for cr = 0.05:0.05:0.4
    for idx = 1:1:10
        DataSampling( p, k, cr, bNoise, b, idx);
    end    
end
%}
p = 100; cr=0.4; b = 10; bNoise = 1;
for k = 1:1:10
    for idx = 1:1:10
        DataSampling( p, k, cr, bNoise, b, idx);
    end    
end


p = 100; cr=0.4; k = 5; bNoise = 1;
for b = 10:2:30
    for idx = 1:1:10
        DataSampling( p, k, cr, bNoise, b, idx);
    end    
end
%{%}


% generate the data per different uncorrupted data size
%{
cr = 0.1;
for k = 1:1:10
    for idx = 1:1:10
        DataSampling( p, k, cr, bNoise, idx);
    end
end
%}

%% generate the extreme case with corrupted batches

% p = 100; k = 5; b = 20; bNoise = 1;
% %DataSampling_batchcorr( p, k, batch_cr, bNoise, b, idx);
% batch_cr_list = [0, 0.05, 0.1, 0.2, 0.3, 0.4];
% for i = 1:1:size(batch_cr_list, 2)    
%     bcr = batch_cr_list(i);
%     for idx = 1:1:10
%         DataSampling_batchcorr( p, k, bcr, bNoise, b, idx);
%     end    
% end


