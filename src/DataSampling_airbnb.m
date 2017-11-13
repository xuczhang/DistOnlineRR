data_dir = 'D:/Dataset/OnlineRC/airbnb/LA/';
train_file = strcat(data_dir, 'NY_train');

data = load(train_file);
Xtr_arr = data.Xtr_arr;
Ytr_arr = data.Ytr_arr;

block_num = size(Ytr_arr, 2);
cr = 0.05;
dup_num = 10;

for idx = 1:1:dup_num

    b_finish = 0;
    while ~b_finish
        cr_v = rand(block_num, 1);
        cr_v = cr_v/sum(cr_v)*cr;

        a = cr_v(cr_v > 1/block_num);
        if size(a,1) == 0
            b_finish = 1;
        end
    end

    %disp(cr_v);
    %cr_v = [0.0625, 0, 0, 0, 0, 0, 0, 0.0625, 0.0625, 0, 0, 0, 0, 0, 0, 0.2125];

    for i=1:block_num

        Yi = Ytr_arr{i};
        n = size(Yi, 1);
        n_total = n*block_num;    
        n_o = int16(cr_v(i)*n_total); % corruption sample number(from 100 to 1200)
        n_u = n - n_o;

        u_range = 0.5*norm(Yi, inf);
        %u_range = 100*norm(ytr_a, inf);
        u = -u_range + 2*u_range*rand(n_o,1);


        ytr_a = Yi(1:n_u);
        ytr_o = Yi(n_u+1:end);
        ytr_o = ytr_o + u;
        Ytr_arr{i} = [ytr_a; ytr_o];

    end

    output_file = strcat(train_file, '_cr', num2str(int16(cr*100)), '_', num2str(idx), '.mat'); 
    save(output_file, 'Xtr_arr', 'Ytr_arr');

end