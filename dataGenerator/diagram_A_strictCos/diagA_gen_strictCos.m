%{
����ȑΊpA�s���Ԃ�
�������l(1,1)�ɂ�����(-1,-1)�Ƃ̓��ς�0.9995�ȉ��ł���
%}


function A = diagA_gen_strictCos(size_a)
   v = rand(1,size_a)-1;
   norm_v = norm(v');
   a = v'/norm_v;
   b = [1;1]/norm([1;1]);
   cos = dot(a,b);
   while cos > 0.9995
       v = rand(1,size_a)-1;
       norm_v = norm(v');
       a = v'/norm_v;
       b = [1;1]/norm([1;1]);
       cos = dot(a,b);
   endwhile
   A = diag(v);
end