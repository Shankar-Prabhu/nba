
library(rvest)
library(lubridate)
library(magrittr)

#2012 excluded due to NBA lockout complications
years = c("2001", "2002", "2003", "2004", "2005", "2006", "2007","2008", "2009", "2010", "2011",
          "2013", "2014", "2015", "2016", "2017", "2018", "2019")
months = c("october", "november", "december", "january", "february", "march", "april", "may", "june")

cum_game_id = c()
cum_dates = c()
cum_data = c()
length(years)
for(i in 1 : length(years)) {
  for(j in 1 : length(months)) {
    
    year = years[i]
    month = months[j]
    
    #years where season started in november (no october data)
    if((year == "2005" || year == "2006") && month == "october") {
      
    }
    #normal cases (we have october data)
    else {
      url = paste0("https://www.basketball-reference.com/leagues/NBA_", year, 
                   "_games-", month, ".html")
      webpage = read_html(url)
      
      game_id = webpage %>% 
        html_nodes("table#schedule > tbody > tr > th") %>%
        html_attr("csk")
      game_id = game_id[!is.na(game_id)]
      
      dates <- webpage %>% 
        html_nodes("table#schedule > tbody > tr > th") %>% 
        html_text()
      
      data = webpage %>% 
        html_nodes("table#schedule > tbody > tr > td") %>% 
        html_text() %>%
        matrix(ncol = length(col_names) - 2, byrow = TRUE)
      
      cum_game_id = append(cum_game_id, game_id)
      cum_dates = append(cum_dates, dates)
      cum_data = rbind(cum_data, data)

  }
  }
}


dataset = as.data.frame(cbind(cum_game_id, cum_dates, cum_data), stringsAsFactors = FALSE)

col_names = c("game_id", "date_game", "game_start_time", "visitor_team_name", "visitor_pts", "home_team_name", "home_pts",
              "box_score_text", "overtimes", "attendance", "game_remarks" )
names(dataset) = col_names

write.csv(dataset, "C:/Users/shank/Documents/Data_Science_Projects/nba/nba.csv", row.names = FALSE )

