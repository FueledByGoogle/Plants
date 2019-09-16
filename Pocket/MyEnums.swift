import Foundation

class MyEnums {
    
    enum TabNames: String {
        case Menu, Expenses, Search
    }
    
    enum Categories: String {
        case Transportation, Food, Entertainment
    }
    
    // colours used for each category in pie chart
    enum Colours: Int, CaseIterable {
        case c1 = 0xFF2F92
        case c2 = 0x76D6FF
        case c3 = 0x9437FF
        case c4 = 0
    }

}
