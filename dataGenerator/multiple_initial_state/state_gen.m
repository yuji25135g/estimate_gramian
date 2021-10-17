function x = state_gen(size_a, time, A, samplingWidth)

    %{
        �^����ꂽA�s��ɑ΂����ԋO����1�Ԃ��܂�
        size_a : A�s��̃T�C�Y
        time : ���U�ȓ_�����_����Ă��邩
    %}
    
    %�������
    %x0 = [1,1]';
    x0 = 2*rand(size_a, 1) -1;
    
    
    
    %����1����time�܂ł̎��Ԃ̔z��
    t= samplingWidth*(1:time);
    %��Ԃ̏�����
    x = zeros(size_a,length(t));

    for ti = 1:length(t)
        x(:,ti) = expm(A*t(ti))*x0;
    end
end
