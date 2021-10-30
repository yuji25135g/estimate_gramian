function error=relative_error(est, true)
    %est：推定値
    %true：真値
    error = (est-true)/true;
end