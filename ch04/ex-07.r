f <- function(sigma, mu, x) {
  exp(-1 * (x - mu)^2 / (2 * sigma ^ 2) ) / (sqrt(2 * pi) * sigma)
}

pi_yes <- .8

pi_no <- .2

mu_yes <- 10

mu_no <- 0

sigma = 6

f_yes <- function (x) { f(sigma, mu_yes, x) }

f_no <- function (x) { f(sigma, mu_no, x) }

pi_f_yes <- function (x) { pi_yes * f_yes(x) }

pi_f_no <- function (x) { pi_no * f_no(x) }

p_yes <- function (x) { pi_f_yes(x) / (pi_f_yes(x) + pi_f_no(x)) }
