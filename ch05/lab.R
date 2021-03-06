library(ISLR)
library(boot)
set.seed(1)

###
# Validation set approach
###

Auto_length = length(Auto[,1])

train = sample(Auto_length, Auto_length/2)
lm.fit = lm(mpg ~ horsepower, data=Auto, subset=train)
mpg_predictions = predict(lm.fit, Auto)
prediction_errors = Auto$mpg - mpg_predictions
squared_error = prediction_errors ^ 2
test_squared_error = squared_error[-train]
test_mean_squared_error = mean(test_squared_error)

###
# Leave-One-Out Cross-Validation
###

glm.fit = glm(mpg ~ horsepower, data = Auto)
cv.err = cv.glm(Auto, glm.fit)
cv.err$delta

cv.error = rep(0,5)
for (i in 1:5) {
  glm.fit = glm(mpg ~ poly(horsepower, i), data = Auto)
  cv.error[i] = cv.glm(Auto, glm.fit)$delta[1]
}

###
# k-Fold Cross-Validation
###

set.seed(17)

cv.error.10 = rep(0, 10)

for (i in 1:10) {
  glm.fit = glm(mpg ~ poly(horsepower, i), data=Auto)
  cv.error.10[i] = cv.glm(Auto, glm.fit, K=10)$delta[1]
}

###
# bootstrap to estimate the acuracy of a linear regression model
###

boot.fn = function (data, index) {
  return(coef(lm(mpg ~ horsepower, data = data, subset = index)))
}

# The following computes the the estimates of beta0 and beta1 on the
# entire data set of 392 observations using the normal linear
# regression coefficient estimate formulas.
#boot.fn(Auto, 1:392)

set.seed(1)
# This shows how we can randomly create an estimate based on randomly
# sampled data (with replacement).
#boot.fn(Auto, sample(392, 392, replace=T))

# Now we can use boot to actuall do the bootstrap.
bootres = boot(Auto, boot.fn, 1000)

# The bootstrap estimated std. errors are better than the standard
# errors suggested by summary() because the actual model is a
# quadratic model, and the summary() estimates underestimate the
# standard error
#summary(lm(mpg ~ horsepower, data=Auto))$coef

# This problem is better for summary() when we fix a quadratic model.
boot.fn2 = function(data, index) {
  coeff(lm(mpg ~ horsepower + I(horsepower^2), data=data, subset=index))
}

set.seed(1)

bootres2 = boot(Auto, boot.fn2, 1000)

#summary(lm(mpg ~ horsepower + I(horsepower^2), data=Auto))$coef
