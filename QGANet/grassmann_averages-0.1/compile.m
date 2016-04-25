try
  cd private
  mex -largeArrayDims mymedian.cc
  mex -largeArrayDims trimmed_mean.cc
  mex -O -largeArrayDims -lmwlapack -lmwblas reorth.c
  cd ..
catch
  warning('Compilation failed! This will either result in poor performance or a failure to run the code at all!');
  cd ..
end % try catch
