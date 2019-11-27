# Pocket

An IOS app to track your daily expenses.


## Goals:

- [] Pie chart showing percentage current day/week/month expenses in different categories
- [] Manul entry and saving of data onto local database of user expenses
- [] Overview of expenditure based on user filter such as day/month/year
- [] Search expense on a specific date


## Current progress: 

- Going back to using sqlite3 and not using any swift-kuery package because it does not support the more efficient SELECT SUM query
- Custom pie chart drawn from data that dynamically assigns a colour to a category, and displayed along with a chart legend.
- Simple database that is searchable
