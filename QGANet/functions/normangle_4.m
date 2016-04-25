% norm and angle
function [Norm,Angle1,Angle2] = normangle_4(I1,I2,I3,I4)

Norm = sqrt(power(I1,I1)+power(I2,I2)+power(I3,I3)+power(I4,I4));
Angle1 = angle(I1+I2*i);
Angle2 = angle(I3+I4*i);

end