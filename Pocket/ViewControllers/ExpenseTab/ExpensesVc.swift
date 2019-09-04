import SQLite3
import UIKit

class ExpensesVc: UIViewController  {


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = MyEnums.TabNames.Expenses.rawValue
        self.navigationController?.isNavigationBarHidden = true

        self.view.backgroundColor = UIColor(rgb: 0xFFD3D4)


        let anglePI2 = (CGFloat.pi * 2)
        let center = CGPoint.init(x: self.view.bounds.size.width / 2, y: self.view.bounds.size.height / 2)
        let radius = min(self.view.bounds.size.width, self.view.bounds.size.height) / 2;


//        let myView = UIView(frame: CGRect(x: self.view.frame.midX-100, y: UIApplication.shared.statusBarFrame.height, width: 200, height: 200))
        
        let myView = PieView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: self.view.frame.width, height: self.view.frame.height/2))
        myView.backgroundColor = UIColor.red

        self.view.addSubview(myView)
        
        
        
//        let imageName = "testTextImage.jpg"
//        let image = UIImage(named: imageName)
//        let imageView = UIImageView(image: image!)
//        imageView.frame = CGRect(x: self.view.frame.midX-50, y: UIApplication.shared
//            .statusBarFrame.height, width: 100, height: 200)
//        view.addSubview(imageView)
    }
    
}
