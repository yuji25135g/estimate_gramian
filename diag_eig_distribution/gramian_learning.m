%{
���͂���ϐ�
time�F1�f�[�^������̎��Ԕ��W
N_x�F���U�o�[�̃m�[�h��
%}


%�f�[�^�̓ǂݍ���
filename = 'tri_2dim'
load(filename)
%{
%�f�[�^�̃X�P�[�����O
data_scale = 10^-3;
data = data_scale * sunspotData;
%}

%�P���E���؃f�[�^��
trainU_size = size(train_U);
trainD_size = size(train_D);
testU_size = size(test_U);
size_A = size(train_A);
T_train = trainU_size(1,2);
T_test = testU_size(1,2);
time = 20;%1�f�[�^������̎��Ԕ��W


%�e�w�̃m�[�h��
N_u = trainU_size(1,1);
N_x = 5000;
N_y = trainD_size(1,1);

%Win�̐ݒ�
inputScale = 1;
Win = 2*inputScale*rand(N_x, N_u) - inputScale;


%W�̐ݒ�
density = 0.1;
rho = 0.95;
W = zeros(N_x); %w�̏������@�C�ӂɐݒ肷��ꍇ�͂����ɑ��
W = gen_randomW(N_x, density, W);
eigv_list = eig(W); %�����d�ݍs��w�̌ŗL�l
sp_radius = max(abs(eigv_list)); %���݂̃X�y�N�g�����a�i�ŗL�l�̐�Βl�̍ő�l�j
W = W * rho / sp_radius;  %�C�ӂ̃X�y�N�g�����arho�ɍ����悤��w���X�P�[�����O

%Wout�̐ݒ�
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
    [y_all, x_all] = RC(Win, W, Wout, u, N_u, N_x, N_y, T_train, zeros(N_x,1));
    %�f�[�^�̕ۑ�
    study_X(:,:,i) = x_all;
    study_Y(:,:,i) = y_all;
end

%���`��A-----------------------------------------------------------------------------------------------------------------------------
%���`��A���s�����߂̃f�[�^���`��
disp("linear")
b = 0.001; %�������p�����[�^
Wupd = Linear(study_X, train_D, b, N_x);

%W��ۑ�
save(filename + "_W", 'Wupd', 'Win', 'W')



%�P��RC���s�i�P���덷�����߂邽�߁j---------------------------------------------------------------------------------------------------------
disp("training")
train_X = [];
train_Y = [];
for i = 1: trainData_num
    u = train_U(:,:,i);
    [y_all, x_all] = RC(Win, W, Wupd, u, N_u, N_x, N_y, T_train, zeros(N_x,1));
    %�f�[�^�̕ۑ�
    train_X(:,:,i) = x_all;
    train_Y(:,:,i) = y_all;
end

%���x���o��----------------------------------------------------------------------------------------------------------------------
%���f���o�͂ɑ΂���
start = 1;
pre_train = zeros(N_y, T_train/time);
for i = 1: T_train/time
    tmp = train_Y(:,start:start+time-1); %1�f�[�^�ɑ΂���o��
    [~, max_index] = max(tmp); %�ő�o�͂�^����m�[�h�ԍ��̔z��
    pre_train(mode(max_index), i) = 1; %�e�f�[�^�ɑ΂���one-hot���i�[�����z��
    start = start+time;
end
%�ڕW�o�͂ɑ΂���
train_label = [];
for i = 1: T_train/time
    train_label = [train_label, train_D(:,i*time)];
end

%����RC���s----------------------------------------------------------------------------------------------------------------------------------
testData_num = 1;
disp("test")
test_X = [];
test_Y = [];
for i = 1: testData_num
    u = test_U(:,:,i);
    [y_all, x_all] = RC(Win, W, Wupd, u, N_u, N_x, N_y, T_test, train_X(:,end,1));
    %�f�[�^�̕ۑ�
    test_X(:,:,i) = x_all;
    test_Y(:,:,i) = y_all;
end

%���x���o��--------------------------------------------------------------------------------------------------------------------------
%���f���o�͂ɑ΂���
start = 1;
pre_test = zeros(N_y, T_test/time);
for i = 1: T_test/time
    tmp = test_Y(:,start:start+time-1); %1�f�[�^�ɑ΂���o��
    [~, max_index] = max(tmp); %�ő�o�͂�^����m�[�h�ԍ��̔z��
    pre_test(mode(max_index), i) = 1; %�e�f�[�^�ɑ΂���one-hot���i�[�����z��
    start = start+time;
end
%�ڕW�o�͂ɑ΂���
test_label = [];
for i = 1: T_test/time
    test_label = [test_label, test_D(:,i*time)];
end

%Training���ʂł��Ă��邩��A�s��̊֌W----------------------------------------------------------------------------------------
classified = [];
unclassified = [];
for i=1: T_train/time
    [~, index_train_label] = max(train_label(:,i));
    [~, index_pre_train] = max(pre_train(:,i));
    if index_train_label==index_pre_train
        classified = cat(3,classified,train_A(:,:,i));
    else
        %���Ό덷��10%�ȉ��Ȃ�classified�ɕ���
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

%Test���ʂł��Ă��邩��A�s��̊֌W----------------------------------------------------------------------------------------
classified = [];
unclassified = [];
for i=1: T_test/time
    [~, index_test_label] = max(test_label(:,i));
    [~, index_pre_test] = max(pre_test(:,i));
    if index_test_label==index_pre_test
        classified = cat(3,classified,test_A(:,:,i));
    else
        %���Ό덷��10%�ȉ��Ȃ�classified�ɕ���
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

%�����s��--------------------------------------------------------------------------------------------------------------------------
 plotconfusion(train_label, pre_train, 'Training', test_label, pre_test, 'Test')

%{
%���ʂł��Ȃ������ŗL�l�̕��z---------------------------------------------------------------------------------------
%�Ίp�������ŗL�l�̎��̂݉\
plot_x = [];
plot_y = [];
for i=1: size_unclassified(1,3)
    plot_x = [plot_x, unclassified(1,1,i)];
    plot_y = [plot_y, unclassified(2,2,i)];
end
figure()
plot(plot_x, plot_y, 'o')
%}

%���ʂł��Ȃ������V�X�e���̌ŗL�x�N�g��---------------------------------------------------------------------------------
eigVec = [];
size_unclassified = size(unclassified);
size_classified = size(classified);
for i=1: size_unclassified(1,3)
    [eigVec(:,:,i), ~] = eig(unclassified(:,:,i));
end
%{
%�O�p�s��̎��̂�
plot_x = [];
plot_y = [];
for i=1: size_unclassified(1,3)
    plot_x = [plot_x, eigVec(1,2,i)];
    plot_y = [plot_y, eigVec(2,2,i)];
end
figure()
plot(plot_x, plot_y, 'o')
%}




