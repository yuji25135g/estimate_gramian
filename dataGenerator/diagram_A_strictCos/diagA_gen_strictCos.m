%{
ˆÀ’è‚È‘ÎŠpAs—ñ‚ð•Ô‚·
‚©‚Â‰Šú’l(1,1)‚É‚¨‚¢‚Ä(-1,-1)‚Æ‚Ì“àÏ‚ª0.9995ˆÈ‰º‚Å‚ ‚é
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