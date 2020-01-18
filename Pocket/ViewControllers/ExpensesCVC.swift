import UIKit
import SQLite3

/*
    TODO:
    - For now reloads the expense view every time the tab is pressed except the first load
 */
class ExpensesCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId: String = "TableViewCellIdentifier"
    
    var filterButtons = [UIButton]()
    var pieView : PieChart?
    
    // As each view is added add on its height to the offset so next created view will always be below the previous view when using this offset
    var cumulativeYOffset = UIApplication.shared.statusBarFrame.height
    
    var refreshView = false // Used to prevent loading view again on first load
    var lastSelectedButton = Date.DateTimeInterval.Day
    
    
    // Button colours
    let buttonBorderColour = UIColor(rgb: MyEnums.Colours.ORANGE_PUMPKIN.rawValue).cgColor
    let buttonUnselectedColour = UIColor(rgb: MyEnums.Colours.ORANGE_MANDARIN.rawValue)
    let buttonSelectedColour = UIColor(rgb: MyEnums.Colours.ORANGE_PUMPKIN.rawValue)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: MyEnums.Colours.ORANGE_Dark.rawValue)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
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
        setupDayFilterButtons()
        
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
            pieView?.setNeedsDisplay() // marks this to be redrawn
            self.collectionView.reloadData() // reloads cells
        }
    }
    
    
    func setupDayFilterButtons() {
        
        let filters = ["Day" , "Week", "Month", "Year"]
        let segmentedControl = UISegmentedControl(items: filters)
        segmentedControl.center = (self.navigationController?.navigationBar.center)!
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(self.changeDayFilter(_:)), for: .valueChanged)
        segmentedControl.layer.cornerRadius = 5.0
        
        segmentedControl.backgroundColor = UIColor(rgb: 0xFFA302)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(rgb: MyEnums.Colours.ORANGE_PUMPKIN.rawValue)], for: .selected)
        
        self.navigationController?.navigationBar.addSubview(segmentedControl)
    }
    
    
    @objc func changeDayFilter(_ sender: UISegmentedControl) {
        var (d1, d2): (String?, String?)
        
        switch sender.selectedSegmentIndex {
        case 0:
            (d1, d2) = Date.getStartEndDates(timeInterval: .Day)
        case 1:
            (d1, d2) = Date.getStartEndDates(timeInterval: .Week)
        case 2:
            (d1, d2) = Date.getStartEndDates(timeInterval: .Month)
        case 3:
            (d1, d2) = Date.getStartEndDates(timeInterval: .Year)
        default:
            print ("Time filter out of bounds")
        }
print (d1!,d2!)
        reloadData(startDate: d1!, endDate: d2!)
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
