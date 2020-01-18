import Foundation


class MyEnums {
    
    enum TabNames: String {
        case AddExpense = "Add Expense"
        case Calendar, Expenses, Search
    }
    
    
    enum Categories: String, CaseIterable {
        case Clothing, Electronics, Entertainment, Food, Furniture, Groceries, Sports, Transportation
    }
    
    // colours used for each category in pie chart
    enum Colours: Int, CaseIterable {
        case BLUE_LIGHT = 0x76D6FF
        case BLUE_SKY = 0x4D8FAC
        case ORANGE = 0xf0932b
        case ORANGE_Dark = 0xEEA700
        case ORANGE_PUMPKIN = 0xE98604
        case ORANGE_MANDARIN = 0xEDA421
        case GREEN_EXTRA_DARK = 0x006442
        case RED_ORANGE = 0xDC3023
        case PINK = 0xFF2F92
        case PINK_GLAMOUR = 0xff7979
        case PURPLE = 0x9437FF
        case YELLOW_LIGHT = 0xf0da81
    }
}
