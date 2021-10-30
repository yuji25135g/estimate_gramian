%{
à¿íËÇ»ëŒäpAçsóÒÇï‘Ç∑
%}


function A = lowTriangularA_strictCos(size_a)
   v = rand(1,size_a)-1;
    diagA = diag(v);
    A = 2*rand(size_a)-1;
    A = triu(A,1);
    A = diagA + A';
    x0 = [1,1]';
    x1 = expm(A*0.1)*x0;
    x20 = expm(A*2.0)*x0;
    cos = dot(x1/norm(x1), x20/norm(x20));
    while cos<0.9 || cos>0.95
        v = rand(1,size_a)-1;
        diagA = diag(v);
        A = 2*rand(size_a)-1;
        A = triu(A,1);
        A = diagA + A';
        x1 = expm(A*0.1)*x0;
        x20 = expm(A*2.0)*x0;
        cos = dot(x1/norm(x1), x20/norm(x20));
    end
end