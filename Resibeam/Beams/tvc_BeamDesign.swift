//
//  tvc_BeamDesign.swift
//  ResiBeam_V0.0.7
//
//  Created by Mark Walker on 6/15/16.
//  Copyright © 2016 Mark Walker. All rights reserved.
//

import Cocoa

class tvc_BeamDesign: NSTabViewController {

 
    @IBOutlet weak var theTabView: NSTabView!
    var delegate:beamDataDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabFont = NSFont(name: "system font regular", size: 12)
        
        theTabView.font = tabFont!
        
        self.tabViewItems.removeLast(2)

        
    }
    
//    override func tabView(tabView: NSTabView, didSelect: NSTabViewItem?){
//        if self.delegate != nil{
//            theIndex:Int =
//            delegate?.updatedSaveDocWithSelectedDesignTabIndex(theIndex)
//        }
//    }
    
    
    
    override func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        updateDesignTabSelection(theTab: tabViewItem?.identifier as! Int)
        
        if tabViewItem?.identifier as! String == "2" {
            tabViewItem?.viewController?.viewWillAppear()
        }
    }
    
    func updateDesignTabSelection(theTab: Int){
        
        self.selectedTabViewItemIndex = theTab
        
    }
    
}
