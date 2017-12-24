# adavis
A visual exploration of the Americans for Democratic Action (ADA) Voting Scores. The Shiny app is hosted at https://gokhan.shinyapps.io/adavis/

## Description
* Utilizes about 36,000 US legislator voting scores originally collected by [the Americans for Democratic Action (ADA)](http://www.adaction.org/) foundation between 1948 and 2015
* "[Annual voting records] served as the standard measure of political liberalism. Combining 20 key votes on a wide range of social and economic issues, both domestic and international, the Liberal Quotient (LQ) provides a basic overall picture of an elected official's political position"
* Actual data compiled by Justin Briggs [Blog post](http://trialstravails.blogspot.co.uk/2017/01/adjusted-ada-scores-from-1947-2015.html) | [.xlsx file](http://bit.ly/2j1TXfE)
* Uses both nominal and adjusted ADA scores [Procedure](http://timgroseclose.com/adjusted-interest-group-scores/)
* Data can be grouped by year, state, chamber, and party
* Data visualizations using ```statebins, plotly, ggExtra``` and base R

## Features

### State of the Union
* Charts a single Year > Chamber > Party combination on a first-level political (administrative) division map displaying either nominal or adjusted LQ score (averaged by state).

![](/img/statebins.png)

### Change from Last Year
* Plots LQ score change from previous year (state-level). Hover info offers the precise amount in percentages.

![](/img/plotly.png)

### Head-to-Head
* Allows the user to select two states and compare their voting scores in a specified timeframe. Works under the C/P constraint; i.e. it compares representatives from the same party/chamber.

![](/img/marginal.png)

### Representatives
* Enables looking up specific representatives (3,371 in total) found in the dataset; offers descriptives on Year, Congress, District and plots their LQ scores, mean, and plus/minus one standard deviation.

![](/img/pelosi.png)

### Design
* Users can change viridis colour palettes (viridis, plasma, inferno, and magma) and direction (higher values light or dark)

![](/img/plasma.png)

# Legacy App
* The code for the legacy app (adamap) has been moved to the legacy folder. The Shiny app is still hosted at https://gokhan.shinyapps.io/adamap/
