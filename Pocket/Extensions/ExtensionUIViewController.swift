import UIKit

extension UIViewController
{
    func enableDimissKeyboardOnTapOutside() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func getNavAndStatusbarHeight() -> CGFloat {
        var top = self.navigationController?.navigationBar.frame.height ?? 0.0
        if #available(iOS 13.0, *) {
            top += view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
//            print("top original:", UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0)
//            print ("top:", top)
        } else {
            top += UIApplication.shared.statusBarFrame.height
        }
        return top
    }
}
