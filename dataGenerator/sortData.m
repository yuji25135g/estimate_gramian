%{
testデータとしてtrainingデータを並べ替えたものを作る
%}

clear()
load('dataset1')

numberOfData = 500; %データ数
numberOfSampling = 10; %サンプリング数
queue = zeros(1,500);
sort = zeros(1,500); 
test_U = [];
test_D = [];

for i= 1:500
    q = randi(numberOfData);
    if queue(1,q) == 0
        test_U = [test_U, train_U(:,10*q-9:10*q)];
        test_D = [test_D, train_D(:, 10*q-9:10*q)];
        queue(1,q) = 1;
        sort(1,i) = q;
    else
        while queue(1,q) == 1
            q = randi(numberOfData);
        end
        test_U = [test_U, train_U(:,10*q-9:10*q)];
        test_D = [test_D, train_D(:, 10*q-9:10*q)];
        queue(1,q) = 1;
        sort(1,i) = q;
    end
end