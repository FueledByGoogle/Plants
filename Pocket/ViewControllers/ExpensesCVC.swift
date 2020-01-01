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
        
        if initialLoad == true { initialLoad = false }
        
        cumulativeYOffset += self.navigationController!.navigationBar.frame.height
        
        setupPieView()
//        setupDayMonthYearButton()
        
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
    
    /// Set up Day, Month, Year button
    func setupDayMonthYearButton() {
        let dayButton = UIButton(frame: CGRect(x: 0, y: cumulativeYOffset, width: 50, height: 30))
//        dayButton.titleLabel!.font = UIFont.systemFont(ofSize: 16)
        dayButton.backgroundColor = .green
        dayButton.setTitle("Day", for: .normal)
        dayButton.titleLabel!.numberOfLines = 0;
        dayButton.titleLabel!.adjustsFontSizeToFitWidth = true
        dayButton.roundButtonLeftBorders()
        
         let monthButton = UIButton(frame: CGRect(x: 0, y: cumulativeYOffset, width: 50, height: 30))
//        dayButton.titleLabel!.font = UIFont.systemFont(ofSize: 16)
        monthButton.backgroundColor = .green
        monthButton.setTitle("Month", for: .normal)
        monthButton.titleLabel!.numberOfLines = 0;
        monthButton.titleLabel!.adjustsFontSizeToFitWidth = true
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: dayButton)
        
        cumulativeYOffset += 30
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if initialLoad == false {
            GLOBAL_userDatabase?.categories.removeAll()
            GLOBAL_userDatabase?.categoryTotal.removeAll()
            
            if GLOBAL_userDatabase?.loadCategoriesAndTotals() == true
            {
                pieView?.updateData(categories: GLOBAL_userDatabase!.categories, categoryTotal: GLOBAL_userDatabase!.categoryTotal)
                pieView?.setNeedsDisplay()
                self.collectionView.reloadData() // reloads cells
            }
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
