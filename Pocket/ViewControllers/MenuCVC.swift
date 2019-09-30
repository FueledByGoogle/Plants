import UIKit
import SQLite3


class MenuCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for some reason if you do not set background it lags between transition ¯\_(ツ)_/¯
        self.navigationItem.title = MyEnums.TabNames.Menu.rawValue
        self.navigationController?.isNavigationBarHidden = true
        self.collectionView.backgroundColor =  UIColor(rgb: 0xe8e8e8)
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    /**
        number of sections
     */
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /**
        number of cells in section
     */
    override func collectionView(_ collection: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    /**
        what each cell is going to display
     */
    override func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = UIColor.purple
        
        
        if indexPath.row == 0 {
            let expenseTextField = UITextField(frame: CGRect(x: cell.frame.width/2 - 100, y: cell.frame.height/2 - 50, width: 200, height: 100))
//            expenseTextField.center =  cell.contentView.center
            expenseTextField.text = "place holder text"
            expenseTextField.borderStyle = UITextField.BorderStyle.line
            expenseTextField.delegate = self
            cell.contentView.addSubview(expenseTextField)
        }

        return cell
    }
    
    /**
        what a specific cell's size should be
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: self.view.frame.width, height: 300)
        if (indexPath.row == 0 ) {
            size = CGSize(width: self.view.frame.width, height: self.view.frame.height * 0.40)
        } else {
            size = CGSize(width: self.view.frame.width, height: 50)
        }
        return size
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//         textField.resignFirstResponder()
//         return true
//    }

    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
