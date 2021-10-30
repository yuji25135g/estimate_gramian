%{
ˆÀ’è‚È‘ÎŠpAs—ñ‚ð•Ô‚·
%}


function A = upTriangularA_gen(size_a)
    v = rand(1,size_a)-1;
    diagA = diag(v);
    A = 2*rand(size_a)-1;
    A = triu(A,1);
    A = diagA + A;
    a=A*[1,1]'/norm(A*[1,1]');
    b = [-1;-1]/norm([-1;-1]);
    cos = dot(a,b);
     while cos > 0.9995
        v = rand(1,size_a)-1;
        diagA = diag(v);
        A = 2*rand(size_a)-1;
        A = triu(A,1);
        A = diagA + A;
        a=A*[1,1]'/norm(A*[1,1]');
        cos = dot(a,b);
     end
end


    