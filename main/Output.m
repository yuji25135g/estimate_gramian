function y = Output(outputWeight, x)
%x : 時刻n+1におけるリザバー層の状態ベクトル
%N_x : xの次元　リザバーのノード数
%N_y : 出力次元
y = outputWeight * x;
end
