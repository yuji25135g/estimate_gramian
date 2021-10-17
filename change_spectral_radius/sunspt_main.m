%データの読み込み
sunspotTable = readtable('SN_ms_tot_V2.0.csv');
sunspotData = table2array(sunspotTable(:, 4)).';

%データのスケーリング
data_scale = 10^-3;
data = data_scale * sunspotData;

%ステップ数
step = 10;

%訓練・検証データ長
T_train = 2500;
dataSize = size(data);
T_test = dataSize(1,2) - T_train -step;

%訓練・検証用データ
train_U = data(1, 1:T_train);
train_D = data(1, step+1:T_train+step);

test_U = data(1, T_train+1:T_train+T_test);
test_D = data(1, T_train+step+1:T_train+T_test+step);

%各層のノード数
N_u = dataSize(1,1);
N_x = 300;
N_y = 1;

%Winの設定
rng(3);
inputScale = 0.1;
Win = 2*inputScale*rand(N_x, N_u) - inputScale;


%Wの設定
density = 0.1;
rho = 0.9;
W = zeros(N_x); %wの初期化　任意に設定する場合はここに代入
W = gen_randomW(N_x, density, W);
eigv_list = eig(W); %結合重み行列wの固有値
sp_radius = max(abs(eigv_list)); %現在のスペクトル半径（固有値の絶対値の最大値）
W = W * rho / sp_radius;  %任意のスペクトル半径rhoに合うようにwをスケーリング

%Woutの設定
rng(0)
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
    [y_all, x_all] = RC(Win, W, Wout, u, N_u, N_x, N_y, T_train);
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
    [y_all, x_all] = RC(Win, W, Wupd, u, N_u, N_x, N_y, T_train);
    %データの保存
    train_X(:,:,i) = x_all;
    train_Y(:,:,i) = y_all;
end

%検証RC実行----------------------------------------------------------------------------------------------------------------------------------
testData_num = 1;
disp("test")
test_X = [];
test_Y = [];
for i = 1: testData_num
    u = test_U(:,:,i);
    [y_all, x_all] = RC(Win, W, Wupd, u, N_u, N_x, N_y, T_test);
    %データの保存
    test_X(:,:,i) = x_all;
    test_Y(:,:,i) = y_all;
end

%NRMSE-------------------------------------------------------------------------------------------------------------------------------------
trainNRMSE = NRMSE(train_D/inputScale, train_Y(:,:,1)/inputScale, T_train)
testNRMSE = NRMSE(test_D/inputScale, test_Y(:,:,1)/inputScale, T_test)
