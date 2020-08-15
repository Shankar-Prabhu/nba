train_set = read.csv("C:/Users/shank/Documents/Data_Science_Projects/nba/nba_train_diff.csv", header = TRUE, sep = ",")
test_set = read.csv("C:/Users/shank/Documents/Data_Science_Projects/nba/nba_test_diff.csv", header = TRUE, sep = ",")


linear_reg = lm(label ~ home_pt_diff + visit_pt_diff + home_wl_perc + visit_wl_perc 
                + visit_wl_as_visitor + home_wl_as_home +
                + home_play_yest + visit_play_yest + home_3_in_4 +
                  visit_3_in_4 + home_2_in_3 + visit_2_in_3, 
                data = train_set)

summary(linear_reg)

plot(linear_reg$residuals ~ linear_reg$fitted.values,
     main = "Residual Plot",
     xlab = "Fitted values", ylab = "Residuals")

mean(linear_reg$residuals)

train_lin_mse = mean(sqrt(linear_reg$residuals^2))
test_lin_mse = mean(sqrt((predict.lm(linear_reg, newdata = test_set)
                     - test_set$label)^2))

train_lin_mse
test_lin_mse

X_train = model.matrix(label ~ home_pt_diff + visit_pt_diff + home_wl_perc + visit_wl_perc 
                 + visit_wl_as_visitor + home_wl_as_home +
                   + home_play_yest + visit_play_yest + home_3_in_4 +
                   visit_3_in_4 + home_2_in_3 + visit_2_in_3, 
                 data = train_set)
X_test = model.matrix(label ~ home_pt_diff + visit_pt_diff + home_wl_perc + visit_wl_perc 
                      + visit_wl_as_visitor + home_wl_as_home +
                        + home_play_yest + visit_play_yest + home_3_in_4 +
                        visit_3_in_4 + home_2_in_3 + visit_2_in_3, 
                      data = test_set)
y_train = train_set$label
y_test = test_set$label

ridge.mod = glmnet(X_train, y_train, alpha=0)

plot(ridge.mod, xvar = "lambda", label = TRUE)

cv.out = cv.glmnet(X_train, y_train, alpha=0, nfolds = 10)
lambda = cv.out$lambda.min
ridge_train_err = mean((predict(ridge.mod, s = lambda, newx = X_train) - y_train)^2)
ridge_test_err = mean((predict(ridge.mod, s = lambda, newx = X_test) - y_test)^2)
lambda.grid = cv.out$lambda
mses = cv.out$cvm
ridge_cv_err = mses[which(lambda.grid == lambda)]

ridge_train_err
ridge_test_err
ridge_cv_err


train_ridge_preds = predict(ridge.mod, s = lambda, newx = X_train)
test_ridge_preds = predict(ridge.mod, s = lambda, newx = X_test)

model_metrics <- function(actual, preds, data) {
  SSE = sum((preds - actual)^2)
  SST = sum((actual - mean(actual))^2)
  R_sq = 1 - SSE/SST
  RMSE = sqrt(SSE/nrow(data))
  
  data.frame(RMSE = RMSE, R_squared = R_sq)
  
}

model_metrics(y_train, train_ridge_preds, train_set)
model_metrics(y_test, test_ridge_preds, test_set)

