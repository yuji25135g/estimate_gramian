%{
�f�[�^�̐��^
���̓f�[�^U=[U1 U2 U3 ... ]
�o�̓f�[�^�Fone-hot
D=[D1 D2 D3 ...]

���͈���
trainData_num�F�f�[�^���i�Ƃ��Ă���V�X�e�����j
testData_num
size_a�FA�s��̃T�C�Y
time�F1�f�[�^������̃T���v�����O��
samplingWidth�F�T���v�����O��

%}

clear()
trainData_num = 1000;
size_a = 2;
time = 21;
train_U = [];
train_D = [];
train_A = [];
samplingWidth = 0.1;
for i = 1: trainData_num
    [u, ~, d, A] = data_gen_diag(size_a, time, samplingWidth);
    %A�s��̃f�[�^����
    train_A(:,:,i) = A;
    %���̓f�[�^�̐��^
    for i=1: time-1
        train_U = [train_U, u(:,i+1)-u(:,i)];
    end
    %�ڕW�o�̓f�[�^�̐��^
    D = [];
    for j = 1: time-1
        D = [D, d];
    end
    train_D = [train_D, D];
end


testData_num = 300;
test_U = [];
test_D = [];
test_A = [];
for i = 1: testData_num
    [u, ~, d, A] = data_gen_diag(size_a, time, samplingWidth);
    %A�s��̃f�[�^����
    test_A(:,:,i) = A;
   %���̓f�[�^�̐��^
     for i=1: time-1
        test_U = [test_U, u(:,i+1)-u(:,i)];
    end
    %�ڕW�o�̓f�[�^�̐��^
    D = [];
    for j = 1: time-1
        D = [D, d];
    end
    test_D = [test_D, D];
end