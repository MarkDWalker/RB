//
//  ViewController_GeneratorConditionSelector.swift
//  BeamDesigner_V0.0.3
//
//  Created by Mark Walker on 9/6/15.
//  Copyright (c) 2015 Mark Walker. All rights reserved.
//


protocol MWLoadCollectionDataSource{
    
    //    func sendLoadCollection(sharedLoadCollection:[MWLoadData], loadIndex:Int)
    func sendLoadCollection(_ beamAndLoads:MWBeamAnalysis)
}

import Cocoa

class vc_GeneratorConditionSelector: NSViewController, NSTableViewDataSource, NSTableViewDelegate, tableViewReloadDelegate, MWLoadCollectionDataSource{

    
    
    
    @IBOutlet weak var theTableView: NSTableView!
    
    var cellHeight:CGFloat = 180
    var a:MWBeamAnalysis = MWBeamAnalysis()
    var delegate: MWLoadCollectionDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        theTableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyle.none
    }
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        let returnVal:Int = 5
        
        return returnVal
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        //var identifier:NSString = tableColumn!.identifier
        
        let theCell = tableView.make(withIdentifier: "theCell", owner: self) as! CustomCell_GereratorConditionsCell
        
        theCell.delegate = self
        
        if row == 0 {
            //theCell.identifier = "theCell0"
            theCell.image1.image = NSImage(named: "A_Framing.png")!
            theCell.selectButton.identifier = "theCell0"
            
            theCell.lbl_MemberType.stringValue = "Header"
            theCell.lbl_HouseStories.stringValue = "Single Story"
            theCell.lbl_StoryLocation.stringValue = "Top Floor"
            theCell.lbl_ExInt.stringValue = "Roof Above"
            theCell.lbl_LBFloorAbove.stringValue = "Not Applicable"
                
            
        }else if row == 1{
            //theCell.identifier = "theCell1"
            theCell.image1.image = NSImage(named: "B_Framing.png")!
            theCell.selectButton.identifier = "theCell1"
            
            theCell.lbl_MemberType.stringValue = "Header"
            theCell.lbl_HouseStories.stringValue = "1 or 2 Story"
            theCell.lbl_StoryLocation.stringValue = "1st Floor"
            theCell.lbl_ExInt.stringValue = "Exterior"
            theCell.lbl_LBFloorAbove.stringValue = "Floor + Roof Above"
            
        }else if row == 2{
            theCell.image1.image = NSImage(named: "C_OverView.png")!
            theCell.selectButton.identifier = "theCell2"
            
            theCell.lbl_MemberType.stringValue = "Lintel"
            theCell.lbl_HouseStories.stringValue = "1 or 2 Story"
            theCell.lbl_StoryLocation.stringValue = "Multiple"
            theCell.lbl_ExInt.stringValue = "Exterior"
            theCell.lbl_LBFloorAbove.stringValue = "Brick Weight Only"
            
        }else if row == 3{
            theCell.image1.image = NSImage(named: "D_FloorJoistMain.png")!
            theCell.selectButton.identifier = "theCell3"
            
            theCell.lbl_MemberType.stringValue = "Floor Joist"
            theCell.lbl_HouseStories.stringValue = "N/A"
            theCell.lbl_StoryLocation.stringValue = "Any Floor"
            theCell.lbl_ExInt.stringValue = "Interior"
            theCell.lbl_LBFloorAbove.stringValue = "Floor Load Only"
           
        }else if row == 4{
            theCell.image1.image = NSImage(named: "E_Main.png")!
            theCell.selectButton.identifier = "theCell4"
            
            theCell.lbl_MemberType.stringValue = "Floor Beam"
            theCell.lbl_HouseStories.stringValue = "1 or 2 Story"
            theCell.lbl_StoryLocation.stringValue = "Basement"
            theCell.lbl_ExInt.stringValue = "Interior"
            theCell.lbl_LBFloorAbove.stringValue = "1st + 2nd Floor Above"
            
        }
        return theCell
        
    }
    
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return cellHeight
    }
    
    //protocol Function
    func myReloadTableView() {
        theTableView.reloadData()
    }
    
    //protocol Function
    func callSegueFromCell(_ theSegueIdentifier: String, theSender: AnyObject) {
        
        //var modifiedIdentifier:String = theSegueIdentifier + "\(theTableView.selectedRow)"
        
        self.performSegue(withIdentifier: theSegueIdentifier, sender: theSender)
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        if identifier == "theCell0"{
            let VC_LoadGen1 = self.storyboard?.instantiateController(withIdentifier: "LoadGen1") as! vc_LoadGen1
            VC_LoadGen1.a = self.a
            VC_LoadGen1.delegate = self
            //self.presentViewControllerAsModalWindow(VC_LoadGen1)
            self.presentViewControllerAsSheet(VC_LoadGen1)
            
        }else if identifier == "theCell1"{
            let VC_LoadGen2 = self.storyboard?.instantiateController(withIdentifier: "LoadGen2") as! vc_LoadGen2
            VC_LoadGen2.a = self.a
            VC_LoadGen2.delegate = self
            self.presentViewControllerAsSheet(VC_LoadGen2)
            
        }else if identifier == "theCell2"{
            let VC_LoadGen3 = self.storyboard?.instantiateController(withIdentifier: "LoadGen3") as! vc_LoadGen3
            VC_LoadGen3.a = self.a
            VC_LoadGen3.delegate = self
            self.presentViewControllerAsSheet(VC_LoadGen3)
        
        }else if identifier == "theCell3"{
            let VC_LoadGen4 = self.storyboard?.instantiateController(withIdentifier: "LoadGen4") as! vc_LoadGen4
            VC_LoadGen4.a = self.a
            VC_LoadGen4.delegate = self
            self.presentViewControllerAsSheet(VC_LoadGen4)
        }else if identifier == "theCell4"{
            let VC_LoadGen5 = self.storyboard?.instantiateController(withIdentifier: "LoadGen5") as! vc_LoadGen5
            VC_LoadGen5.a = self.a
            VC_LoadGen5.delegate = self
            self.presentViewControllerAsSheet(VC_LoadGen5)
        }
        
    }
    
    
//protocol function to send data back to Beam Data Panel
    func sendLoadCollection(_ beamAndLoads: MWBeamAnalysis) {
        if self.delegate != nil{
            delegate?.sendLoadCollection(beamAndLoads)
            self.dismiss(self)
        }
    }
    
}
