function [trainNRMSE, testNRMSE] = main(rho, i_scale, i_scale_b)


    %{
    main.m
    引数の入力と処理の実行のみを行う. 処理の内容は別のスクリプトに書く. 

    流れ
    ・各層のノード数, wの初期値など, RCを行う上で値が変わらないもの
    ・訓練RCのデータ, 訓練RCの実行
    ・w_outの更新
    ・検証RCのデータ, 検証RCの実行
    ・評価
    ・グラフ化

    %}


    %データのインポート
    load('dataset3')
    load('w_edge30', 'w')

    %データ生成時のパラメータ
    size_a = 3;
    state_num = 6;
    time = 10;

    %各層のノードの個数
    N_u = size_a + 1;
    N_x = 3000;
    N_y = 3;


    %w_inの設定
    rng(0)
    w_in=[2*i_scale*rand(N_x, N_u-1) - i_scale, 2*i_scale_b*rand(N_x, 1) - i_scale_b]; %ランダムなWinの生成　任意に設定する場合はコメントアウト
    %w_in = zeros(N_x, N_u)  %任意にW_inを設定


    %wの設定
    eigv_list = eig(w); %結合重み行列wの固有値
    sp_radius = max(abs(eigv_list)); %現在のスペクトル半径（固有値の絶対値の最大値）
    w = w * rho / sp_radius;  %任意のスペクトル半径rhoに合うようにwをスケーリング


    %w_outの初期値
    w_out = rand(N_y, N_x);


    %-----------------------------------------------------------------------------------------------------------------------------------------------------


    %学習RC実行
    trainData_num = 1000;
    disp("study")
    for i = 1: trainData_num
        u = studyData_u(:,:,i);
        %RC実行
        [y_all, x_all] = RC(w_in, u, w, w_out, N_x, N_y, time);
        %データの保存
        studyData_x(:,:,i) = x_all;
        studyData_y(:,:,i) = y_all;
    end

    %-----------------------------------------------------------------------------------------------------------------------------------------


    %線形回帰
    %線形回帰を行うためのデータを形成
    studyX = [];
    studyD = [];
    disp("linear")
    for i = 1: trainData_num
        studyX = [studyX, studyData_x(:,end,i)];
        studyD = [studyD, studyData_diag_y(:,end, i)];
    end
    b = 0.001; %正則化パラメータ
    w_upd = Linear(studyX, studyD, b, N_x);


    %--------------------------------------------------------------------------------------------------------------------------------------------


    %訓練RC実行（訓練誤差を求めるため）
    
    disp("training")
    for i= 1: trainData_num
        u = studyData_u(:,:,i);
        %RC実行
        [y_all, x_all] = RC(w_in, u, w, w_upd, N_x, N_y, time);
         %データの保存
        trainData_x(:,:,i) = x_all;
        trainData_y(:,:,i) = y_all;
    end

    studyY = [];
    for i = 1: trainData_num
        studyY = [studyY, trainData_y(:,end,i)];
    end
    trainNRMSE = NRMSE(studyD, studyY, trainData_num)
    %----------------------------------------------------------------------------------------------------------------------------------------------------------


    %検証RC実行
    testData_num = 100;
    disp("test")
    for i = 1: testData_num
        u = testData_u(:,:,i);
        %RC実行
        [y_all, x_all] = RC(w_in, u, w, w_upd, N_x, N_y, time);
        %データの保存
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
    
    %識別率の表示
    %識別率用のデータを生成
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