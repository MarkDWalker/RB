//
//  MWCalulationTextView.swift
//  BeamDesigner_V0.0.4
//
//  Created by Mark Walker on 11/7/15.
//  Copyright © 2015 Mark Walker. All rights reserved.
//

import Cocoa

class MWCalulationTextView: NSTextView {
    
    func myPrint(_ sender:AnyObject){
        
        let pInfo = NSPrintInfo()
        pInfo.topMargin = 50
        pInfo.bottomMargin = 50
        
        pInfo.isVerticallyCentered = false
        
        NSPrintOperation(view: self,printInfo: pInfo).run()
        
    }

}
