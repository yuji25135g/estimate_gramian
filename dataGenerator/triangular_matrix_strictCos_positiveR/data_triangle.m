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

上三角行列と下三角行列から半分ずつとってくる
順番はバラバラに

%}

clear()
trainData_num = 600;
size_a = 2;
time = 20;
train_U = [];
train_D = [];
train_A = [];
samplingWidth = 0.1;
for i = 1: trainData_num/2
    [u, ~, d, A] = data_gen_upTriangle(size_a, time, samplingWidth);
    %A行列のデータ生成
    train_A(:,:,i) = A;
    %入力データの成型
    train_U = [train_U, u];
    %目標出力データの成型
    size_u = size(u);
    D = [];
    for j = 1: size_u(1,2)
        D = [D, d];
    end
    train_D = [train_D, D];
end
for i = trainData_num/2+1: trainData_num
    [u, ~, d, A] = data_gen_lowTriangle(size_a, time, samplingWidth);
    %A行列のデータ生成
    train_A(:,:,i) = A;
    %入力データの成型
    train_U = [train_U, u];
    %目標出力データの成型
    size_u = size(u);
    D = [];
    for j = 1: size_u(1,2)
        D = [D, d];
    end
    train_D = [train_D, D];
end
[train_A, train_U, train_D] = sortData(train_A, train_U, train_D, trainData_num, time);

testData_num = 300;
test_U = [];
test_D = [];
test_A = [];
for i = 1: testData_num/2
    [u, ~, d, A] = data_gen_upTriangle_positive(size_a, time, samplingWidth);
    %A行列のデータ生成
    test_A(:,:,i) = A;
   %入力データの成型
    test_U = [test_U, u];
    %目標出力データの成型
     size_u = size(u);
    D = [];
    for j = 1: size_u(1,2)
        D = [D, d];
    end
    test_D = [test_D, D];
end
for i = testData_num/2+1: testData_num
    [u, ~, d, A] = data_gen_lowTriangle_positive(size_a, time, samplingWidth);
    %A行列のデータ生成
    test_A(:,:,i) = A;
   %入力データの成型
    test_U = [test_U, u];
    %目標出力データの成型
     size_u = size(u);
    D = [];
    for j = 1: size_u(1,2)
        D = [D, d];
    end
    test_D = [test_D, D];
end
[test_A, test_U, test_D] = sortData(test_A, test_U, test_D, testData_num, time);
