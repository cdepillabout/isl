
library(ISLR)
library(leaps)

###########################
## Best Subset Selection ##
###########################

# Remove missing observations.
Hitters = na.omit(Hitters)

# This only fits up to an 8-variable model.
#regfit.full = regsubsets(Salary ~ ., Hitters)

regfit.full = regsubsets(Salary ~ ., data = Hitters, nvmax = ncol(Hitters))

reg.summary = summary(regfit.full)

# par(mfrow=c(2,2))

# # plot RSS
# plot(reg.summary$rss, xlab="Number of Variables", ylab = "RSS", type="l")

# # plot adjusted R2
# plot(reg.summary$adjr2, xlab="Number of Variables", ylab = "Adjusted Rsq", type="l")
# max_adjr2 = which.max(reg.summary$adjr2)
# # This puts points on an already existing plot.
# points(max_adjr2, reg.summary$adjr2[max_adjr2], col="red", cex=2, pch=20)

# # plot cp
# plot(reg.summary$cp, xlab="Number of Variables", ylab = "Cp", type="l")
# min_cp = which.min(reg.summary$cp)
# points(min_cp, reg.summary$cp[min_cp], col="red", cex=2, pch=20)

# # plot bic
# plot(reg.summary$bic, xlab="Number of Variables", ylab = "BIC", type="l")
# min_bic = which.min(reg.summary$bic)
# points(min_bic, reg.summary$bic[min_bic], col="red", cex=2, pch=20)

# look at the coefficients for the best subset model with 6 variables:
best_subset_coef_six_var = coef(regfit.full, 6)

#############################################
## Forward and Backward Stepwise Selection ##
#############################################

regfit.fwd = regsubsets(Salary ~ ., data = Hitters, nvmax = ncol(Hitters), method = "forward")
reg.summary.fwd = summary(regfit.fwd)

regfit.bwd = regsubsets(Salary ~ ., data = Hitters, nvmax = ncol(Hitters), method = "backward")
reg.summary.bwd = summary(regfit.bwd)

###################################################################
## Choose Among Models Using Validation Set and Cross-Validation ##
###################################################################

set.seed(1)
train = sample(c(TRUE, FALSE), nrow(Hitters), rep = TRUE)
test = !train

hitters_cols = ncol(Hitters) - 1

# find the best subset model using only the training data
regfit.best = regsubsets(Salary ~ ., data = Hitters[train,], nvmax = hitters_cols)

# Create a matrix corresponding to the "X" data.  This is basically the same as
# the Hitters data-frame, but it drops the Salary column and adds the
# "(Intercept)" column.  This is for the test data.
test.mat = model.matrix(Salary ~ ., data = Hitters[test,])

val.errors = rep(NA, hitters_cols)
for (i in 1:hitters_cols) {

  coefi = coef(regfit.best, id = i)

  # %*% is matrix multiplication.  This adjusts the arguments so they can be
  # multiplied.  This gives us a size `nrows(Hitters[test,]) x 1` matrix with
  # the predictions for each test sample.
  pred = test.mat[,names(coefi)] %*% coefi

  # Compute the squared error for each prediction.
  sq_err = (Hitters$Salary[test] - pred) ^ 2

  # Store the mean squared error.
  val.errors[i] = mean(sq_err)
}
