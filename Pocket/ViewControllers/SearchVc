//import UIKit
//
//
//class SearchVc: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
//    
//    let cellReuseIdentifier: String = "SearchCell"
//    
//    var searchBar = UISearchBar()
//    var searching: Bool = false
//    var filtered: [String] = [] // filtered search result
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationItem.title = MyEnums.TabNames.Search.rawValue
//        setupSearchBar()
//        
//        // for some reason if you do not set background it lags between transition ¯\_(ツ)_/¯
//        self.collectionView?.backgroundColor = UIColor.white
//        // Register cell classes
//        self.collectionView!.register(SearchCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
//    }
//    
//    // --------------------------------  collection view implementations --------------------------------
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//// #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//    
//    // on item select
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let detailVC = PlantInfoVc(collectionViewLayout:UICollectionViewFlowLayout())
//        
//        let cell = collectionView.cellForItem(at: indexPath) as! SearchCell
//        detailVC.passedPlantName = cell.nameLabel.text!
//        navigationController?.pushViewController(detailVC, animated: true)
//    }
//    
//    // cell count
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if searching {
//            return filtered.count
//        }
//        return plant.getPlantNames().count
//    }
//    
//    // cell dequeue
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! SearchCell
//        //        cell.backgroundColor = UIColor.gray
//        if (searching) {
//            cell.nameLabel.text = filtered[indexPath.row]
//        } else {
//            cell.nameLabel.text = plant.getPlantName(index: indexPath.row)
//        }
//        return cell
//    }
//    
//    // cell size
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return(CGSize(width: view.frame.width, height: 40))
//    }
//    
//    // positions cells below the navigation bar
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: view.frame.width, height: self.view.safeAreaInsets.top)
//    }
//    
//    // -------------------------------- search bar implementations --------------------------------
//    func setupSearchBar() {
//        // since search bar anchor is at the top we can simply get safe area from statusbar to navigation bar
//        searchBar = UISearchBar(frame: CGRect(x: 0, y: Int((navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height), width: Int(UIScreen.main.bounds.width), height: 40))
//        searchBar.sizeToFit()
//        //        searchBar.backgroundImage = UIImage() // removes background
//        //        navigationItem.titleView = searchBar // if you want the search bar to be part of the navigation bar
//        searchBar.placeholder = "Watcha lookin for?"
//        view.addSubview(searchBar)
//        searchBar.delegate = self as UISearchBarDelegate
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
//        filtered.removeAll(keepingCapacity: false)
//        filtered = plant.getPlantNames().filter({$0.localizedCaseInsensitiveContains(searchBar.text!)})
//        searching = (filtered.count == 0) ? false: true
//        collectionView?.reloadData()
//    }
//    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searching = true;
//    }
//    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searching = false;
//    }
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searching = false;
//    }
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searching = false;
//    }
//    
//}
