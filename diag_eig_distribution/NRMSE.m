function eval = NRMSE(d, y, T)

    %{
    d: �ڕW�o��
    y: ���f���o��
    d_ave: �ڕW�o�͂̎��ԕ���
    T: ����
    RMSE: �������ϓ��덷
    dist: �ڕW�o�͂̕��U
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