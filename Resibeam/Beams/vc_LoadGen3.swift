//
//  ViewController_LoadGen3.swift
//  BeamDesigner_V0.0.4
//
//  Created by Mark Walker on 10/17/15.
//  Copyright © 2015 Mark Walker. All rights reserved.
//

import Cocoa

class vc_LoadGen3: NSViewController {

    //MARK: Public Vars
    var a:MWBeamAnalysis = MWBeamAnalysis()
    var delegate:MWLoadCollectionDataSource?
    
    @IBOutlet weak var txt_Load1Output: NSTextField!
    @IBOutlet weak var txt_Load2Output: NSTextField!
    @IBOutlet weak var txt_LoadOutputNotes: NSTextField!
    
    @IBOutlet weak var txt_A: MWTextField_NumberInput!
    @IBOutlet weak var txt_B: MWTextField_NumberInput!
    @IBOutlet weak var txt_C: MWTextField_NumberInput!
    @IBOutlet weak var txt_D: MWTextField_NumberInput!
    
    @IBOutlet weak var txt_BrickWeight: MWTextField_NumberInput!
    
    
    var textFields = [MWTextField_NumberInput]()
    
    @IBOutlet weak var theMaxtrix: NSMatrix!
    
    var theLintelCondition = LintelConditionEnum.noOpeningAbove
    
    @IBOutlet weak var myImageView: NSImageView!
    
    let noOpeningAboveLoad:MWLoadData = MWLoadData()
    let archActionLoad1:MWLoadData = MWLoadData()
    let archActionLoad2:MWLoadData = MWLoadData()
    let openingAlignedAboveLoad:MWLoadData = MWLoadData()
    let narrowerAndOffsetAboveLoad:MWLoadData = MWLoadData()
    var archActionWarranted:Bool = false
    var newLoadCollection = [MWLoadData]()
    
    var dataIsGoodToAddLoads = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        textFields.append(txt_A)
        textFields.append(txt_B)
        textFields.append(txt_C)
        textFields.append(txt_D)
        textFields.append(txt_BrickWeight)
        
        txt_BrickWeight.stringValue = "39.0"
        
        theMaxtrix.selectCell(atRow: 2, column: 0)
        
