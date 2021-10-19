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
trainData_num = 1;
size_a = 2;
time = 20;
train_U = [];
train_D = [];
train_A = [];
samplingWidth = 0.1;
for i = 1: trainData_num
    [u, ~, d, A] = data_gen_triangle(size_a, time, samplingWidth);
    %A�s��̃f�[�^����
    train_A(:,:,i) = A;
    %���̓f�[�^�̐��^
    train_U = [train_U, u];
    %�ڕW�o�̓f�[�^�̐��^
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
    %A�s��̃f�[�^����
    test_A(:,:,i) = A;
   %���̓f�[�^�̐��^
    test_U = [test_U, u];
    %�ڕW�o�̓f�[�^�̐��^
     size_u = size(u);
    D = [];
    for j = 1: size_u(1,2)
        D = [D, d];
    end
    test_D = [test_D, D];
end
