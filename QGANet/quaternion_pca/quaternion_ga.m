%%quaternion ga
function SUBq = quaternion_ga(X,K)
Q = qua2com2(X);
SUBc = grassmann_average(Q, K);
SUBq = com2qua2(SUBc);