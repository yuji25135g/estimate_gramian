%{
�f�[�^�̐��^
���̓f�[�^U=[U1 U2 U3 ... ]
���̓f�[�^��K����(1,3)�s��G��p����1�����Ɏʑ�
�o�̓f�[�^�Fone-hot
D=[D1 D2 D3 ...]
%}

clear()
rng(0);
trainData_num = 10;
size_a = 3;
time = 10;
G = rand(1,size_a);
train_U = [];
train_D = [];
for i = 1: trainData_num
    [u, ~, d, ~] = data_gen(size_a, time);
   
    %���̓f�[�^�̐��^
    train_U = [train_U, u];
    %�ڕW�o�̓f�[�^�̐��^
    D = [];
    for j = 1: time
        D = [D, d];
    end
    train_D = [train_D, D];
end
train_U = G*train_U;


testData_num = 10;
test_U = [];
test_D = [];
for i = 1: testData_num
    [u, ~, d, ~] = data_gen(size_a, time);
    
   %���̓f�[�^�̐��^
    test_U = [test_U, u];
    %�ڕW�o�̓f�[�^�̐��^
    D = [];
    for j = 1: time
        D = [D, d];
    end
    test_D = [test_D, D];
end
test_U = G*test_U;