        let startText = "Not Yet Calculated"
        txt_Load1Output.stringValue = startText
        txt_Load2Output.stringValue = startText
        txt_LoadOutputNotes.stringValue = ""
        
    }
    
    @IBAction func click_Matrix(_ sender: NSMatrix) {
        
        if sender.selectedTag() == 0{
            myImageView.image = NSImage(named: "C_NothingAbove.png")!
            txt_C.isEnabled = false
            txt_C.stringValue = txt_D.stringValue
            txt_C.resignFirstResponder()
            theLintelCondition = LintelConditionEnum.noOpeningAbove
        }else if sender.selectedTag() == 1{
            myImageView.image = NSImage(named: "C_AlignedAbove.png")!
            txt_C.isEnabled = true
            theLintelCondition = LintelConditionEnum.alignedOpeningAbove
        }else if sender.selectedTag() == 2{
            myImageView.image = NSImage(named: "C_NarrowerAbove.png")!
            txt_C.isEnabled = true
            theLintelCondition = LintelConditionEnum.narrowerOpeningAbove
        }else if sender.selectedTag() == 3{
            myImageView.image = NSImage(named: "C_OffsetAbove.png")!
            txt_C.isEnabled = true
            theLintelCondition = LintelConditionEnum.offsetOpeningAbove
        }
    }
    
    
    
    @IBAction func txt_DChanged(_ sender: MWTextField_NumberInput) {
        
        if theMaxtrix.selectedTag() == 0{
            txt_C.stringValue = txt_D.stringValue
        }
    }
    
    
    @IBAction func click_Generate(_ sender: AnyObject) {
        var inputError = false
        for i in 0...textFields.count-1{
            if textFields[i].isValid() == false{
                inputError = true
            }
        }
        
        if inputError == false{
            
            dataIsGoodToAddLoads = true
            
            let span : Double = a.BeamGeo.length
            let A : Double = txt_A.doubleValue
            let B : Double = txt_B.doubleValue
            let C : Double = txt_C.doubleValue
            let D : Double = txt_D.doubleValue
            
            let brickWeight : Double = txt_BrickWeight.doubleValue
            let archActionLoadValue : Double = brickWeight * C
            let alignedAboveLoadValue : Double = brickWeight * C
            let narrowerAndOffsetLoadValue : Double = brickWeight * D
            let noOpeningAboveLoadValue : Double = brickWeight * D
            
            
            
            noOpeningAboveLoad.addValues("lintel_UniformLoad", theLoadValue: noOpeningAboveLoadValue/1000, theLoadType: "uniform", theLoadStart: 0, theLoadEnd: span, theBeamGeo: a.BeamGeo)
            
            archActionLoad1.addValues("Lintel_archAction_1", theLoadValue: 0, theLoadType: "linearup", theLoadStart: 0, theLoadEnd: span/2, theBeamGeo: a.BeamGeo)
            archActionLoad1.loadValue2 = archActionLoadValue/1000
            
            archActionLoad2.addValues("Lintel_archAction_2", theLoadValue: archActionLoadValue/1000, theLoadType: "lineardown", theLoadStart: span/2, theLoadEnd: span, theBeamGeo: a.BeamGeo)
            
            openingAlignedAboveLoad.addValues("lintel_UniformLoad", theLoadValue: alignedAboveLoadValue/1000, theLoadType: "uniform", theLoadStart: 0, theLoadEnd: span, theBeamGeo: a.BeamGeo)
            
            narrowerAndOffsetAboveLoad.addValues("lintel_UniformLoad", theLoadValue: narrowerAndOffsetLoadValue/1000, theLoadType: "uniform", theLoadStart: 0, theLoadEnd: span, theBeamGeo: a.BeamGeo)
            
            newLoadCollection.removeAll()
            
            if C >= span && A >= span && B >= span{
              archActionWarranted = true
            }
            
            if archActionWarranted == true{
                txt_Load1Output.stringValue = "Increasing, location:0-\(span/2)', value:0-\(archActionLoadValue) plf"
                txt_Load2Output.stringValue = "Decreasing, location:\(span/2)-\(span)', value:\(archActionLoadValue)-0 plf"
                txt_LoadOutputNotes.stringValue = "Load based upon arch action"
                
                newLoadCollection.append(archActionLoad1)
                newLoadCollection.append(archActionLoad2)
            }else{
                if theLintelCondition == LintelConditionEnum.noOpeningAbove{
                    txt_Load1Output.stringValue = "uniform load, full beam length - \(noOpeningAboveLoadValue) plf"
                    txt_Load2Output.stringValue = "not used"
                    txt_LoadOutputNotes.stringValue = "weight of brick above"
                    newLoadCollection.append(noOpeningAboveLoad)
                    
                }else if theLintelCondition == LintelConditionEnum.alignedOpeningAbove{
                    
                    txt_Load1Output.stringValue = "uniform load, full beam length - \(noOpeningAboveLoadValue) plf"
                    txt_Load2Output.stringValue = "not used"
                    txt_LoadOutputNotes.stringValue = "weight of brick above"
                    newLoadCollection.append(openingAlignedAboveLoad)
                    
                }else if theLintelCondition == LintelConditionEnum.narrowerOpeningAbove{
                    txt_Load1Output.stringValue = "uniform load, full beam length - \(narrowerAndOffsetLoadValue) plf"
                    txt_Load2Output.stringValue = "not used"
                    txt_LoadOutputNotes.stringValue = "weight of brick above"
                    newLoadCollection.append(narrowerAndOffsetAboveLoad)
                    
                }else if theLintelCondition == LintelConditionEnum.offsetOpeningAbove{
                    txt_Load1Output.stringValue = "uniform load, full beam length - \(narrowerAndOffsetLoadValue) plf"
                    txt_Load2Output.stringValue = "not used"
                    txt_LoadOutputNotes.stringValue = "weight of brick above"
                    newLoadCollection.append(narrowerAndOffsetAboveLoad)
                }
            
            }
            
            
        } else if inputError == true{
            
            dataIsGoodToAddLoads = false
            
            let errorText = "Error check input"
            txt_Load1Output.stringValue = errorText
            txt_Load2Output.stringValue = errorText
            txt_LoadOutputNotes.stringValue = ""
        }
        
    }
    
    
    
    @IBAction func click_Cancel(_ sender: AnyObject) {
        
        self.dismiss(self)
    }
    
    
    @IBAction func click_AddLoad(_ sender: AnyObject) {
        click_Generate(sender)
        
        if dataIsGoodToAddLoads{
            
            for i in 0...newLoadCollection.count-1 {
                self.a.loadCollection.append(newLoadCollection[i])
            }
            
            if self.delegate != nil{
                delegate?.sendLoadCollection(a)
                dismiss(self)
            }
        }
    }
    
    @IBAction func click_ReplaceLoads(_ sender: AnyObject) {
        click_Generate(sender)
        
        if dataIsGoodToAddLoads{
            a.loadCollection = self.newLoadCollection
            
            if self.delegate != nil{
                delegate?.sendLoadCollection(a)
                dismiss(self)
            }
        }
    }
    
}//end class
