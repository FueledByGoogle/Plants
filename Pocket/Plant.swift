//
//  Plant.swift
//  Plants
//
//  Created by Leo Huang on 2018-08-07.
//  Copyright © 2018 Leo Huang. All rights reserved.ooo
//

import UIKit

class Plant {
    
    var plantId: [Int] = []
    var plantNames: [String] = []
    var plantSowInstructions: [String] = []
    var plantSpaceInstructions: [String] = []
    var plantHarvestInstructions: [String] = []
    
    func Plant() {
        
    }
    
    func addPlantId(plantId: Int) {
        self.plantId.append(plantId)
    }
    
    func getPlantIds() -> Array<Int> {
        return self.plantId
    }
    
    func addPlantName(plantNames: String) {
        self.plantNames.append(plantNames)
    }
    
    func getPlantNames() -> Array<String> {
        return self.plantNames
    }
    
    func getPlantName(index: Int) -> String {
        return plantNames[index]
    }
    // sow instructions
    func addPlantSowInstruction(plantSowInstructions: String) {
        self.plantSowInstructions.append(plantSowInstructions)
    }
    
    func getplantSowInstructions() -> Array<String> {
        return self.plantSowInstructions
    }
    
    func getPlantSowInstruction(index: Int) -> String {
        return self.plantSowInstructions[index]
    }
    // space instructions
    func addPlantSpaceInstructions(plantSpaceInstructions: String) {
        self.plantSpaceInstructions.append(plantSpaceInstructions)
    }
    
    func getPlantSpaceInstructions() -> Array<String> {
        return self.plantSpaceInstructions
    }
    
    func getPlantSpaceInstructions(index: Int) -> String {
        return plantSpaceInstructions[index]
    }
    // harvest instructions
    func addPlantHarvestInstructions(plantHarvestInstructions: String) {
        self.plantHarvestInstructions.append(plantHarvestInstructions)
    }
    
    func getPlantHarvestInstructions() -> Array<String> {
        return self.plantHarvestInstructions
    }
    
    func getPlantHarvestInstructions(index: Int) -> String {
        return plantHarvestInstructions[index]
    }
}
