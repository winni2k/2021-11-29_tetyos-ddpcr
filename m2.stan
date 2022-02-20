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
  int<lower=0> n_wt;
  int<lower=0> n_mut;
  int<lower=1> kappa; // n cells
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real<lower=0> extraction_efficiency;
  real<lower=0, upper=1> mu;
  real<lower=0, upper=1> prop_cell_mut;
}

transformed parameters {
  real<lower=0> lambda_wt = extraction_efficiency * (2*(1-prop_cell_mut) + prop_cell_mut);
  real<lower=0> lambda_mut = extraction_efficiency * prop_cell_mut;
}

model {
  mu ~ beta(1,1);
  extraction_efficiency ~ exponential(1);
  prop_cell_mut ~ beta_proportion(mu, kappa);

  // All wt observations are censored Poisson counts
  target += (N - n_wt) * poisson_lpmf(0 | lambda_wt);
  // poisson_lccdf does _not_ include 0
  target += n_wt * poisson_lccdf(0 | lambda_wt);
  target += (N - n_mut) * poisson_lpmf(0 | lambda_mut);
  target += n_mut * poisson_lccdf(0 | lambda_mut);
}

generated quantities {
  real log_R = log(lambda_mut) - log(lambda_wt);
}
