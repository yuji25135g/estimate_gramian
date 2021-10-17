function [trainNRMSE, testNRMSE] = main(rho, i_scale, i_scale_b)


    %{
    main.m
    �����̓��͂Ə����̎��s�݂̂��s��. �����̓��e�͕ʂ̃X�N���v�g�ɏ���. 

    ����
    �E�e�w�̃m�[�h��, w�̏����l�Ȃ�, RC���s����Œl���ς��Ȃ�����
    �E�P��RC�̃f�[�^, �P��RC�̎��s
    �Ew_out�̍X�V
    �E����RC�̃f�[�^, ����RC�̎��s
    �E�]��
    �E�O���t��

    %}


    %�f�[�^�̃C���|�[�g
    load('dataset3')
    load('w_edge30', 'w')

    %�f�[�^�������̃p�����[�^
    size_a = 3;
    state_num = 6;
    time = 10;

    %�e�w�̃m�[�h�̌�
    N_u = size_a + 1;
    N_x = 3000;
    N_y = 3;


    %w_in�̐ݒ�
    rng(0)
    w_in=[2*i_scale*rand(N_x, N_u-1) - i_scale, 2*i_scale_b*rand(N_x, 1) - i_scale_b]; %�����_����Win�̐����@�C�ӂɐݒ肷��ꍇ�̓R�����g�A�E�g
    %w_in = zeros(N_x, N_u)  %�C�ӂ�W_in��ݒ�


    %w�̐ݒ�
    eigv_list = eig(w); %�����d�ݍs��w�̌ŗL�l
    sp_radius = max(abs(eigv_list)); %���݂̃X�y�N�g�����a�i�ŗL�l�̐�Βl�̍ő�l�j
    w = w * rho / sp_radius;  %�C�ӂ̃X�y�N�g�����arho�ɍ����悤��w���X�P�[�����O


    %w_out�̏����l
    w_out = rand(N_y, N_x);


    %-----------------------------------------------------------------------------------------------------------------------------------------------------


    %�w�KRC���s
    trainData_num = 1000;
    disp("study")
    for i = 1: trainData_num
        u = studyData_u(:,:,i);
        %RC���s
        [y_all, x_all] = RC(w_in, u, w, w_out, N_x, N_y, time);
        %�f�[�^�̕ۑ�
        studyData_x(:,:,i) = x_all;
        studyData_y(:,:,i) = y_all;
    end

    %-----------------------------------------------------------------------------------------------------------------------------------------


    %���`��A
    %���`��A���s�����߂̃f�[�^���`��
    studyX = [];
    studyD = [];
    disp("linear")
    for i = 1: trainData_num
        studyX = [studyX, studyData_x(:,end,i)];
        studyD = [studyD, studyData_diag_y(:,end, i)];
    end
    b = 0.001; %�������p�����[�^
    w_upd = Linear(studyX, studyD, b, N_x);


    %--------------------------------------------------------------------------------------------------------------------------------------------


    %�P��RC���s�i�P���덷�����߂邽�߁j
    
    disp("training")
    for i= 1: trainData_num
        u = studyData_u(:,:,i);
        %RC���s
        [y_all, x_all] = RC(w_in, u, w, w_upd, N_x, N_y, time);
         %�f�[�^�̕ۑ�
        trainData_x(:,:,i) = x_all;
        trainData_y(:,:,i) = y_all;
    end

    studyY = [];
    for i = 1: trainData_num
        studyY = [studyY, trainData_y(:,end,i)];
    end
    trainNRMSE = NRMSE(studyD, studyY, trainData_num)
    %----------------------------------------------------------------------------------------------------------------------------------------------------------


    %����RC���s
    testData_num = 100;
    disp("test")
    for i = 1: testData_num
        u = testData_u(:,:,i);
        %RC���s
        [y_all, x_all] = RC(w_in, u, w, w_upd, N_x, N_y, time);
        %�f�[�^�̕ۑ�
        testData_x(:,:,i) = x_all;
        testData_y(:,:,i) = y_all;
    end
    testY = [];
    testD = [];
    for i = 1: testData_num
        testY = [testY, testData_y(:,end,i)];
        testD = [testD, testData_diag_y(:,end, i)];
    end
    %testNRMSE = NRMSE(testD, testY, testData_num)
    
    %���ʗ��̕\��
    %���ʗ��p�̃f�[�^�𐶐�
    trainY = [];
    trainD = [];
    for i = 1: trainData_num
        trainY = [trainY, trainData_y(:,end,i)];
        trainD = [trainD, studyData_d(:,end, i)];
    end
    testY = [];
    testD = [];
    for i = 1: testData_num
        testY = [testY, testData_y(:,end,i)];
        testD = [testD, testData_d(:,end, i)];
    end
    name = "Training rho = "+ rho + " inputScale"+ i_scale + "inputScaleBias"+i_scale_b;
    plotconfusion(trainD, trainY, name, testD, testY, 'Test')
    
end