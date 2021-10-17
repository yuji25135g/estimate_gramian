function [Y, X] = RC(inputWeight, reservoirWeight, outputWeight, U, N_u, N_x, N_y, T, x_0)
    %‚ÌŠÖŒW‚ª‚í‚©‚è‚â‚·‚¢‚æ‚¤‚ÉAXYU‚ÍT+1s‚É“ˆê
    X = [x_0, zeros(N_x, T)];
    Y = zeros(N_y, T+1);
    U = [zeros(N_u, 1) U];
    for n = 1: T
        reservoirInput = Input(inputWeight, U(:, n+1));


        X(:, n+1) = Reserver(reservoirWeight, reservoirInput, X(:, n));


        Y(:, n+1) = Output(outputWeight, X(:, n+1));

    end
    X(:, 1) = [];
    Y(:, 1) = [];
end