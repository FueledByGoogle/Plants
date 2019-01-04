//
//  ViewController.swift
//  Plants
//
//  Copyright © 2018 Leo Huang. All rights reserved.
//
import SQLite3
import UIKit


// search properties


var plant: Plant = Plant()

class MenuVC: UICollectionViewController, UICollectionViewDelegateFlowLayout  {
    
    
    // database properties
    let databaseFileExtension = "db"
    let databaseFileName = "Plants"
    let searchTableName = "Plants"
    var db: OpaquePointer?
    
    // buttons
    var searchButton: UIButton!
    var myPlantsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        navigationItem.title = "Home"
        self.navigationController?.isNavigationBarHidden = true
        
        // load database first so we can populate the array that searchVC loads from
        populateDataArray()
        setupBackgroundImg()
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    /** background image setup
     */
    func setupBackgroundImg() {
        self.collectionView?.backgroundColor = .white
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = UIImage(named: "DSC_1336.JPG")
        imageView.image = imageView.image!.rotate(radians: 3*Float.pi/2) // using extended function of image implemented in ImageUtil
        imageView.contentMode = UIViewContentMode.scaleAspectFill // same effect as windows desktop fill option
        self.view.addSubview(imageView)
        // blur effect
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.addSubview(blurEffectView)
    }
    
    /** database setup
     */
    func populateDataArray () {
        let dbPath = Bundle.main.url(forResource: databaseFileName, withExtension: databaseFileExtension)
        if (sqlite3_open(dbPath!.absoluteString, &db) != SQLITE_OK && dbPath != nil) {
            print("error opening database")
        } else {
            print("successfully opened database")
        }
        // query language
        let queryString = "SELECT name, sowinstructions, spaceinstructions, harvestinstructions FROM " + searchTableName + " ORDER BY name"
        //statement pointer
        var stmt:OpaquePointer?
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("There was an error preparing the database: ", errmsg)
            return
        }
        // traverse through all records
        var i = 0
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let name = String(cString: sqlite3_column_text(stmt, 0))
            let sowInstructions = String(cString: sqlite3_column_text(stmt, 1))
            let spaceInstructions = String(cString: sqlite3_column_text(stmt, 2))
            let harvestInstructions = String(cString: sqlite3_column_text(stmt, 3))
            
            plant.addPlantId(plantId: i)
            plant.addPlantName(plantNames: name)
            plant.addPlantSowInstruction(plantSowInstructions: sowInstructions)
            plant.addPlantSpaceInstructions(plantSpaceInstructions: spaceInstructions)
            plant.addPlantHarvestInstructions(plantHarvestInstructions: harvestInstructions)
            i += 1
        }
    }
    
    /** button setup
     */
    func setupButtons() {
        searchButton = UIButton.init(type: UIButtonType.system)
        searchButton.setTitle("Database", for: UIControlState.normal)
        searchButton.bounds = CGRect(x: 50, y: 50, width: view.bounds.width, height: 60)
        // must add to half of height of search label itself because position starts at center of label
        searchButton.center = CGPoint(x: view.bounds.width/2, y: (navigationController?.navigationBar.frame.height)! +                      UIApplication.shared.statusBarFrame.height + 30)// position in view
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)// font
        searchButton.setTitleColor(UIColor.white, for: UIControlState.normal)// title colour
        searchButton.addTarget(self, action: #selector(goToSearchView), for: .touchUpInside)// map button press to function
        self.view.addSubview(searchButton)
        
        

    }
    
    @objc func goToSearchView(sender: UIButton!) {
        let searchVC = SearchVC(collectionViewLayout:UICollectionViewFlowLayout())
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc func goToMyPlantsView(sender: UIButton!) {
    }
}

