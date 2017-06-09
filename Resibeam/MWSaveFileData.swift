//
//  MWSaveFileData.swift
//  ResiBeam_V0.0.7
//
//  Created by Mark Walker on 8/5/16.
//  Copyright © 2016 Mark Walker. All rights reserved.
//

import Cocoa

class MWSaveFileData: NSObject, NSCoding{
    
    var beamAnalysisCollection = [MWBeamAnalysis]()
    var beamInterfaceData = MWPersistentBeamInterfaceData()
    
    
    override init(){
        
    }
    
    //MARK: NSCoding Conformance
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        
        beamAnalysisCollection = aDecoder.decodeObject(forKey: "beamAnalysisCollection") as! [MWBeamAnalysis]
        beamInterfaceData = aDecoder.decodeObject(forKey: "beamInterfaceData") as! MWPersistentBeamInterfaceData
        
        
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(beamAnalysisCollection, forKey: "beamAnalysisCollection")
        aCoder.encode(beamInterfaceData, forKey: "beamInterfaceData")
    }

    
    
}
