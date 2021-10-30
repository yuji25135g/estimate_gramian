function [state_x, reshape_y, index, A] = data_gen_lowTriangle(size_a, time, samplingWidth)

    %{
        A行列が与えられたとき
        状態軌道：state_x
        y*を列ベクトルに変形：reshape_y
        可制御性グラミアンを最大にするone-hotベクトル：index
        を返す
    %}
   
    %A行列の生成
    A = lowTriangularA_gen(size_a);
    
    %A行列から状態を生成
    x0 = [0.5,1]';
    state_x = state_gen(size_a, time, A, samplingWidth, x0); 
    %状態の標準化
    %state_x = normalize(state_x);
   
    
    %tr(G)を最大にするインデックスとy*を導出
    %y*の生成
    y = y_star(size_a, A);
    %行列y*を列ベクトルに変形
    reshape_y = y(1,1);
    for j=2: size_a
        for i=1: j
            reshape_y = cat(1,reshape_y, y(i,j));
        end
    end
    %y*の対角最大値のインデックスを求める
    diag_y = diag(y);
    [~, k] = max(diag_y);
    index = zeros(size_a, 1);
    index(k,1) = 1;
end