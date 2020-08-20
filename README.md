# nba
 Predicting probability of a home team win in nba games

## Data Used
This data was scraped from http://basketball-reference.com/. This [tutorial](https://www.r-bloggers.com/scraping-nba-game-data-from-basketball-reference-com/) was helpful in getting started for learning how to scrape data. I used game-level data from the past 18 NBA regular seasons and playoffs, excluding the 2012 lockout season. The data scraped contained the date of the game played, the home team name, the visitor team name, # of points scored by the home team, and # of points scored by the visitor team. Basketball Reference is a pretty reputable site and there were no data quality issues when scraping.

## Additional Features
The end goal is to predict whether or not the home team will win - essentially, a classification problem. I set up my "label" to be 1 if the home team recorded a win, and 0 if not. After this I needed to create a few more features to add predictive power to the model.
**home_pt_diff**: Average Points Scored - Average Points Allowed over the last 10 games for the home team
**visit_pt_diff**: Average Points Scored - Average Points Allowed over the last 10 games for the visiting team
**home_wl_perc**: Win-Loss percentage over the last 10 games for the home team
**visit_wl_perc**: Win-Loss percentage over the last 10 games for the visiting team
**visit_wl_as_visitor**: Win-Loss percentage for the visiting team over the last 10 games that they played as the visitor (meant to capture whether the team is good/bad on the road)
**home_wl_as_visitor**: Win-Loss percentage for the home team over the last 10 games that they played as the home team (meant to capture whether the team is good/bad at home)
**home_play_yes/visit_play_yes**: 1 if the team played yesterday, 0 if not
**home_3_in_4/visit_3_in_4**: 1 if the team played 3 games in the past four days, 0 if not
**home_2_in_3/visit_2_in_3**: 1 if the team played 2 games in the past three days, 0 if not

The play_yes/3_in_4/2_in_3 features are meant to capture how tired the team will be when playing their current game.

## Process
After generating a dataset with features, I used an 80/20 train-test split for the data. I then implemented a logistic regression model to predict the probability that the home team would win. This model was selected because I hope to see if it can be used for sports betting in the future, but I have not reached that point yet.

## Logistic Regression
Used subset selection to understand that the model should only contain four features: home_pt_diff, visit_pt_diff, visit_wl_as_visitor, and home_wl_as_home.
The overall correct classification rate on the test data was **67.1%**. The confusion matrix is shown below:

|                       | Actual Visitor Win | Actual Home Win |
| --------------------- | ------------------ | --------------- |
| Predicted Visitor Win | 770                | 465             |
| Predicted Home Win    | 1075               | 2382            |

If the predicted probability was greater than 0.5, it was labeled as a "predicted home win". 

Overall, the classification accuracy is decent, compared to a baseline of 60% (if we just predicted the home team wins always). We can also see that the final accuracy is similar to numbers discuss in [this analysis] (https://homepages.cae.wisc.edu/~ece539/fall13/project/AmorimTorres_rpt.pdf).

## Problems/Next Steps
The key problems are involved in not having player-level data since the model only accounts for game-level data. For example, I did not pull data on who was injured, what trades had happened, who had been drafted, etc. The model tends to perform poorly at the beginning of the season or after the NBA trade deadline, since the past information used as prediction is no longer relevant.
The obvious next step is to try and predict point spread because that would be the other component of betting. This is a lot more high variance than the actual game outcome, and there are several methods that look interesting. Almost all involve significantly more detailed data such as [fivethirtyeight's](https://fivethirtyeight.com/methodology/how-our-nba-predictions-work/) CARMELO or RAPTOR systems. 
I think getting this data and building a more comprehensive model is a highly interesting project, and something that I will come back to in the future.


