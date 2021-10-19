dataset_labels = [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000];
train_error = zeros(1,length(dataset_labels));
test_error = zeros(1,length(dataset_labels));
for i=1: length(dataset_labels)
    dataset = "dataset"+num2str(40+i)+"_from_diag"
    disp(num2str(i)+"‰ñ–Ú")
    [train_error(1,i), test_error(1,i)] = gramian_main(dataset);
end
disp("plot")
figure()
plot(dataset_labels', train_error', 'o', dataset_labels', test_error', '+')