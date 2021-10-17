%{
データの成型
入力データU=[U1 U2 U3 ... ]
入力データを適当な(1,3)行列Gを用いて1次元に写像
出力データ：one-hot
D=[D1 D2 D3 ...]
%}

clear()
rng(0);
trainData_num = 10;
size_a = 3;
time = 10;
G = rand(1,size_a);
train_U = [];
train_D = [];
for i = 1: trainData_num
    [u, ~, d, ~] = data_gen(size_a, time);
   
    %入力データの成型
    train_U = [train_U, u];
    %目標出力データの成型
    D = [];
    for j = 1: time
        D = [D, d];
    end
    train_D = [train_D, D];
end
train_U = G*train_U;


testData_num = 10;
test_U = [];
test_D = [];
for i = 1: testData_num
    [u, ~, d, ~] = data_gen(size_a, time);
    
   %入力データの成型
    test_U = [test_U, u];
    %目標出力データの成型
    D = [];
    for j = 1: time
        D = [D, d];
    end
    test_D = [test_D, D];
end
test_U = G*test_U;