import UIKit
import SQLite3



/*
 
    drop down menu with selection instead of buttons
 
    Categories
    - food
    - entertainment
    - transportation
    - sports
    -
    - other
 */

class MenuCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    let cellId = "cellId"
    
    var expenseTextField: UITextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for some reason if you do not set background it lags between transition ¯\_(ツ)_/¯
        self.navigationItem.title = MyEnums.TabNames.Menu.rawValue
        self.navigationController?.isNavigationBarHidden = true
        self.collectionView.backgroundColor =  UIColor(rgb: 0xe8e8e8)
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        // dismiss keyboard upon touching outside the keyboard
        self.setupToHideKeyboardOnTapOnView()
        
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
        return 15
    }
    
    /**
        what each cell is going to display
     */
    override func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = UIColor.purple
        
        
        if indexPath.row == 0
        {
            expenseTextField = UITextField(frame: CGRect(x:0, y: cell.frame.height/2 - 50, width: cell.frame.width, height: 100))
            expenseTextField.text = "0"
            expenseTextField.font = .systemFont(ofSize: 50)
            expenseTextField.adjustsFontSizeToFitWidth = true
            expenseTextField.textAlignment  = .center
            expenseTextField.borderStyle = UITextField.BorderStyle.line
            expenseTextField.delegate = self
            expenseTextField.keyboardType = UIKeyboardType.decimalPad
            cell.contentView.addSubview(expenseTextField)
        }
        else if indexPath.row >= 1 && indexPath.row <= 12
        {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
            button.setTitle(String(indexPath.row-1), for: .normal)
            button.addTarget(self, action: #selector(clickMe), for: .touchUpInside)
            cell.contentView.addSubview(button)
        }

        return cell
    }
    

    /**
        what a specific cell's size should be
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: self.view.frame.width, height: 300)
        if indexPath.row == 0 {
            size = CGSize(width: self.view.frame.width, height: self.view.frame.height * 0.40)
        } else if indexPath.row >= 1 && indexPath.row <= 12 {
            size = CGSize(width: 50, height: 50)
        } else {
            size = CGSize(width: self.view.frame.width, height: 50)
        }
        return size
    }
    
    @objc func clickMe(sender:UIButton!) {
        
        // validate input
        
        // check for correct number of decimals
        if (expenseTextField.text!.filter { $0 == "."}.count) > 1 {
            print("Invalid input, try again")
            return
        }
        
        // check for invalid characters
        let removedDecimal = expenseTextField.text!.replacingOccurrences(of: ".", with: "")
        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: removedDecimal)) == false {
            print("Entered text that contains unsupported characters ")
        } else {
            print("Correct Input")
        }
    }
}
