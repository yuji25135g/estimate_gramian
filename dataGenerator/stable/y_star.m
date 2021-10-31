function y_star = y_star(size_a, A)
    %A = a_gen(size_a)
    %sys = ss(A.', eye(size_a), eye(size_a), 0);
    %y_star = gram(sys, 'c')
    y_star = lyap(A', eye(size_a));
end