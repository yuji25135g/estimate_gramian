%{
安定な対角A行列を返す
%}


function A = diagA_gen(size_a)
   v = rand(1,size_a)-1;
   A = diag(v);
end