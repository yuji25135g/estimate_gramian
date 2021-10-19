function x = state_gen(size_a, time, A, samplingWidth)

    %{
        与えられたA行列に対する状態軌道を1つ返します
        size_a : A行列のサイズ
        time : 離散な点を何点取ってくるか
    %}
    
    %初期状態
    %x0 = [1,1]';
    x0 = 2*rand(size_a, 1) -1;
    
    
    
    %時刻1からtimeまでの時間の配列
    t= samplingWidth*(1:time);
    %状態の初期化
    x = zeros(size_a,length(t));

    for ti = 1:length(t)
        x(:,ti) = expm(A*t(ti))*x0;
    end
end
