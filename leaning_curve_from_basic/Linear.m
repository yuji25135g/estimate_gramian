function w_upd = Linear(x_all, d, b, N_x)
    %{
    xt = pinv(x_all);  %ã^éóãtçsóÒ
    w_upd = d * xt;
    %}
    w_upd = (d * x_all.') * inv(x_all * x_all.' + b * eye(N_x));
end