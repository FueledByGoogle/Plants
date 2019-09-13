import UIKit


class GraphLegend: UIView {
    
    var categories = [String]()
    
    init(frame: CGRect, categories: inout [String]) {
        super.init(frame: frame)
        self.categories = categories
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
