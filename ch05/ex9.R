library(ISLR)
library(MASS)
library(boot)
library(class)

set.seed(2)

length_boston = length(Boston[,1])

# mean

medv_mean_estimate = mean(Boston$medv)

medv_mean_std_err_estimate = sd(Boston$medv) / sqrt(length_boston)

boot.fn = function (data, index) {
  sd(data[index]) / sqrt(length(index))
}
medv_mean_std_err_estimate_boot = boot(Boston$medv, boot.fn, 1000)

# median

medv_median_estimate = median(Boston$medv)

boot.fn = function (data, index) {
  median(data[index])
}
medv_median_boot = boot(Boston$medv, boot.fn, 1000)