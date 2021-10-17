
function x = Reserver(reservoirWeight, reservoirInput, preX)

%w：リザバー結合重み行列
%rho : スペクトル半径
%activation_func : 活性化関数
%x_in : 入力層からの状態ベクトル
%alpha : リーク率


x = tanh(reservoirWeight * preX + reservoirInput);
end


