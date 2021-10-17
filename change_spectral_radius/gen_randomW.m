function randomW = gen_randomW(N_x, density, w)
    m = round(N_x * (N_x-1) * density/2);  %•Ó‚Ì”
    for c = 1: m
        i = randi(N_x);
        j = randi(N_x);
        while w(i, j) ~= 0 | i == j
            i = randi(N_x);
            j = randi(N_x);
        end
        w(i, j) = 2*rand -1;  
    end
    randomW = w;
end