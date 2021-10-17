function eval = NRMSE(d, y, T)

    %{
    d: 目標出力
    y: モデル出力
    d_ave: 目標出力の時間平均
    T: 時間
    RMSE: 平方平均二乗誤差
    dist: 目標出力の分散
    %}

    d_ave = 0;
    RMSE = 0;
    dist = 0;
    for i = 1: T
        d_ave = d_ave + d(:, i);
    end
    d_ave = d_ave / T;

    for i = 1: T
        RMSE = RMSE + norm((d(:, i) - y(:, i)))^2;
    end
    RMSE = sqrt(RMSE / T);

    for i = 1: T
        dist = dist + norm((d(:, i) - d_ave))^2;
    end
    dist = sqrt(dist / T);

    eval = RMSE / dist;

end