%{
スペクトル半径を変化させながらRCをまわす
%}

rho = [0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1.0, 1.05, 1.1, 1.15, 1.2];

resultTrain_X = [];
resultTrain_Y = [];
resultTest_X = [];
resultTest_Y = [];

for i= 1: length(rho)
    disp(num2str(i) + "回目")
    [resultTrain_X(:,:,i), resultTrain_Y(:,:,i), resultTest_X(:,:,i), resultTest_Y(:,:,i)] = gramian_main_spectral_last(rho(1,i));
end