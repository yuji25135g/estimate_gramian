i = 1;
A = unclassified(:,:,i);
x0 = [1,1]';
samplingWidth = 0.01;
time = 1000;

%����1����time�܂ł̎��Ԃ̔z��
t= samplingWidth*(1:time);
%��Ԃ̏�����
x = zeros(size_a,length(t));

for ti = 1:length(t)
    x(:,ti) = expm(A*t(ti))*x0;
end

figure()
plot(x')