%{
安定な対角A行列を返す
%}


function A = lowTriangularA_positive(size_a)
   v = rand(1,size_a)-1;
    A = diag(v);
    A(2,1) = rand(1);
    a=A*[1,1]'/norm(A*[1,1]');
    b = [-1;-1]/norm([-1;-1]);
    cos = dot(a,b);
     while cos > 0.9995
        v = rand(1,size_a)-1;
        A = diag(v);
        A(2,1) = rand(1);
        a=A*[1,1]'/norm(A*[1,1]');
        cos = dot(a,b);
     end
end