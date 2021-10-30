function [state_x, reshape_y, index, A] = data_gen_lowTriangle(size_a, time, samplingWidth)

    %{
        A�s�񂪗^����ꂽ�Ƃ�
        ��ԋO���Fstate_x
        y*���x�N�g���ɕό`�Freshape_y
        ���䐫�O���~�A�����ő�ɂ���one-hot�x�N�g���Findex
        ��Ԃ�
    %}
   
    %A�s��̐���
    A = lowTriangularA_gen(size_a);
    
    %A�s�񂩂��Ԃ𐶐�
    x0 = [0.5,1]';
    state_x = state_gen(size_a, time, A, samplingWidth, x0); 
    %��Ԃ̕W����
    %state_x = normalize(state_x);
   
    
    %tr(G)���ő�ɂ���C���f�b�N�X��y*�𓱏o
    %y*�̐���
    y = y_star(size_a, A);
    %�s��y*���x�N�g���ɕό`
    reshape_y = y(1,1);
    for j=2: size_a
        for i=1: j
            reshape_y = cat(1,reshape_y, y(i,j));
        end
    end
    %y*�̑Ίp�ő�l�̃C���f�b�N�X�����߂�
    diag_y = diag(y);
    [~, k] = max(diag_y);
    index = zeros(size_a, 1);
    index(k,1) = 1;
end