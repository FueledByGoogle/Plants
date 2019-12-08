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
    
    var initialLoad = true // used to prevent reading database twice on initial load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for some reason if you do not set background it lags between transition ¯\_(ツ)_/¯
        self.navigationItem.title = MyEnums.TabNames.Expenses.rawValue
        self.navigationController?.isNavigationBarHidden = true
        self.collectionView.backgroundColor = UIColor(rgb: 0xe8e8e8)
        self.collectionView?.register(ExpensesCVCCell.self, forCellWithReuseIdentifier: cellId)
        
        if initialLoad == true { initialLoad = false }
        
        pieView = PieChart(
            frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height,
                          width: self.view.frame.width, height: self.view.frame.height * 0.55),
            categories: (GLOBAL_userDatabase?.categories)!,
            categoryTotal: (GLOBAL_userDatabase?.categoryTotal)!)
        pieView!.backgroundColor = UIColor.white
        self.view.addSubview(pieView!)

        let layout = UICollectionViewFlowLayout()
        // Where frame holding cells begin
        layout.sectionInset = UIEdgeInsets(top: pieView!.frame.height, left: 0, bottom: 0, right: 0)
        self.collectionView.setCollectionViewLayout(layout, animated: false)
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
        return CGSize(width: self.view.frame.width, height: 50)
    }

}
