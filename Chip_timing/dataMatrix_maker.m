function chip_times = dataMatrix_maker(matrix,size)
% dataMatrix_maker creates a 3d matrix of the appropriate size given the
% chip and the amount of data to collect
chip_times = matrix;
for k = 1:size - 1
    chip_times = cat(3,chip_times,matrix);
end
end

