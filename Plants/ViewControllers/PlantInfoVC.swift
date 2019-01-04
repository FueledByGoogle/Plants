//
//  Plant.swift
//  Plants
//
//  Created by Leo Huang on 2018-06-26.
//  Copyright © 2018 Leo Huang. All rights reserved.
//
import UIKit

/***
 TODO:
 - posibble optimization where we don't find index of plant name just to get sow instructions
*/

class PlantInfoVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var passedPlantId =  0
    var passedPlantName = ""
    
    let cellId = "cevard"
    let headerId = "headerId"
    let footerId = "footerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = plant.getPlantName(index: passedPlantId)
        // for some reason if you do not set background it lags between transition ¯\_(ツ)_/¯
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.register(PlantInfoCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView!.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId) // header
        self.collectionView!.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId)
    }
    
    // cell count
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
// returning two cells for testing
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PlantInfoCell
        
        let index = plant.getPlantNames().index(of: passedPlantName)
        
        if (indexPath.row == 0 ) {
            cell.sectionLabel.text = "Sow Instructions:"
            cell.descriptionLabel.text = plant.plantSowInstructions[index!]
        } else if (indexPath.row == 1 ) {
            cell.sectionLabel.text = "Space Instructions"
            cell.descriptionLabel.text = plant.getPlantSpaceInstructions(index: index!)
        } else if (indexPath.row == 2) {
            cell.sectionLabel.text = "Harvest Instructions"
            cell.descriptionLabel.text = plant.getPlantHarvestInstructions(index: index!)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let index = plant.getPlantNames().index(of: passedPlantName)
        let size = CGSize(width: self.view.frame.width, height: 1000)
        
        var estimatedFrame = CGRect()
        // note that by setting a default font size here we need to compensate by adding to
        // the height in the end. The font size should match in PlantInfoCell
        let attribute = [NSAttributedStringKey.font
            : UIFont(name: "HelveticaNeue", size: 16)!] // default font
        
        if (indexPath.row == 0 ) {
            estimatedFrame = NSString(string:
                plant.plantSowInstructions[index!]).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attribute, context: nil)
        } else if (indexPath.row == 1 ) {
            estimatedFrame = NSString(string: plant.getPlantSpaceInstructions(index: index!)).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attribute, context: nil)
        } else if (indexPath.row == 2) {
            estimatedFrame = NSString(string: plant.getPlantHarvestInstructions(index: index!)).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attribute, context: nil)
        }
    
        // compensate for the title of each section by adding 30
        return CGSize(width: self.view.frame.width,
                    height: 30 + estimatedFrame.height)
    }
    
    
    // header
/*    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionElementKindSectionHeader) {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
            header.backgroundColor = UIColor.red
            return header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
            footer.backgroundColor = UIColor.blue
            return footer
        }
    }
    
    // header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.height, height: 50)
    }
    
    // footer size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.height, height: 100)
   }
*/
}
