function [ data_file ] = FindDataPath( p, k, cr, bNoise, block_num, idx )
%MAPDATAPATH Summary of this function goes here
%   Detailed explanation goes here
    
    %data_path = '~/Dataset/PersonPred/synthetic/';
    data_path = 'D:/Dataset/OnlineRC/synthetic/';    
   
    str_noise = '';
    if ~bNoise
        str_noise = 'nn_';
    end
    data_file = strcat(data_path, num2str(block_num), 'B_', num2str(k), 'K_', 'p', num2str(p), '_', str_noise, 'c', num2str(int16(cr*100)), '_', num2str(idx), '.mat');
    
end

