i = 34;
A = classified(:,:,i);
A = [-0.1551,0.4916;0,-0.6991];
x0 = [1,1]';
samplingWidth = 0.01;
time = 1000;

%1‚©‚çtime‚Ü‚Å‚ÌŠÔ‚Ì”z—ñ
t= samplingWidth*(1:time);
%ó‘Ô‚Ì‰Šú‰»
x = zeros(size_a,length(t));

for ti = 1:length(t)
    x(:,ti) = expm(A*t(ti))*x0;
end

plot_x = x(1,:);
plot_y = x(2,:);
x1 = expm(A*0.1)*x0;
x20 = expm(A*2.0)*x0;
figure()
hold on
plot(plot_x, plot_y)
plot(x1(1,1), x1(2,1), 'o', x20(1,1), x20(2,1), 'o')
hold off