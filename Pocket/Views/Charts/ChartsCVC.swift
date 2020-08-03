import UIKit



class ChartsCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId: String = "TableViewCellIdentifier"
    
    var filterButtons = [UIButton]()
    var pieView : PieChart?
    
    // As each view is added add on its height to the offset so next created view will always be below the previous view when using this offset
    
    var firstLoad = true // Used to prevent loading view again on first load
    var lastSelectedButton = Date.DateTimeInterval.Day
    
    // Button colours
    let buttonBorderColour = UIColor(rgb: MyEnums.Colours.ORANGE_PUMPKIN.rawValue).cgColor
    let buttonUnselectedColour = UIColor(rgb: MyEnums.Colours.ORANGE_MANDARIN.rawValue)
    let buttonSelectedColour = UIColor(rgb: MyEnums.Colours.ORANGE_PUMPKIN.rawValue)
    
    // Data
    var categories: [String] = []
    var categoryTotal: [CGFloat] = []
    
    let segmentedControl = UISegmentedControl(items: ["Day" , "Week", "Month", "Year"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.register(ChartsCVCCell.self, forCellWithReuseIdentifier: cellId)
        self.edgesForExtendedLayout = [] // So our content always appears below navigation bar
        
        setupPieView()
        setupDayFilterButtons()
        
        // Where frame holding cells begin
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: pieView!.frame.height, left: 0, bottom: 0, right: 0)
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        
        // Colors
        self.navigationController?.navigationBar.barTintColor = UIColor.systemGray6
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.label]
        self.view.backgroundColor = UIColor.systemGray6
        pieView?.backgroundColor = UIColor.clear
        self.collectionView.backgroundColor = UIColor.clear
    }

    
    override func viewDidAppear(_ animated: Bool) {
        if GLOBAL_userDatabase?.needToUpdateData[MyEnums.TabNames.Charts.rawValue] == true {
            let (d1, d2) = Date.calculateStartEndDatesAsString(referenceDate: Date(), timeInterval: lastSelectedButton)
            reloadData(startDate: d1, endDate: d2)
            GLOBAL_userDatabase?.needToUpdateData[MyEnums.TabNames.Charts.rawValue] = false
//            print (GLOBAL_userDatabase?.needToUpdateData[MyEnums.TabNames.Expenses.rawValue])
        }
    }
    
    
    func setupDayFilterButtons() {
        segmentedControl.center = (self.navigationController?.navigationBar.center)!
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(self.changeDayFilter(_:)), for: .valueChanged)
        segmentedControl.layer.cornerRadius = 5.0
        
        
        if #available(iOS 13.0, *) {
            segmentedControl.backgroundColor = UIColor.systemGray5
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.label], for: .normal)
//            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(rgb: MyEnums.Colours.POCKET_BLUE.rawValue)], for: .selected) // selected text color
        } else {
        }
        
        self.navigationController?.navigationBar.addSubview(segmentedControl)
    }
    
    
    /// Setup pie chart view
    func setupPieView() {
       pieView = PieChart(
           frame: CGRect(x: 0, y: 0,
                         width: self.view.frame.width, height: self.view.frame.height * 0.35),
           categories: categories,
           categoryTotal: categoryTotal)
       self.view.addSubview(pieView!)
    }
    
    
    // Updates the view. start and end date should be in UTC
    func reloadData(startDate: String, endDate: String) {
        categories.removeAll()
        categoryTotal.removeAll()
        print ("POCKETDEBUG [ChartsCVC] - \(#function) - View refreshed")
        (categories, categoryTotal) = (GLOBAL_userDatabase?.loadCategoriesAndTotals(startingDate: startDate, endingDate: endDate))!
        
        pieView?.updateData(categories: categories, categoryTotal: categoryTotal)
        pieView?.setNeedsDisplay() // marks this to be redrawn
        self.collectionView.reloadData() // reloads cells
    }
    
    
    @objc func changeDayFilter(_ sender: UISegmentedControl) {
        var (d1, d2): (String?, String?)
        
        switch sender.selectedSegmentIndex {
        case 0:
            (d1, d2) = Date.calculateStartEndDatesAsString(referenceDate: Date(), timeInterval: .Day)
        case 1:
            (d1, d2) = Date.calculateStartEndDatesAsString(referenceDate: Date(), timeInterval: .Week)
        case 2:
            (d1, d2) = Date.calculateStartEndDatesAsString(referenceDate: Date(), timeInterval: .Month)
        case 3:
            (d1, d2) = Date.calculateStartEndDatesAsString(referenceDate: Date(), timeInterval: .Year)
        default:
            print ("Time filter out of bounds")
        }
        print (d1!,d2!)
        reloadData(startDate: d1!, endDate: d2!)
    }
    
    
    
    /// number of cells
    override func collectionView(_ collection: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    /// what each cell is going to display
    override func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChartsCVCCell
        
        cell.indexPathNum = indexPath.row
        
        cell.label.text = categories[indexPath.row]
        cell.totalLabel.text = categoryTotal[indexPath.row].description
        cell.addViewsWithUpdatedProperties() // must be called after setting name and amount

        return cell
    }
    
    
    /// what a specific cell's size should be
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 30)
    }

}
