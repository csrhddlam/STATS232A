function y = myfun(parameters,x)
shape=parameters(1);
variance=parameters(2);
% Generalized Gaussian
gamma_1_shape = gamma(1/shape);
gamma_3_shape = gamma(3/shape);
alpha_shape = sqrt(gamma_3_shape/gamma_1_shape);
left = (shape*alpha_shape)/(2*variance*gamma_1_shape);
right = exp(-((alpha_shape*abs(x/variance)).^shape));
y = left * right;
end