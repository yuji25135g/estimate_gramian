%{
入力する変数
time：1データ当たりの時間発展
N_x：リザバーのノード数
%}

clear()
%データの読み込み
filename = 'diag_2dim'
load(filename)
load(filename + "_W")
%{
%データのスケーリング
data_scale = 10^-3;
data = data_scale * sunspotData;
%}

%訓練・検証データ長
trainU_size = size(train_U);
trainD_size = size(train_D);
testU_size = size(test_U);
size_A = size(train_A);
T_train = trainU_size(1,2);
T_test = testU_size(1,2);
time = 20;%1データあたりの時間発展


%各層のノード数
N_u = trainU_size(1,1);
N_x = 5000;
N_y = trainD_size(1,1);



%訓練RC実行（訓練誤差を求めるため）---------------------------------------------------------------------------------------------------------
trainData_num = 1;
disp("training")
train_X = [];
train_Y = [];
for i = 1: trainData_num
    u = train_U(:,:,i);
    [y_all, x_all] = RC(Win, W, Wupd, u, N_u, N_x, N_y, T_train, zeros(N_x,1));
    %データの保存
    train_X(:,:,i) = x_all;
    train_Y(:,:,i) = y_all;
end

%ラベル出力----------------------------------------------------------------------------------------------------------------------
%モデル出力に対して
start = 1;
pre_train = zeros(N_y, T_train/time);
for i = 1: T_train/time
    tmp = train_Y(:,start:start+time-1); %1データに対する出力
    [~, max_index] = max(tmp); %最大出力を与えるノード番号の配列
    pre_train(mode(max_index), i) = 1; %各データに対するone-hotを格納した配列
    start = start+time;
end
%目標出力に対して
train_label = [];
for i = 1: T_train/time
    train_label = [train_label, train_D(:,i*time)];
end

%検証RC実行----------------------------------------------------------------------------------------------------------------------------------
testData_num = 1;
disp("test")
test_X = [];
test_Y = [];
for i = 1: testData_num
    u = test_U(:,:,i);
    [y_all, x_all] = RC(Win, W, Wupd, u, N_u, N_x, N_y, T_test, train_X(:,end,1));
    %データの保存
    test_X(:,:,i) = x_all;
    test_Y(:,:,i) = y_all;
end

%ラベル出力--------------------------------------------------------------------------------------------------------------------------
%モデル出力に対して
start = 1;
pre_test = zeros(N_y, T_test/time);
for i = 1: T_test/time
    tmp = test_Y(:,start:start+time-1); %1データに対する出力
    [~, max_index] = max(tmp); %最大出力を与えるノード番号の配列
    pre_test(mode(max_index), i) = 1; %各データに対するone-hotを格納した配列
    start = start+time;
end
%目標出力に対して
test_label = [];
for i = 1: T_test/time
    test_label = [test_label, test_D(:,i*time)];
end

%Training識別できているかとA行列の関係----------------------------------------------------------------------------------------
classified = [];
unclassified = [];
for i=1: T_train/time
    [~, index_train_label] = max(train_label(:,i));
    [~, index_pre_train] = max(pre_train(:,i));
    if index_train_label==index_pre_train
        classified = cat(3,classified,train_A(:,:,i));
    else
        %相対誤差が10%以下ならclassifiedに分類
        yStar = y_star(size_A(1,1),train_A(:,:,i));
        diag_yStar = diag(yStar);
        true = diag_yStar(index_train_label);
        est = diag_yStar(index_pre_train, 1);
        if -0.1<=relative_error(est,true)&&relative_error(est,true)<=0.1
            classified = cat(3,classified,train_A(:,:,i));
            pre_train(:,i) = train_label(:,i);
        else
            unclassified = cat(3,unclassified,train_A(:,:,i));
        end
    end
end

%Test識別できているかとA行列の関係----------------------------------------------------------------------------------------
classified = [];
unclassified = [];
for i=1: T_test/time
    [~, index_test_label] = max(test_label(:,i));
    [~, index_pre_test] = max(pre_test(:,i));
    if index_test_label==index_pre_test
        classified = cat(3,classified,test_A(:,:,i));
    else
        %相対誤差が10%以下ならclassifiedに分類
        yStar = y_star(size_A(1,1),test_A(:,:,i));
        diag_yStar = diag(yStar);
        true = diag_yStar(index_test_label);
        est = diag_yStar(index_pre_test, 1);
        if -0.1<=relative_error(est,true)&&relative_error(est,true)<=0.1
            classified = cat(3,classified,test_A(:,:,i));
            pre_test(:,i) = test_label(:,i);
        else
            unclassified = cat(3,unclassified,test_A(:,:,i));
        end
    end
end

%混同行列--------------------------------------------------------------------------------------------------------------------------
 plotconfusion(train_label, pre_train, 'Training', test_label, pre_test, 'Test')

%{
%識別できなかった固有値の分布---------------------------------------------------------------------------------------
%対角成分が固有値の時のみ可能
plot_x = [];
plot_y = [];
for i=1: size_unclassified(1,3)
    plot_x = [plot_x, unclassified(1,1,i)];
    plot_y = [plot_y, unclassified(2,2,i)];
end
figure()
plot(plot_x, plot_y, 'o')
%}

%識別できなかったシステムの固有ベクトル---------------------------------------------------------------------------------
eigVec = [];
size_unclassified = size(unclassified);
size_classified = size(classified);
for i=1: size_unclassified(1,3)
    [eigVec(:,:,i), ~] = eig(unclassified(:,:,i));
end
%{
%三角行列の時のみ
plot_x = [];
plot_y = [];
for i=1: size_unclassified(1,3)
    plot_x = [plot_x, eigVec(1,2,i)];
    plot_y = [plot_y, eigVec(2,2,i)];
end
figure()
plot(plot_x, plot_y, 'o')
%}





