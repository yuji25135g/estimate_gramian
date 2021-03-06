%{
安定な対角A行列を返す
かつ初期値(1,1)において(-1,-1)との内積が0.9995以下である
%}


function A = diagA_gen_strictCos(size_a)
   v = rand(1,size_a)-1;
   norm_v = norm(v');
   a = v'/norm_v;
   b = [-1;-1]/norm([-1;-1]);
   cos = dot(a,b);
   while cos > 0.9995
       v = rand(1,size_a)-1;
       norm_v = norm(v');
       a = v'/norm_v;
       cos = dot(a,b);
   end
   A = diag(v);
end