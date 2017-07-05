# adamap v1.0
Mapping ADA Voting Scores 1947-2015. The Shiny app is hosted at https://gokhan.shinyapps.io/adamap/

# Description
* Utilizes about 36,000 US legislator voting scores originally collected by [the Americans for Democratic Action organization (ADA)](adaction.org)
* Actual data compiled by Justin Briggs [Blog post](http://trialstravails.blogspot.co.uk/2017/01/adjusted-ada-scores-from-1947-2015.html) | [.xlsx file](http://bit.ly/2j1TXfE)
* Uses both nominal and adjusted ADA scores [Procedure](http://timgroseclose.com/adjusted-interest-group-scores/)
* Data can be grouped by year, state, chamber, and party
* Data visualization based on ```highcharter``` and ```ggpubr``` packages

# Current Capabilities

* Charts a single year/chamber/party combination on a US Admin 1 (state-level) map displaying either nominal or adjusted ADA voting score (state average)
* Plots change from previous year (state-level)
* Provides national averages for selected chamber/party combination 
* Shows then-president's name (reminder)
* Displays then-president's portrait (fancy reminder?)
* Offers animated slider capability; however this requires fast internet connection (current display time: 5000 ms)

# Planned Improvements
## Substance
* Add a coupled hover event in Shiny to link the map and the deviation plot (currently separate)
* Instead of omitting the ```NAs``` that represent states that has no legislator from the selected chamber/party combination, include them as a category so upon hovering they display a text (e.g. 'No Legislator', currently not selectable)
* Have more hover data (e.g. number of legislators, min/max voting scores, change from previous year, comparison to national average)
* Bulding on the above, either have multiple maps on display at the same time (1 x 1, party subset; or 2 x 2, chamber/party crosstab) to get a snapshot of the year
* Give the user an option to arrange the panels: Change the size of the map, number of maps displayed etc. (especially useful when linked highlighting works)

## Style
* Disable the ```<a></a>``` tag on the sidebar for entries that are not meant to be clickable (e.g. the name of the president)
* Include a brief description section