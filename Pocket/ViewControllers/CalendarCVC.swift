/*
    TODO:
    - Calendar like with list of expenses on that day listed on the bottom
    - Swipe left on calendar day to remove an entry
    - Each calendar box shows total expense on that day
 */
import UIKit


class CalendarCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    var initialLoad = true
    
    var cellWidth = CGFloat(50)
    let cellReuseIdentifier = "cellId"
    
    let currentDay = Date.formatDateAndTimezoneString(date: Date(), dateFormat: "dd", timeZone: .LocalZone)
    var currentSelection: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: MyEnums.Colours.ORANGE_Dark.rawValue)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationItem.title = MyEnums.TabNames.Calendar.rawValue
//        self.navigationController?.isNavigationBarHidden = true
        self.collectionView.backgroundColor =  UIColor.white
        self.collectionView.register(CalendarCVCCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        cellWidth = self.collectionView.frame.width/7
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if initialLoad == true {
//            print (currentDay)
            self.collectionView(self.collectionView, didSelectItemAt: IndexPath(item: Int(currentDay)!-1, section: 0))
            self.collectionView.selectItem(at: IndexPath(row: Int(currentDay)!-1, section: 0), animated: true, scrollPosition: .top)
            currentSelection = IndexPath(row: Int(currentDay)!-1, section: 0)
            initialLoad = false
        }
        else {
            // Must reselect when coming back from view, otherwise after returning from another clicking another cell will not clear the last selected cell
            self.collectionView(self.collectionView, didSelectItemAt: currentSelection!)
            self.collectionView.selectItem(at: currentSelection, animated: true, scrollPosition: .top)
        }
    }
    
    
    /// number of cells in section
    override func collectionView(_ collection: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Date.getNumberOfDaysInMonth(date: Date())
    }
    
    
    /// what each cell is going to display
    override func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! CalendarCVCCell
//        cell.backgroundColor = UIColor.purple
        cell.layer.borderWidth = 0.1
        cell.label.text = String(indexPath.row+1)
        
        // Needed so we when cells are reused we still highlight the correct cell
        if cell.isSelected && cell.backgroundColor != UIColor(rgb: MyEnums.Colours.ORANGE_PUMPKIN.rawValue) {
            cell.backgroundColor = UIColor(rgb: MyEnums.Colours.ORANGE_PUMPKIN.rawValue)
        } else if cell.backgroundColor != UIColor.white{
            cell.backgroundColor = .white
        }

        return cell
    }
    
    
    /// what a specific cell's size should be
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width/7, height: self.collectionView.frame.width/7);
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarCVCCell {
            cell.backgroundColor = UIColor(rgb: 0xF4AA00)
            currentSelection = indexPath
        }
    }

    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarCVCCell {
            cell.backgroundColor = UIColor.white
        }
    }
}
