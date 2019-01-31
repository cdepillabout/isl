
# This is an example showing that if you pre-select predictors that show a good
# fit, and then try to run cross-validation on it (or even try to fit a model
# with it), it will fit perfectly, even though there is no relation between
# the predictors and the response.  This can happen when there are lots and lots
# of predictors and not that much training data.

library(boot)

set.seed(1)
rows <- 50
columns <- 5000
targetPs <- 100
as <- rnorm(rows * columns)
xs <- matrix(as, nrow = rows, byrow = TRUE)
#ys <- c(rep("YES", rows / 2), rep("NO", rows / 2))
ys <- sapply(rnorm(rows), function(x) { ifelse(x > 0, "YES", "NO") })
#summary(xs)
#data <- data.frame(xs, someval = ys)
#fits <- glm(someval ~ ., data=data, family=binomial)

computeMisclassified <- function (vals) {
  mydata_inner <- data.frame(myinnerys = ys, myxs = vals)
  fit_inner <- glm(myinnerys ~ myxs, data = mydata_inner, family=binomial)
  probs_inner <- predict(fit_inner, type="response")
  pred_inner <- rep("NO", length(ys))
  pred_inner[probs_inner > 0.5] <- "YES"
  glm_correct_percent_inner <- mean(pred_inner == ys)
  return(glm_correct_percent_inner)
}

columnsCorrectPercent <- apply(xs, 2, computeMisclassified)
biggestPsInXs <- tail(order(columnsCorrectPercent), n = targetPs)

newXs <- matrix(data = rep(0, rows * targetPs), nrow = rows, ncol = targetPs)
for (i in (1 : targetPs)) {
  xsColNum <- biggestPsInXs[i]
  xsCol <- xs[,xsColNum]
  newXs[,i] <- xsCol
}

newData <- data.frame(myys = ys, newXs)

fit <- glm(myys ~ ., data=newData, family=binomial)
probs <- predict(fit, type="response")
pred <- rep("NO", length(ys))
pred[probs > 0.5] <- "YES"
glm_correct_percent <- mean(pred == ys)

cv.err <- cv.glm(newData, fit)


# Calculate some bad data that has no prediction power.

#smallestPsInXs <- head(order(columnsCorrectPercent), n = targetPs)

#badXs <- matrix(data = rep(0, rows * targetPs), nrow = rows, ncol = targetPs)
#for (i in (1 : targetPs)) {
#  badXsColNum <- smallestPsInXs[i]
#  badXsCol <- xs[,badXsColNum]
#  badXs[,i] <- badXsCol
#}


newBadData <- data.frame(mybadys = ys, badXs[,1:targetPs])

badfit <- glm(mybadys ~ ., data=newBadData, family=binomial)
badprobs <- predict(badfit, type="response")
badpred <- rep("NO", length(ys))
badpred[badprobs > 0.5] <- "YES"
bad_glm_correct_percent <- mean(badpred == ys)

bad.cv.err <- cv.glm(newBadData, badfit)