
library(ISLR)
library(MASS)
library(boot)
library(class)

set.seed(2)

x = rnorm(100)
y = x - 2 * x ^ 2 + rnorm(100)

mydata = data.frame(x = x, y = y)

set.seed(4)

cv.error = rep(0,5)
glm.fit.summary = list()
for (i in 1:5) {
  glm.fit = glm(y ~ poly(x, i), data = mydata)
  glm.fit.summary[[i]] = summary(glm.fit)
  cv.error[i] = cv.glm(mydata, glm.fit)$delta[1]
}