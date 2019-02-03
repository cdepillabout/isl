library(ISLR)
library(MASS)
library(boot)
library(class)

set.seed(1)

formula = default ~ income + balance

default_length = length(Default[,1])

######
## Normal Logistic Regression on the whole set
######

fit_everything <- glm(formula, data = Default, family = binomial)
glm_coef <- coef(fit_everything)

######
## Boot function for doing bootstrap
######

boot.fn = function (data, index) {
  return(coef(glm(formula, data = data, subset = index, family = binomial)))
}

glm_coef_boot = boot(Default, boot.fn, 1000)

