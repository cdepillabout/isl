library(ISLR)
library(MASS)
library(class)

set.seed(5)

fit <- glm(default ~ income + balance, data = Default, family = binomial)

probs <- predict(fit, type="response")

pred <- rep("No", length(Default[,1]))
pred[probs > .5] <- "Yes"

glm_correct_percent <- mean(pred == Default$default)


