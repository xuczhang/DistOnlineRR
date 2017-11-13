function [ beta, beta_arr, mc] = OnlineRC(Xtr_arr, Ytr_arr, batch_num)
    
    block_num = size(Ytr_arr, 2);
    %batch_num = 10;
    Xtr_arr_batch = Xtr_arr(1:batch_num);
    Ytr_arr_batch = Ytr_arr(1:batch_num);

    %% Test different data sets
    [beta, beta_arr, mc] = BatchRC(Xtr_arr_batch, Ytr_arr_batch);
    %fprintf('[|w-w*|: %f\n', norm(beta_truth-beta));

    for i = batch_num+1:block_num
        [beta, beta_arr, mc] = OnlineRC_inc(beta_arr, mc, Xtr_arr{i}, Ytr_arr{i});
        %fprintf('|w-w*|: %f\n', norm(beta_truth-beta));
    end

end
