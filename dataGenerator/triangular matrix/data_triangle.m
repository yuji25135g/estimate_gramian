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
trainData_num = 1;
size_a = 2;
time = 20;
train_U = [];
train_D = [];
train_A = [];
samplingWidth = 0.1;
for i = 1: trainData_num
    [u, ~, d, A] = data_gen_triangle(size_a, time, samplingWidth);
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


testData_num = 1;
test_U = [];
test_D = [];
test_A = [];
for i = 1: testData_num
    [u, ~, d, A] = data_gen_triangle(size_a, time, samplingWidth);
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
