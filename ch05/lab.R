library(ISLR)
library(boot)
set.seed(1)

# Validation set approach

Auto_length = length(Auto[,1])

train = sample(Auto_length, Auto_length/2)
lm.fit = lm(mpg ~ horsepower, data=Auto, subset=train)
mpg_predictions = predict(lm.fit, Auto)
prediction_errors = Auto$mpg - mpg_predictions
squared_error = prediction_errors ^ 2
test_squared_error = squared_error[-train]
test_mean_squared_error = mean(test_squared_error)

# Leave-One-Out Cross-Validation

glm.fit = glm(mpg ~ horsepower, data = Auto)
cv.err = cv.glm(Auto, glm.fit)
cv.err$delta

cv.error = rep(0,5)
for (i in 1:5) {
  glm.fit = glm(mpg ~ poly(horsepower, i), data = Auto)
  cv.error[i] = cv.glm(Auto, glm.fit)$delta[1]
}

# k-Fold Cross-Validation

set.seed(17)

cv.error.10 = rep(0, 10)

for (i in 1:10) {
  glm.fit = glm(mpg ~ poly(horsepower, i), data=Auto)
  cv.error.10[i] = cv.glm(Auto, glm.fit, K=10)$delta[1]
}


# bootstrap to estimate the acuracy of a linear regression model