%{
入力する変数
time：1データ当たりの時間発展
N_x：リザバーのノード数
%}


%データの読み込み
load('dataset1_from_diag')

%{
%データのスケーリング
data_scale = 10^-3;
data = data_scale * sunspotData;
%}

%訓練・検証データ長
trainU_size = size(train_U);
trainD_size = size(train_D);
testU_size = size(test_U);
T_train = trainU_size(1,2);
T_test = testU_size(1,2);
time = 20;%1データあたりの時間発展


%各層のノード数
N_u = trainU_size(1,1);
N_x = 5000;
N_y = trainD_size(1,1);

%Winの設定
inputScale = 1;
Win = 2*inputScale*rand(N_x, N_u) - inputScale;


%Wの設定
density = 0.1;
rho = 0.95;
W = zeros(N_x); %wの初期化　任意に設定する場合はここに代入
W = gen_randomW(N_x, density, W);
eigv_list = eig(W); %結合重み行列wの固有値
sp_radius = max(abs(eigv_list)); %現在のスペクトル半径（固有値の絶対値の最大値）
W = W * rho / sp_radius;  %任意のスペクトル半径rhoに合うようにwをスケーリング

%Woutの設定
ave = 0; %平均
sd = 1; %標準偏差
Wout = sd*randn(N_y, N_x) + ave;

%学習RC実行-------------------------------------------------------------------------------------------------------------------------------
trainData_num = 1;
disp("study")
study_X = [];
study_Y = [];
for i = 1: trainData_num
    u = train_U(:,:,i);
    [y_all, x_all] = RC(Win, W, Wout, u, N_u, N_x, N_y, T_train, zeros(N_x,1));
    %データの保存
    study_X(:,:,i) = x_all;
    study_Y(:,:,i) = y_all;
end

%線形回帰-----------------------------------------------------------------------------------------------------------------------------
%線形回帰を行うためのデータを形成
disp("linear")
b = 0.001; %正則化パラメータ
Wupd = Linear(study_X, train_D, b, N_x);


%訓練RC実行（訓練誤差を求めるため）---------------------------------------------------------------------------------------------------------
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

%混同行列--------------------------------------------------------------------------------------------------------------------------
 plotconfusion(train_label, pre_train, 'Training', test_label, pre_test, 'Test')
    

%識別できているかとA行列の関係----------------------------------------------------------------------------------------
classified = [];
unclassified = [];
for i=1: T_test/time
    if test_label(:,i)==pre_test(:,i)
        classified = cat(3,classified,test_A(:,:,i));
    else
        unclassified = cat(3,unclassified,test_A(:,:,i));
    end
end

%識別できなかった固有値の分布---------------------------------------------------------------------------------------
%plotようの配列を作る
plot_x = [];
plot_y = [];
size_unclassified = size(unclassified);
for i=1: size_unclassified(1,3)
    plot_x = [plot_x, unclassified(1,1,i)];
    plot_y = [plot_y, unclassified(2,2,i)];
end
plot(plot_x, plot_y, 'o')
