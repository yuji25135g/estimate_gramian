function A = a_gen(size_a)
    A = 2*rand(size_a)-1;
    eig_a = eig(A);
    re_eig = real(eig_a);
    negative = re_eig < 0;
    neg_num = nnz(negative);
    while neg_num < size_a
         A = 2*rand(size_a)-1;
        eig_a = eig(A);
        re_eig = real(eig_a);
        negative = re_eig < 0;
        neg_num = nnz(negative);
    end
end