//
//  MWPersistentBeamInterfaceData.swift
//  ResiBeam_V0.0.7
//
//  Created by Mark Walker on 8/5/16.
//  Copyright © 2016 Mark Walker. All rights reserved.
//

import Cocoa

class MWPersistentBeamInterfaceData: NSObject, NSCoding {
    
    var selectedBeamListRow:Int = -1
    var selectedLoadListRow:Int = -1
    
    
    override init(){
        
    }
    
    //MARK: NSCoding Conformance
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        selectedBeamListRow = Int(aDecoder.decodeCInt(forKey: "selectedBeamListRow"))
        selectedLoadListRow = Int(aDecoder.decodeCInt(forKey: "selectedLoadListRow"))
        
        
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(selectedBeamListRow, forKey: "selectedBeamListRow")
        aCoder.encode(selectedLoadListRow, forKey: "selectedLoadListRow")
     
    }
    
}
