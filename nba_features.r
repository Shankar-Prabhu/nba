# write functions that take in a dataset and a row # and output the feature value for that row
# e.g.  games_played_row would take in a dataset and a row# and output the feature value for home/away teams games played in a row

data = read.csv("C:/Users/shank/Documents/Data_Science_Projects/nba/nba.csv", header = TRUE, sep = ",")

#get rid of unused columns
data = data[,-(8:11)]


#format dates in to "yyyy-mm-dd" (for date-based functions)
formatted_dates = c()
for(i in 1 : nrow(data)) {
  date = data[i, 2]
  formatted_dates[i] = toString(as.Date(date, format = "%a, %b %d, %Y"))

}


#average points scored - points allowed over last 10 games for some team
avg_pts_diff_10 <- function(dataset, row_num, team_name) {
  
  #init variables
  pts_scored = 0
  pts_allowed = 0
  i = 0
  
  #we want to look backward to the previous row
  row_num = row_num - 1
  #if row_num originally equalled 1, then return 0
  if(row_num == 0) {
    return (0)
  }
  
  while(i <= 10) {
    #if team_name matches home team name
    if(team_name == dataset[row_num, 6]) {
      pts_scored = pts_scored + dataset[row_num, 7]
      pts_allowed = pts_allowed + dataset[row_num, 5]
      i = i + 1
    }
    #if team_name matches visitor team name
    else if (team_name == dataset[row_num, 4]) {
      pts_scored = pts_scored + dataset[row_num, 5]
      pts_allowed = pts_allowed + dataset[row_num, 7]
      i = i + 1
    }
    #move to previous row
    row_num = row_num - 1
    
    #if we have reached the end of the dataset,
    #return the value we have arrived so far
    if(row_num == 0 && i == 0) {
      return (0)
    }
    if(row_num == 0) {
      return ((pts_scored - pts_allowed)/i)
    }
    
  }
  # successfuly exited the while loop so divide by 10
  return ((pts_scored - pts_allowed)/10)
}

#win-loss percentage over last 10 games for some team
wl_perc_10 <- function(dataset, row_num, team_name) {
  #function won't handle ties since they are so rare in NBA
  
  #init variables
  num_wins = 0
  num_losses = 0

  i = 0
  
  #we want to look backward to the previous row
  row_num = row_num - 1
  #if row_num originally equalled 1, then return 0
  if(row_num == 0) {
    return (0)
  }
  
  while(i <= 10) {
    #if team_name matches home team name
    if(team_name == dataset[row_num, 6]) {
      #if home team won, increase wins, else increase losses
      if(dataset[row_num, 7] > dataset[row_num, 5]) {
        num_wins = num_wins + 1
      }
      else {
        num_losses = num_losses + 1
      }
      i = i + 1
    }
    #if team_name matches visitor team name
    else if (team_name == dataset[row_num, 4]) {
      #if home team won, increase losses, else increase wins
      if(dataset[row_num, 7] > dataset[row_num, 5]) {
        num_losses = num_losses + 1
      }
      else {
        num_wins = num_wins + 1
      }
      i = i + 1
    }
    #move to previous row
    row_num = row_num - 1
    
    #if we have reached the end of the dataset,
    #return the value we have arrived so far
    if(row_num == 0 && i == 0) {
      return (0)
    }
    
    if(row_num == 0) {
      return ((num_wins)/(num_wins + num_losses))
    }
    
  }
  # successfuly exited the while loop so divide by 10
  return (num_wins/10)
}

#visitor team win-loss percentage over last 10 games played as visitors
wl_perc_10_as_visitor <- function(dataset, row_num, team_name) {
  #function won't handle ties since they are so rare in NBA
  
  #init variables
  num_wins = 0
  num_losses = 0
  
  i = 0
  
  #we want to look backward to the previous row
  row_num = row_num - 1
  #if row_num originally equalled 1, then return 0
  if(row_num == 0) {
    return (0)
  }
  
  while(i <= 10) {
    #if team_name matches visitor team name
    if (team_name == dataset[row_num, 4]) {
      #if home team won, increase losses, else increase wins
      if(dataset[row_num, 7] > dataset[row_num, 5]) {
        num_losses = num_losses + 1
      }
      else {
        num_wins = num_wins + 1
      }
      i = i + 1
    }
    #move to previous row
    row_num = row_num - 1
    
    #if we have reached the end of the dataset,
    #return the value we have arrived so far
    if(row_num == 0 && i == 0) {
      return (0)
    }
    if(row_num == 0) {
      return ((num_wins)/(num_wins + num_losses))
    }
    
  }
  # successfuly exited the while loop so divide by 10
  return (num_wins/10)
}

