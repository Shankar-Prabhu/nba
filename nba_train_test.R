full_set = read.csv("C:/Users/shank/Documents/Data_Science_Projects/nba/nba_w_features.csv", header = TRUE, sep = ",")

set.seed(1234)

train_rows = sample(nrow(full_set), floor(0.8 * nrow(full_set)))

train_set = full_set[train_rows,]
test_set = full_set[-train_rows,]

write.csv(train_set, "C:/Users/shank/Documents/Data_Science_Projects/nba/nba_train.csv", row.names = FALSE )
write.csv(test_set, "C:/Users/shank/Documents/Data_Science_Projects/nba/nba_test.csv", row.names = FALSE )


full_set = full_set[,-20]

for(i in 1 : nrow(full_set)) {
  full_set$label[i] = full_set[i, 7] - full_set[i, 5]
}

train_set_diff = full_set[train_rows,]
test_set_diff = full_set[-train_rows,]

write.csv(train_set_diff, "C:/Users/shank/Documents/Data_Science_Projects/nba/nba_train_diff.csv", row.names = FALSE )
write.csv(test_set_diff, "C:/Users/shank/Documents/Data_Science_Projects/nba/nba_test_diff.csv", row.names = FALSE )

