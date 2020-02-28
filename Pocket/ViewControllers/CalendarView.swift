/*
   TODO:
   - Calendar like with list of expenses on that day listed on the bottom
   - Swipe left on calendar day to remove an entry
   - Each calendar box shows total expense on that day
*/
import UIKit


class CalendarView: UIViewController {
    
    var calendarCVCView: CalendarCVC?
    var tableView: CalendarTableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: MyEnums.Colours.ORANGE_Dark.rawValue)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationItem.title = MyEnums.TabNames.Calendar.rawValue
        self.view.backgroundColor = .black
        
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        
        calendarCVCView = CalendarCVC(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width/7*5 + self.navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height), collectionViewLayout: layout)
        calendarCVCView!.viewDidLoad()
        calendarCVCView!.setCollectionViewLayout(layout, animated: false)
        
        
        
        tableView = CalendarTableView(frame: CGRect(x: 0, y: calendarCVCView!.frame.maxY + 1, width: self.view.frame.width, height: self.view.frame.height - calendarCVCView!.frame.height - self.navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height))
        tableView?.viewDidLoad()
        
        
        
        self.view.addSubview(calendarCVCView!)
        self.view.addSubview(tableView!)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        calendarCVCView?.viewDidAppear(true)
        
        // we want to tell table view to update view
        if GLOBAL_userDatabase?.needToUpdateData[MyEnums.TabNames.Calendar.rawValue] == true {
//                let (d1, d2) = Date.getStartEndDates(timeInterval: lastSelectedButton)
//                reloadData(startDate: d1, endDate: d2)
//                GLOBAL_userDatabase?.needToUpdateData[MyEnums.TabNames.Calendar.rawValue] = false
        }
    }
}
