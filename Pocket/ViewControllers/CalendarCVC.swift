/*
 Calendar like with list of expenses on that day listed on the bottom
 Each calendar box shows total expense on that day
 */
import UIKit


class CalendarCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    
    let cellReuseIdentifier = "cellId"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = MyEnums.TabNames.Calendar.rawValue
//        self.navigationController?.isNavigationBarHidden = true
        self.collectionView.backgroundColor =  UIColor(rgb: 0xe8e8e8)
        self.collectionView.register(CalendarCVCCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)

        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        
    }
    
    
    /// number of cells in section
    override func collectionView(_ collection: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    
    /// what each cell is going to display
    override func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! CalendarCVCCell
        cell.backgroundColor = UIColor.purple
        cell.label.text = "asdf"

        return cell
    }
    
    
    /// what a specific cell's size should be
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 70)
    }
    
}
