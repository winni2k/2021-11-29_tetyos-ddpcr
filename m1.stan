//
// This Stan program defines a simple model, with a
// vector of values 'y' modeled as normally distributed
// with mean 'mu' and standard deviation 'sigma'.
//
// Learn more about model development with Stan at:
//
//    http://mc-stan.org/users/interfaces/rstan.html
//    https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
//

// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> N;
  array[N] int<lower=0, upper=1> drops_wt;
  array[N] int<lower=0, upper=1> drops_mut;
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real<lower=0> lambda_wt;
  real<lower=0> lambda_mut;
}

transformed parameters {
  
}
// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  lambda_wt ~ exponential(1);
  lambda_mut ~ exponential(1);
  for (n in 1:N) {
    drops_wt[n] ~ poisson(lambda_wt) T[, 1];
    drops_mut[n] ~ poisson(lambda_mut) T[, 1];
  }
}

generated quantities {
  real log_R = log(lambda_mut) - log(lambda_wt);
}