#home team win-loss percentage over last 10 games played at home
wl_perc_10_as_home <- function(dataset, row_num, team_name) {
  #function won't handle ties since they are so rare in NBA
  
  #init variables
  num_wins = 0
  num_losses = 0
  
  i = 0
  
  #we want to look backward to the previous row
  row_num = row_num - 1
  #if row_num originally equalled 1, then return 0
  if(row_num == 0) {
    return (0)
  }
  
  while(i <= 10) {
    #if team_name matches home team name
    if(team_name == dataset[row_num, 6]) {
      #if home team won, increase wins, else increase losses
      if(dataset[row_num, 7] > dataset[row_num, 5]) {
        num_wins = num_wins + 1
      }
      else {
        num_losses = num_losses + 1
      }
      i = i + 1
    }
    
    #move to previous row
    row_num = row_num - 1
    
    #if we have reached the end of the dataset,
    #return the value we have arrived so far
    if(row_num == 0 && i == 0) {
      return (0)
    }
    if(row_num == 0) {
      return ((num_wins)/(num_wins + num_losses))
    }
    
  }
  # successfuly exited the while loop so divide by 10
  return (num_wins/10)
}

#one-hot, did the team play yesterday?
play_yesterday <- function(dataset, row_num, team_name) {
  game_date = dataset[row_num, 2]
  game_date_formatted = as.Date(game_date, format = "%a, %b %d, %Y")
  
  #get last yesterday formatted
  yesterday = toString(game_date_formatted - 1)
  
  #get row nums of games played yesterday
  games_yesterday = which(formatted_dates == yesterday)
  
  count = 0

  #check all games played on the previous date and increase count if team played
  if(length(games_yesterday) != 0) {
    for(i in 1 : length(games_yesterday)) {
      if(dataset[games_yesterday[i], 4] == team_name || 
         dataset[games_yesterday[i], 6] == team_name) {
        count = 1
      }
    }
  }
  
  return (count)
}

#one-hot, did the teams play 3 games in last 4 days?
three_in_four <- function(dataset, row_num, team_name) {
  game_date = dataset[row_num, 2]
  game_date_formatted = as.Date(game_date, format = "%a, %b %d, %Y")
  
  #get last four days formatted
  prev_1 = toString(game_date_formatted - 1)
  prev_2 = toString(game_date_formatted - 2)
  prev_3 = toString(game_date_formatted - 3)
  prev_4 = toString(game_date_formatted - 4)
  
  #get row nums of games played on last 4 days
  games_prev_1 = which(formatted_dates == prev_1)
  games_prev_2 = which(formatted_dates == prev_2)
  games_prev_3 = which(formatted_dates == prev_3)
  games_prev_4 = which(formatted_dates == prev_4)
  
  count = 0
  
  #check all games played on the previous date and increase count if team played
  if(length(games_prev_1) != 0) {
    for(i in 1 : length(games_prev_1)) {
      if(dataset[games_prev_1[i], 4] == team_name || 
         dataset[games_prev_1[i], 6] == team_name) {
        count = count + 1
      }
    }
  }
  #check all games played 2 days ago
  if(length(games_prev_2) != 0) {
    for(i in 1 : length(games_prev_2)) {
      if(dataset[games_prev_2[i], 4] == team_name || 
         dataset[games_prev_2[i], 6] == team_name) {
        count = count + 1
      }
    }
  }
  #check all games played 3 days ago
  if(length(games_prev_3) != 0) {
    for(i in 1 : length(games_prev_3)) {
      if(dataset[games_prev_3[i], 4] == team_name || 
         dataset[games_prev_3[i], 6] == team_name) {
        count = count + 1
      }
    }
  }
  #check all games played 4 days ago
  if(length(games_prev_4) != 0) {
    for(i in 1 : length(games_prev_4)) {
      if(dataset[games_prev_4[i], 4] == team_name || 
         dataset[games_prev_4[i], 6] == team_name) {
        count = count + 1
      }
    }
  }
    
  if(count >= 3) {
    return (1)
  }
  else {
    return (0)
  }

}

