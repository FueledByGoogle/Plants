import UIKit

class ExpensesCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let cellId = "cellId"
    
    // single user
    var user1: User = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        // for some reason if you do not set background it lags between transition ¯\_(ツ)_/¯
        self.navigationItem.title = MyEnums.TabNames.Expenses.rawValue
        self.navigationController?.isNavigationBarHidden = true
        self.collectionView.backgroundColor = UIColor.white
        
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
//        layout.itemSize = CGSize(width: 60, height: 60)
        self.collectionView.collectionViewLayout = layout
        
        // gets rid of spacing between cells
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        dummyInfo()
    }
    
    
    // dummy info
    func dummyInfo () {
        user1.setUserId(userId: 0)
        user1.addExpenseType(expenseType: "Transportation")
        user1.addExpenseValue(expenseValue: 100)
        
        user1.addExpenseType(expenseType: "Food")
        user1.addExpenseValue(expenseValue: 300)
        
        user1.addExpenseType(expenseType: "Entertainment")
        user1.addExpenseValue(expenseValue: 50)
        
    }

    // number of sections
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    // number of cells in section
    override func collectionView(_ collection: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    //  what each cell is going to display
    override func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        if indexPath.row == 0 { // first cell in section
            let pieView = Piechart(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height), categories: &user1.expenseType,  values: &user1.expenseValue)
            pieView.backgroundColor = UIColor.red
            cell.contentView.addSubview(pieView)
            cell.backgroundColor = UIColor.brown
        } else if indexPath.row == 1 {
//            let newView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
//            newView.backgroundColor  = UIColor.black
//            cell.contentView.addSubview(newView)
            cell.backgroundColor = UIColor.purple
        } else {
            cell.backgroundColor = UIColor.purple
        }
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: self.view.frame.width, height: 300)
        if (indexPath.row == 0 ) {
            size = CGSize(width: self.view.frame.width, height: self.view.frame.width)
        } else {
            
        }
        return size
    }

}
