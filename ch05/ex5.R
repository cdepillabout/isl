library(ISLR)
library(MASS)
library(class)

set.seed(2)

formula = default ~ income + balance + student

default_length = length(Default[,1])

######
## Normal Logistic Regression on the whole set
######

fit_everything <- glm(formula, data = Default, family = binomial)

probs_everything <- predict(fit_everything, type="response")

pred_everything <- rep("No", length(Default[,1]))
pred_everything[probs_everything > .5] <- "Yes"

glm_correct_percent_everything <- mean(pred_everything == Default$default)

######
## Normal Logistic Regression on just train set
######

train_set_indicies = sample(default_length, default_length/2)

default_train_length = length(train_set_indicies)
default_test_length = default_length - default_train_length

fit_train_set <-
  glm(formula, data = Default, family = binomial, subset = train_set_indicies)
probs_test_set <-
  predict(fit_train_set, newdata = Default[-train_set_indicies,],
          type="response")

pred_test_set <- rep("No", default_test_length)
pred_test_set[probs_test_set > .5] <- "Yes"

glm_correct_percent_test_set <- mean(pred_test_set == Default$default[-train_set_indicies])

glm_correct_percent_everything
glm_correct_percent_test_set
