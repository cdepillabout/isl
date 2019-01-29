library(ISLR)
library(MASS)
library(class)

weekly_length <- length(Weekly[,1])

# logistic regression on all

glm.fits <- glm(Direction ~ Lag1 + Lag2 + Lag3 +Lag4 + Lag5 + Volume, data=Weekly, family=binomial)

glm.probs <- predict(glm.fits, type="response")

glm.pred <- rep("Down", length(Weekly[,1]))
glm.pred[glm.probs > .5] <- "Up"

glm_correct_percent <- mean(glm.pred == Weekly$Direction)

train <- Weekly$Year < 2009
test <- !train

# logistic regression on just Lag2

glm.fits.train <- glm(Direction ~ Lag2, data=Weekly, subset=train, family=binomial)
glm.probs.test <- predict(glm.fits.train, newdata=Weekly[test,], type="response")
glm.pred.test <- rep("Down", length(Weekly[test,1]))
glm.pred.test[glm.probs.test > .5] <- "Up"

glm_correct_percent_test <- mean(glm.pred.test == Weekly$Direction[test])

# linear discriminent analysis

lda.fit.train <- lda(Direction ~ Lag2, data=Weekly, subset=train)
lda.pred.test <- predict(lda.fit.train, newdata=Weekly[test,])
lda_correct_percent_test <- mean(lda.pred.test$class == Weekly$Direction[test])

# quadratic discriminent analysis

qda.fit.train <- qda(Direction ~ Lag2, data=Weekly, subset=train)
qda.pred.test <- predict(qda.fit.train, newdata=Weekly[test,])
qda_correct_percent_test <- mean(qda.pred.test$class == Weekly$Direction[test])

# K-Nearest Neighbors

set.seed(1)
knn.pred_1 = knn(data.frame(Weekly$Lag2[train]), data.frame(Weekly$Lag2[test]), Weekly$Direction[train], k=1)
knn_1_correct_percent = mean(knn.pred_1 == Weekly$Direction[test])

set.seed(1)
knn.pred_5 = knn(data.frame(Weekly$Lag2[train]), data.frame(Weekly$Lag2[test]), Weekly$Direction[train], k=5)
knn_5_correct_percent = mean(knn.pred_5 == Weekly$Direction[test])

set.seed(1)
knn.pred_10 = knn(data.frame(Weekly$Lag2[train]), data.frame(Weekly$Lag2[test]), Weekly$Direction[train], k=10)
knn_10_correct_percent = mean(knn.pred_10 == Weekly$Direction[test])