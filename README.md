# Pocket

An IOS app to track your daily expenses. All UI designed programmatically without storyboard or SwiftUI. **Currently prioritising a new photography app over Pocket, happy with what I've learned so far creating this app and will be using this as a basis for the new photography app. (With improvements of course)**

## Longterm Goals
- Exportable data.
- Exportable charts for easy viewing.
- Incorporate payment providers so all transactions are automatically entered for transactions.


## Todo (In order of priority)

- Check over completion handlers for database operations to prevent nil pointer crashes in case data is too slowly loaded.
- Choose custom date for pie view.
- Calendar date positioned depending on day of the week so the 1st day doesn't always start at the top left of the calendar view.
- Draw my own UI icons.


## Currently Completed
### Calendar View
  - Users filter expneses depending by date.
  - Easily delete entries by swiping left in the cell.
  - Edit an existing entry from calendar view.
### Expense Edit View
  - Textview automatically scrolls up if cursor is obscured by the keyboard (pain in the ass).
### Add Expense view
  - Enter a detailed description of an expense
### Chart View
  - Custom pie chart drawn from data that dynamically assigns a colour to a category, and displayed along with a chart legend.
  - Update pie chart view based on filter of current day, week, month, or year.
### General
  - Adaptive dark/light mode colour switching.

## Bugs

- Highlighted calendar cell text colour not reverting back correctly upon switching to another month while date picker tool is up.


<img src="/MarkdownImages/Calendar.png" width="300"/>
<img src="/MarkdownImages/CalendarEdit.png" width="300"/>
<img src="/MarkdownImages/AddExpenses.png" width="300"/>
<img src="/MarkdownImages/Expenses.png" width="300"/>
