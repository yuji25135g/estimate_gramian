%{
データの成型
入力データU=[U1 U2 U3 ... ]
出力データ：one-hot
D=[D1 D2 D3 ...]

入力引数
trainData_num：データ数（とってくるシステム数）
testData_num
size_a：A行列のサイズ
time：1データあたりのサンプリング数
samplingWidth：サンプリング幅

%}

clear()
trainData_num = 500;
size_a = 10;
time = 20;
train_U = [];
train_D = [];
samplingWidth = 0.1;
for i = 1: trainData_num
    [u, ~, d, ~] = data_gen_diag(size_a, time, samplingWidth);
   
    %入力データの成型
    train_U = [train_U, u];
    %目標出力データの成型
    D = [];
    for j = 1: time
        D = [D, d];
    end
    train_D = [train_D, D];
end


testData_num = 500;
test_U = [];
test_D = [];
for i = 1: testData_num
    [u, ~, d, ~] = data_gen_diag(size_a, time, samplingWidth);
    
   %入力データの成型
    test_U = [test_U, u];
    %目標出力データの成型
    D = [];
    for j = 1: time
        D = [D, d];
    end
    test_D = [test_D, D];
end