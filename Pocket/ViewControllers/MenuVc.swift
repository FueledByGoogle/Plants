//
//  ViewController.swift
//  Pocket
//
//  Copyright © 2018 Leo Huang. All rights reserved.
//
import SQLite3
import UIKit
import FirebaseMLVision


// search properties
var plant: Plant = Plant()

class MenuVc: UICollectionViewController, UICollectionViewDelegateFlowLayout  {
    
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
        
        self.collectionView?.backgroundColor = UIColor.white
        
        // load database first so we can populate the array that searchVC loads from
        populateDataArray()
//        setupBackgroundImg() // big picture causes lag
//        setupButtons()
        
//        print("this should only print once (MenuVC)")
//        downloadUrl()
        
//        textFromImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    /** Extract text from an image
     */
    func textFromImage() {
        let vision = Vision.vision()
        let textRecognizer = vision.onDeviceTextRecognizer()
        
        // returns empty if image does not exist
        guard let testImage = UIImage(named: "IMG_9671.jpg") else {
            print("Error when loading/finding image")
            return
        }
        
        let visionImage = VisionImage(image: testImage)
        
//        textRecognizer.process(visionImage) { result, error in
//            guard error == nil, let result = result else {
//                return
//            }
//            print(result.text)
//        }
        
        textRecognizer.process(visionImage) { (image, error) in self.processResult(from: image, error: error) }
    }
    
    
    /** Process text extracted from the image
     */
    func processResult(from text: VisionText?, error: Error?) {
        
        guard let features = text else {return}
        
        for block in features.blocks {
//            let blockText = features.text
            for line in block.lines {
//                print(line.text)
                for element in line.elements {
                    print(element.text)
                }
            }
//            print(blockText)
        }
    }
    
    
    /** Download item from url
     */
    func downloadUrl() {
        // some text
        let url = URL(string:"https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY")!
        // picture
//        let url = URL(string:"https://news.ycombinator.com")!
        
        let downloadTask = URLSession.shared.downloadTask(with: url) {
            urlOrNil, responseOrNil, errorOrNil in
            // check for and handle errors:
            // * errorOrNil should be nil
            // * responseOrNil should be an HTTPURLResponse with statusCode in 200..<299
        var filePath = ""
            guard let fileUrl = urlOrNil else { return }
            do {
                // app document directory
                let documentsURL = try
                        FileManager.default.url(for: .documentDirectory,
                                                in: .userDomainMask,
                                                appropriateFor: nil,
                                                create: false)

                // where the tmp file will be saved to in the app document directory
                let savedURL = documentsURL.appendingPathComponent(
                        fileUrl.lastPathComponent)
               filePath = savedURL.path
               
            try FileManager.default.moveItem(at: fileUrl, to: savedURL)
                
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    print("FILE AVAILABLE")
                    do {
                        let text2 = try String(contentsOf: savedURL, encoding: .utf8)
                        print(text2)
                    }
                    catch {/* error handling here */}
                } else {
                    print("FILE NOT AVAILABLE")
                }
                
            } catch {
                print ("file error: \(error)")
            }
        }
        downloadTask.resume()
    }
    
    /** background image setup
     */
    func setupBackgroundImg() {
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = UIImage(named: "DSC_1336.JPG")
        imageView.image = imageView.image!.rotate(radians: 3*Float.pi/2) // using extended function of image implemented in ImageUtil
        imageView.contentMode = UIView.ContentMode.scaleAspectFill // same effect as windows desktop fill option
        self.view.addSubview(imageView)
        
//        imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -500).isActive = true
        // blur effect
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWid   th, .flexibleHeight]
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
        // statement pointer
        var stmt:OpaquePointer?
        // preparing the query
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
        searchButton = UIButton.init(type: UIButton.ButtonType.system)
        searchButton.setTitle(MyEnums.TabNames.Search.rawValue, for: UIControl.State.normal)
        searchButton.bounds = CGRect(x: 50, y: 50, width: view.bounds.width, height: 60)
        // must add to half of height of search label itself because position starts at center of label
        searchButton.center = CGPoint(x: view.bounds.width/2, y: (navigationController?.navigationBar.frame.height)! +                      UIApplication.shared.statusBarFrame.height + 30)// position in view
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)// font
        searchButton.setTitleColor(UIColor.white, for: UIControl.State.normal)// title colour
        searchButton.addTarget(self, action: #selector(goToSearchView), for: .touchUpInside)// map button press to function
        self.view.addSubview(searchButton)
        
    
    }
    
    @objc func goToSearchView(sender: UIButton!) {
        let searchVC = SearchVc(collectionViewLayout:UICollectionViewFlowLayout())
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc func goToMyPlantsView(sender: UIButton!) {
    }
}
