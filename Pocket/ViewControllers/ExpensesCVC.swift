import UIKit
import SQLite3

/*
    TODO:
    - For now reloads the expense view every time the tab is pressed except the first load
 */
class ExpensesCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId: String = "TableViewCellIdentifier"
    
    var pieView : PieChart?
    
    // As each view is added add on its height to the offset so next created view will always be below the previous view when using this offset
    var cumulativeYOffset = UIApplication.shared.statusBarFrame.height
    
    var refreshView = false // Used to prevent loading view again on first load
    var lastSelectedButton = Date.DateTimeInterval.Day
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: MyEnums.Colours.ORANGE_PUMPKIN.rawValue)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
//        self.navigationItem.title = MyEnums.TabNames.Expenses.rawValue
//        self.navigationController?.isNavigationBarHidden = true
        // If background color is not set application may lag between transitions
        self.collectionView.backgroundColor = UIColor(rgb: 0xe8e8e8)
        self.collectionView?.register(ExpensesCVCCell.self, forCellWithReuseIdentifier: cellId)
        
        cumulativeYOffset += self.navigationController!.navigationBar.frame.height
        
        let (d1, d2) = Date.getStartEndDates(timeInterval: lastSelectedButton)
        print(d1,d2)
        if GLOBAL_userDatabase?.loadCategoriesAndTotals(startingDate: d1, endingDate: d2) == true
        {
            pieView?.updateData(categories: GLOBAL_userDatabase!.categories, categoryTotal: GLOBAL_userDatabase!.categoryTotal)
        }
        setupPieView()
        setupDayMonthYearButtons()
        
        // Where frame holding cells begin
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: pieView!.frame.height, left: 0, bottom: 0, right: 0)
        self.collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //print (refreshView)
        if refreshView == true {
            let (d1, d2) = Date.getStartEndDates(timeInterval: lastSelectedButton)
            reloadData(startDate: d1, endDate: d2)
        } else {
            refreshView = true
        }
    }
    
    // Updates the view. start and end date should be in UTC
    func reloadData(startDate: String, endDate: String) {
        GLOBAL_userDatabase?.categories.removeAll()
        GLOBAL_userDatabase?.categoryTotal.removeAll()
        
        if GLOBAL_userDatabase?.loadCategoriesAndTotals(startingDate: startDate, endingDate: endDate) == true
        {
            print ("Expense view refreshed")
            pieView?.updateData(categories: GLOBAL_userDatabase!.categories, categoryTotal: GLOBAL_userDatabase!.categoryTotal)
            pieView?.setNeedsDisplay()
            self.collectionView.reloadData() // reloads cells
        }
    }
    
    /// If possible instead directly call database function
    @objc func dataFilterButtonPressed(sender: UIButton) {
        var (d1, d2): (String?, String?)

        switch sender.tag {
        case 0:
            (d1, d2) = Date.getStartEndDates(timeInterval: .Day)
            lastSelectedButton = .Day
        case 1:
            (d1, d2) = Date.getStartEndDates(timeInterval: .Week)
            lastSelectedButton = .Week
        case 2:
            (d1, d2) = Date.getStartEndDates(timeInterval: .Month)
            lastSelectedButton = .Month
        case 3:
            (d1, d2) = Date.getStartEndDates(timeInterval: .Year)
            lastSelectedButton = .Year
        default:
            print ("Time filter out of bounds")
        }
        // Only set if colour is already not set
        if sender.titleColor(for: .normal) != UIColor(rgb: MyEnums.Colours.ORANGE_PUMPKIN.rawValue) {
            sender.backgroundColor = UIColor.white
            sender.setTitleColor(UIColor(rgb: MyEnums.Colours.ORANGE_PUMPKIN.rawValue), for: .normal)
        }
        
print (d1!,d2!)
        reloadData(startDate: d1!, endDate: d2!)
    }
    
    
    /// Set up Day, Month, Year button
    func setupDayMonthYearButtons() {
        
        // Button size
        let buttonHeight = 30
        let buttonWidth = 70
        let borderLineWidth = CGFloat(4)
        
        // Colours
        let buttonBackGroundColour = UIColor(rgb: MyEnums.Colours.ORANGE_PUMPKIN.rawValue)
        let buttonBorderColour = UIColor(rgb: MyEnums.Colours.ORANGE_MANDARIN.rawValue).cgColor
        // Offsets
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
    
    
    /// Setup pie chart view
    func setupPieView() {
       pieView = PieChart(
           frame: CGRect(x: 0, y: cumulativeYOffset,
                         width: self.view.frame.width, height: self.view.frame.height * 0.35),
           categories: (GLOBAL_userDatabase?.categories)!,
           categoryTotal: (GLOBAL_userDatabase?.categoryTotal)!)
       pieView!.backgroundColor = UIColor.white
       cumulativeYOffset += pieView!.frame.height
       self.view.addSubview(pieView!)
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
