import Foundation


class MyEnums {
    
    enum TabNames: String {
        case AddExpense = "Add Expense"
        case Calendar, Charts
    }
    
    enum Colours: Int, CaseIterable {
        case POCKET_BLUE = 0x8b96b2
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


class CategoryEnum {
    
    enum Categories: String, CaseIterable {
        case Clothing, Electronics, Entertainment, Food, Furniture, Groceries, Sports, Transportation
    }
    
    // colours used for each category in pie chart
    enum Colours: Int, CaseIterable {
        case CLOTHING = 0xafe256 // light
        case ELECTRONICS = 0x56aee2 // dark
        case ENTERTAINMENT = 0x4ac778 // darkest
        case FOOD = 0x56e2cf  // light
        case FURNITURE = 0xcf56e2 // dark
        case GROCERIES = 0x5668e2 // darkest
        case SPORTS = 0x8a56e2 // light
        case TRANSPORTATION = 0xe28956 // dark
        case PINK = 0xe256af // darkest
        case ORANGE1 = 0xe25668 // light
        case YELLOW = 0xe2cf56 // darkest
        case GREEN2 = 0x69e256 // dark
    }
}
