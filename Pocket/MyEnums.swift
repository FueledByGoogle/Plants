import Foundation

class MyEnums {
    
    enum TabNames: String {
        case Add, Expenses, Search
    }
    
    /**
        Categories of expenses
     */
    enum Categories: String, CaseIterable {
        case Clothing, Electronics, Entertainment, Food, Furniture, Groceries, Sports, Transportation
    }
    
    // colours used for each category in pie chart
    enum Colours: Int, CaseIterable {
        case PINK = 0xFF2F92
        case LIGHT_BLUE = 0x76D6FF
        case PURPLE = 0x9437FF
        case LIGHT_YELLOW = 0xf0da81
    }

}
