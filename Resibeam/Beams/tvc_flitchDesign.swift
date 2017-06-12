//
//  tvc_FlitchDesign.swift
//  ResiBeam
//
//  Created by Mark Walker on 6/10/2017.
//  Copyright © 2017 Mark Walker. All rights reserved.
//

import Cocoa

class tvc_FlitchDesign: NSTabViewController {
    
    
    @IBOutlet weak var theTabView: NSTabView!
    var delegate:beamDataDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        let tabFont = NSFont(name: "system font regular", size: 12)
//        
//        theTabView.font = tabFont!
//        
//        self.tabViewItems.removeLast(1)
        
        
    }
    
    
    
    
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

