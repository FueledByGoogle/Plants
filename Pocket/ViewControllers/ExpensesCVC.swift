import UIKit
import SQLite3


/**
    TODO:
    - Convert timezone read from database to user's time
    - Prevent loading if global user databse is not initialize correctly
 */


class ExpensesCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId: String = "TableViewCellIdentifier"
    
    var pieView : PieChart?
    
    // As each view is added add on its height to the offset so next created view will always be below the previous view when using this offset
    var cumulativeYOffset = UIApplication.shared.statusBarFrame.height
    var initialLoad = true // Used to prevent reading database twice on initial load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // If background color is not set application may lag between transitions
//        self.navigationItem.title = MyEnums.TabNames.Expenses.rawValue
//        self.navigationController?.isNavigationBarHidden = true
        self.collectionView.backgroundColor = UIColor(rgb: 0xe8e8e8)
        self.collectionView?.register(ExpensesCVCCell.self, forCellWithReuseIdentifier: cellId)
        
        cumulativeYOffset += self.navigationController!.navigationBar.frame.height
        
        var (d1, d2) = Date.getStartEndDates(timeInterval: .Day)
        (d1, d2) = Date.getStartEndDates(timeInterval: .Week)
        (d1, d2) = Date.getStartEndDates(timeInterval: .Month)
        (d1, d2) = Date.getStartEndDates(timeInterval: .Year)
        
        if GLOBAL_userDatabase?.loadCategoriesAndTotals(startingDate: d1, endingDate: d2) == true
        {
            pieView?.updateData(categories: GLOBAL_userDatabase!.categories, categoryTotal: GLOBAL_userDatabase!.categoryTotal)
        }
        setupPieView()
        setupDayMonthYearButton()
        
        // Where frame holding cells begin
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: pieView!.frame.height, left: 0, bottom: 0, right: 0)
        self.collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    /// Setup pie chart view
    func setupPieView() {
        pieView = PieChart(
            frame: CGRect(x: 0, y: cumulativeYOffset,
                          width: self.view.frame.width, height: self.view.frame.height * 0.40),
            categories: (GLOBAL_userDatabase?.categories)!,
            categoryTotal: (GLOBAL_userDatabase?.categoryTotal)!)
        pieView!.backgroundColor = UIColor.white
        cumulativeYOffset += pieView!.frame.height
        self.view.addSubview(pieView!)
    }
    
    /// if possible instead directly call database function
    @objc func dataFilterButtonPressed(sender: UIButton) {
        
        switch sender.tag {
        case 0:
            let (d1, d2) = Date.getStartEndDates(timeInterval: .Day)
            print (d1,d2)
        case 1:
            let (d1, d2) = Date.getStartEndDates(timeInterval: .Week)
            print (d1,d2)
        case 2:
            let (d1, d2) = Date.getStartEndDates(timeInterval: .Month)
            print (d1,d2)
        case 3:
            let (d1, d2) = Date.getStartEndDates(timeInterval: .Year)
            print (d1,d2)
        default:
            print ("out of bounds")
        }
    }
    
    /// Set up Day, Month, Year button
    func setupDayMonthYearButton() {
        
        let buttonHeight = 30
        let buttonWidth = 70
        let borderLineWidth = CGFloat(4)
        
        let buttonBackGroundColour = UIColor(rgb: 0xb491c8)
        let buttonBorderColour = UIColor.purple.cgColor
        
        let buttonYOffset = Int(self.navigationController!.navigationBar.frame.size.height)/2 - buttonHeight/2
        var startingButtonXOffset = Int(self.navigationController!.navigationBar.frame.size.width)/2 - buttonWidth*2
        
        for i in 0...3 {
            let filterButton = UIButton(frame: CGRect(x: startingButtonXOffset, y: buttonYOffset, width: buttonWidth, height: buttonHeight))
            //        dayButton.titleLabel!.font = UIFont.systemFont(ofSize: 16)
            filterButton.backgroundColor = buttonBackGroundColour
            if i == 0 {
                filterButton.setTitle("Day", for: .normal)
                filterButton.tag = i
                filterButton.roundTwoCorners(borderColor: buttonBorderColour, lineWidth: borderLineWidth, cornerRadiiWidth: 8, cornerRadiiHeight: 8, corner1: .topLeft, corner2: .bottomLeft)
            }
            else if i == 1 {
                filterButton.setTitle("Week", for: .normal)
                filterButton.tag = i
                filterButton.addBorder(side: .Top, color: buttonBorderColour, width: borderLineWidth/2)
                filterButton.addBorder(side: .Bottom, color: buttonBorderColour, width: borderLineWidth/2)
                filterButton.addBorder(side: .Right, color: buttonBorderColour, width: borderLineWidth/2)
            }
            else if i == 2 {
                filterButton.setTitle("Month", for: .normal)
                filterButton.tag = i
                filterButton.addBorder(side: .Top, color: buttonBorderColour, width: borderLineWidth/2)
                filterButton.addBorder(side: .Bottom, color: buttonBorderColour, width: borderLineWidth/2)
            }
            else {
                filterButton.setTitle("Year", for: .normal)
                filterButton.tag = i
                filterButton.roundTwoCorners(borderColor: buttonBorderColour, lineWidth: borderLineWidth, cornerRadiiWidth: 8, cornerRadiiHeight: 8, corner1: .topRight, corner2: .bottomRight)
            }
            filterButton.titleLabel!.numberOfLines = 1
            filterButton.titleLabel!.adjustsFontSizeToFitWidth = true
            
            filterButton.titleLabel!.lineBreakMode = .byClipping //<-- MAGIC LINE
            filterButton.addTarget(self, action: #selector(self.dataFilterButtonPressed(sender:)), for: .touchUpInside)
            startingButtonXOffset += buttonWidth
            self.navigationController?.navigationBar.addSubview(filterButton)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if initialLoad == false {
            GLOBAL_userDatabase?.categories.removeAll()
            GLOBAL_userDatabase?.categoryTotal.removeAll()
            
            if GLOBAL_userDatabase?.loadCategoriesAndTotals(startingDate: "2020-01-01", endingDate: "2020-12-30") == true
            {
print ("not first load")
                pieView?.updateData(categories: GLOBAL_userDatabase!.categories, categoryTotal: GLOBAL_userDatabase!.categoryTotal)
                pieView?.setNeedsDisplay()
                self.collectionView.reloadData() // reloads cells
            }
        } else {
print ("initial load")
            initialLoad = false
        }
    }
    
    
    /// number of cells
    override func collectionView(_ collection: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (GLOBAL_userDatabase?.categories.count)!
    }
    
    
    /// what each cell is going to display
    override func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ExpensesCVCCell
        
        cell.indexPathNum = indexPath.row
        
        cell.label.text = GLOBAL_userDatabase?.categories[indexPath.row]
        cell.totalLabel.text = GLOBAL_userDatabase?.categoryTotal[indexPath.row].description
        cell.addViewsWithUpdatedProperties()

        return cell
    }
    
    /// what a specific cell's size should be
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 30)
    }

}