#one-hot, did the team play 2 games in last 3 days?
two_in_three <- function(dataset, row_num, team_name) {
  game_date = dataset[row_num, 2]
  game_date_formatted = as.Date(game_date, format = "%a, %b %d, %Y")
  
  #get last four days formatted
  prev_1 = toString(game_date_formatted - 1)
  prev_2 = toString(game_date_formatted - 2)
  prev_3 = toString(game_date_formatted - 3)
  
  #get row nums of games played on last 4 days
  games_prev_1 = which(formatted_dates == prev_1)
  games_prev_2 = which(formatted_dates == prev_2)
  games_prev_3 = which(formatted_dates == prev_3)
  
  count = 0
  

    
    #check all games played on the previous date and increase count if team played
  if(length(games_prev_1) != 0) {
    for(i in 1 : length(games_prev_1)) {
      if(dataset[games_prev_1[i], 4] == team_name || 
         dataset[games_prev_1[i], 6] == team_name) {
        count = count + 1
      }
    }
  }
    #check all games played 2 days ago
  if(length(games_prev_2) != 0) {
    for(i in 1 : length(games_prev_2)) {
      if(dataset[games_prev_2[i], 4] == team_name || 
         dataset[games_prev_2[i], 6] == team_name) {
        count = count + 1
      }
    }
  } 
    #check all games played 3 days ago
  if(length(games_prev_3) != 0) {
    for(i in 1 : length(games_prev_3)) {
      if(dataset[games_prev_3[i], 4] == team_name || 
         dataset[games_prev_3[i], 6] == team_name) {
        count = count + 1
      }
    }
  }
    
  if(count >= 2) {
    return (1)
  }
  else {
    return (0)
  }
  
}

#label  - 1 if home team won, 0 otherwise
result <- function(dataset, row_num) {
  #won't handle ties because they are so rare in the NBA
  if(dataset[row_num,7] > dataset[row_num,5]) {
    return (1)
  }
  else {
    return (0)
  }
}

#add features & label to the dataset
add_features <- function(dataset) {
  
  for(i in 1 : nrow(dataset)) {
    home_name = dataset[i, 6]
    visitor_name = dataset[i, 4]
    dataset$home_pt_diff[i] = avg_pts_diff_10(dataset, i, home_name)
    dataset$visit_pt_diff[i] = avg_pts_diff_10(dataset, i, visitor_name)
    dataset$home_wl_perc[i] = wl_perc_10(dataset, i, home_name)
    dataset$visit_wl_perc[i] = wl_perc_10(dataset, i, visitor_name)
    dataset$visit_wl_as_visitor[i] = wl_perc_10_as_visitor(dataset, i, visitor_name)
    dataset$home_wl_as_home[i] = wl_perc_10_as_home(dataset, i, home_name)
    dataset$home_play_yest[i] = play_yesterday(dataset, i, home_name)
    dataset$visit_play_yest[i] = play_yesterday(dataset, i, visitor_name)
    dataset$home_3_in_4[i] = three_in_four(dataset, i, home_name)
    dataset$visit_3_in_4[i] = three_in_four(dataset, i, visitor_name)
    dataset$home_2_in_3[i] = two_in_three(dataset, i, home_name)
    dataset$visit_2_in_3[i] = two_in_three(dataset, i, visitor_name)
    dataset$label[i] = result(dataset, i)
    
    if(i %% 100 == 0) {
      print(i)
    }
    
  }
  
  return (dataset)
  
}


data = add_features(data)
  
write.csv(data, "C:/Users/shank/Documents/Data_Science_Projects/nba/nba_w_features.csv", row.names = FALSE )


