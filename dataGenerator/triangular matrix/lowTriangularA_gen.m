%{
ˆÀ’è‚È‘ÎŠpAs—ñ‚ğ•Ô‚·
%}


function A = triangularA_gen(size_a)
   v = rand(1,size_a)-1;
   diagA = diag(v);
   A = 2*rand(size_a)-1;
   A = triu(A,1);
   A = diagA + A;
end