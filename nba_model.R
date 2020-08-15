train_set = read.csv("C:/Users/shank/Documents/Data_Science_Projects/nba/nba_train.csv", header = TRUE, sep = ",")
test_set = read.csv("C:/Users/shank/Documents/Data_Science_Projects/nba/nba_test.csv", header = TRUE, sep = ",")


full_mod = glm(label ~ home_pt_diff + visit_pt_diff + visit_wl_as_visitor + home_wl_as_home
                     + home_wl_perc + visit_wl_perc + home_play_yest + visit_play_yest + 
                       home_2_in_3 + visit_2_in_3 + home_3_in_4 + visit_3_in_4, data = train_set, family = binomial)

summary(full_mod)


logistic_model = glm(label ~ home_pt_diff + visit_pt_diff + visit_wl_as_visitor + home_wl_as_home,
                     data = train_set, family = binomial)

summary(logistic_model)



train_pred = predict(logistic_model, train_set, type = "response")
test_pred = predict(logistic_model, test_set, type = "response")

mean(test_pred)
mean(train_set$label)

train_pred = ifelse(train_pred > 0.5, 1, 0)
test_pred = ifelse(test_pred > 0.5, 1, 0)

train_confusion_mat = table(train_pred, train_set$label)
test_confusion_mat = table(test_pred, test_set$label)


(test_confusion_mat[1, 1] + test_confusion_mat[2, 2])/(sum(test_confusion_mat))
(train_confusion_mat[1, 1] + train_confusion_mat[2, 2])/(sum(train_confusion_mat))

train_confusion_mat
test_confusion_mat

