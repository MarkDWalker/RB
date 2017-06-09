//
//  ViewController_LoadGen4.swift
//  BeamDesigner_V0.0.4
//
//  Created by Mark Walker on 11/14/15.
//  Copyright © 2015 Mark Walker. All rights reserved.
//

import Cocoa

class vc_LoadGen4: NSViewController {

    var delegate:MWLoadCollectionDataSource?
    
    var a = MWBeamAnalysis()
    var newLoadCollection = [MWLoadData]()
    
    @IBOutlet weak var t_Spacing: MWTextField_NumberInput!
    @IBOutlet weak var t_DL: MWTextField_NumberInput!
    @IBOutlet weak var t_LL: MWTextField_NumberInput!
    
    var textViews = [MWTextField_NumberInput]()
    
    var deadLoadObject = MWLoadData()
    var liveLoadObject = MWLoadData()
    
    @IBOutlet weak var lbl_Load1: NSTextField!
    @IBOutlet weak var lbl_Load2: NSTextField!
    @IBOutlet weak var lbl_Notes: NSTextField!
    
    var dataIsGoodToAddLoads = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        textViews.append(t_Spacing)
        textViews.append(t_DL)
        textViews.append(t_LL)
        
        t_Spacing.stringValue = "16"
        t_DL.stringValue = "10.0"
        t_LL.stringValue = "40.0"
        
        let startText = "Not yet calculated"
        lbl_Load1.stringValue = startText
        lbl_Load2.stringValue = startText
        lbl_Notes.stringValue = ""
        
    }
    
    @IBAction func click_Generate(_ sender: AnyObject) {
        var inputError = false
        for i in 0...textViews.count-1{
            if textViews[i].isValid() == false{
                inputError = true
            }
        }
            if inputError == false{
                dataIsGoodToAddLoads = true
                
                let spacing = t_Spacing.doubleValue
                let dl = t_DL.doubleValue
                let ll = t_LL.doubleValue
                
                
                let uDL = dl * spacing / 12
                let uLL = ll * spacing / 12
                
                let rUDL = Double(round(1000 * uDL) / 1000)
                let rULL = Double(round(1000 * uLL) / 1000)
                
                deadLoadObject.addValues("Joist_FloorDL", theLoadValue: rUDL / 1000, theLoadType: "uniform", theLoadStart: 0, theLoadEnd: a.BeamGeo.length , theBeamGeo: a.BeamGeo)
                
                liveLoadObject.addValues("Joist_FloorLL", theLoadValue: rULL / 1000, theLoadType: "uniform", theLoadStart: 0, theLoadEnd: a.BeamGeo.length, theBeamGeo: a.BeamGeo)
                
                lbl_Load1.stringValue = "Calculated Dead Load = \(rUDL) plf (pounds per linear foot)"
                lbl_Load2.stringValue = "Calculated Live Load = \(rULL) plf (pounds per linear foot) "
            }else  if inputError == true{
                dataIsGoodToAddLoads = false
                
                let errorText = "Error check input"
                lbl_Load1.stringValue = errorText
                lbl_Load2.stringValue = errorText
                lbl_Notes.stringValue = ""
                
            }
        }
    
    
    @IBAction func click_AddLoad(_ sender: AnyObject) {
        click_Generate(sender)
        
        if dataIsGoodToAddLoads{
            self.a.loadCollection.append(deadLoadObject)
            self.a.loadCollection.append(liveLoadObject)
            
            if self.delegate != nil{
                delegate?.sendLoadCollection(a)
                dismiss(self)
            }
        }
    }

    @IBAction func click_ReplaceLoads(_ sender: AnyObject) {
        click_Generate(sender)
        
        if dataIsGoodToAddLoads{
            newLoadCollection.append(deadLoadObject)
            newLoadCollection.append(liveLoadObject)
            self.a.loadCollection = newLoadCollection
            
            if self.delegate != nil{
                delegate?.sendLoadCollection(a)
                dismiss(self)
            }
        }
    }
    
    
    @IBAction func click_Cancel(_ sender: AnyObject) {
        dismiss(self)
    }
    
}
