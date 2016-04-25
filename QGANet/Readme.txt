QGANet

main function: QGAPCANet_cell

The main produrce is below:

Part1 Training the filter

Step1: Convert the RGB images to quaternion images; (more detail in fold-quaternion_pca);

Step2: Collect the training patches ;

Step3: Calculate the filter by grassmann_averages;(more detail in fold-grassmann_averages-0.1).

Part 2 Calculate the feature 

Step1: convolve the quaternion image using the filter above; 

Step2: Binary and Hashing, extract the feature of local gray-level histogram.

Part 3 SPM and SVM(libsvm-3.18).

//2015/11/17
GingerNg
jinjie603809@163.com
