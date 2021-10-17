%�f�[�^�̓ǂݍ���
sunspotTable = readtable('SN_ms_tot_V2.0.csv');
sunspotData = table2array(sunspotTable(:, 4)).';

%�f�[�^�̃X�P�[�����O
data_scale = 10^-3;
data = data_scale * sunspotData;

%�X�e�b�v��
step = 10;

%�P���E���؃f�[�^��
T_train = 2500;
dataSize = size(data);
T_test = dataSize(1,2) - T_train -step;

%�P���E���ؗp�f�[�^
train_U = data(1, 1:T_train);
train_D = data(1, step+1:T_train+step);

test_U = data(1, T_train+1:T_train+T_test);
test_D = data(1, T_train+step+1:T_train+T_test+step);

%�e�w�̃m�[�h��
N_u = dataSize(1,1);
N_x = 300;
N_y = 1;

%Win�̐ݒ�
rng(3);
inputScale = 0.1;
Win = 2*inputScale*rand(N_x, N_u) - inputScale;


%W�̐ݒ�
density = 0.1;
rho = 0.9;
W = zeros(N_x); %w�̏������@�C�ӂɐݒ肷��ꍇ�͂����ɑ��
W = gen_randomW(N_x, density, W);
eigv_list = eig(W); %�����d�ݍs��w�̌ŗL�l
sp_radius = max(abs(eigv_list)); %���݂̃X�y�N�g�����a�i�ŗL�l�̐�Βl�̍ő�l�j
W = W * rho / sp_radius;  %�C�ӂ̃X�y�N�g�����arho�ɍ����悤��w���X�P�[�����O

%Wout�̐ݒ�
rng(0)
ave = 0; %����
sd = 1; %�W���΍�
Wout = sd*randn(N_y, N_x) + ave;

%�w�KRC���s-------------------------------------------------------------------------------------------------------------------------------
trainData_num = 1;
disp("study")
study_X = [];
study_Y = [];
for i = 1: trainData_num
    u = train_U(:,:,i);
    [y_all, x_all] = RC(Win, W, Wout, u, N_u, N_x, N_y, T_train);
    %�f�[�^�̕ۑ�
    study_X(:,:,i) = x_all;
    study_Y(:,:,i) = y_all;
end

%���`��A-----------------------------------------------------------------------------------------------------------------------------
%���`��A���s�����߂̃f�[�^���`��
disp("linear")
b = 0.001; %�������p�����[�^
Wupd = Linear(study_X, train_D, b, N_x);


%�P��RC���s�i�P���덷�����߂邽�߁j---------------------------------------------------------------------------------------------------------
disp("training")
train_X = [];
train_Y = [];
for i = 1: trainData_num
    u = train_U(:,:,i);
    [y_all, x_all] = RC(Win, W, Wupd, u, N_u, N_x, N_y, T_train);
    %�f�[�^�̕ۑ�
    train_X(:,:,i) = x_all;
    train_Y(:,:,i) = y_all;
end

%����RC���s----------------------------------------------------------------------------------------------------------------------------------
testData_num = 1;
disp("test")
test_X = [];
test_Y = [];
for i = 1: testData_num
    u = test_U(:,:,i);
    [y_all, x_all] = RC(Win, W, Wupd, u, N_u, N_x, N_y, T_test);
    %�f�[�^�̕ۑ�
    test_X(:,:,i) = x_all;
    test_Y(:,:,i) = y_all;
end

%NRMSE-------------------------------------------------------------------------------------------------------------------------------------
trainNRMSE = NRMSE(train_D/inputScale, train_Y(:,:,1)/inputScale, T_train)
testNRMSE = NRMSE(test_D/inputScale, test_Y(:,:,1)/inputScale, T_test)
