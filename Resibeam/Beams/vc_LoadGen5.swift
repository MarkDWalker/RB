//
//  ViewController_LoadGen5.swift
//  BeamDesigner_V0.0.4
//
//  Created by Mark Walker on 11/15/15.
//  Copyright © 2015 Mark Walker. All rights reserved.
//

import Cocoa

class vc_LoadGen5: NSViewController {
    
    var a = MWBeamAnalysis()
    var delegate:MWLoadCollectionDataSource?
    
    
    @IBOutlet weak var storyButton1: NSButton!
    @IBOutlet weak var storyButton2: NSButton!
    
    @IBOutlet weak var text_A: MWTextField_NumberInput!
    @IBOutlet weak var text_B: MWTextField_NumberInput!
    @IBOutlet weak var text_DL: MWTextField_NumberInput!
    @IBOutlet weak var text_LL: MWTextField_NumberInput!
    
    @IBOutlet weak var imageMain: NSImageView!
    
    var DL_Object = MWLoadData()
    var LL_Object = MWLoadData()
    
    @IBOutlet weak var text_BeamLoad1: NSTextField!
    @IBOutlet weak var text_BeamLoad2: NSTextField!
    
   var textViews = [MWTextField_NumberInput]()
    var newLoadCollection = [MWLoadData]()
    
    var dataIsGoodToAddLoads = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        textViews.append(text_A)
        textViews.append(text_B)
        textViews.append(text_DL)
        textViews.append(text_LL)
        
        text_DL.stringValue = "10"
        text_LL.stringValue = "40"
        
        let startText = "Not Yet Calculated"
        text_BeamLoad1.stringValue = startText
        text_BeamLoad2.stringValue = startText
    }
    
    @IBAction func generate_Click(_ sender: AnyObject) {
       
        var inputError = false
        for i in 0...textViews.count-1{
            if textViews[i].isValid() == false{
                inputError = true
            }
        }
        
        if inputError == false{
            
            dataIsGoodToAddLoads = true
            
            let spanA = text_A.doubleValue
            let spanB = text_B.doubleValue
            let dl = text_DL.doubleValue
            let ll = text_LL.doubleValue
            
            var uDL = (spanA/2 + spanB/2) * dl
            var uLL = (spanA/2 + spanB/2) * ll
            
            if (storyButton2.state == 1){
                uDL *= 2
                uLL *= 2
            }
            
            DL_Object.addValues("Beam_DL", theLoadValue: uDL/1000, theLoadType: "uniform", theLoadStart: 0, theLoadEnd: a.BeamGeo.length, theBeamGeo: a.BeamGeo)
            
            LL_Object.addValues(("Beam_LL"), theLoadValue: uLL/1000, theLoadType: "uniform", theLoadStart: 0, theLoadEnd: a.BeamGeo.length, theBeamGeo: a.BeamGeo)
            
            text_BeamLoad1.stringValue = "Uniform live load = \(uLL) plf"
            
            text_BeamLoad2.stringValue = "Uniform dead load = \(uDL) plf"
        }else{
            
            dataIsGoodToAddLoads = false
            let errorText = "Error check input"
            text_BeamLoad1.stringValue = errorText
            text_BeamLoad2.stringValue = errorText
        }
        
    }
    
    
    @IBAction func addLoads_Click(_ sender: AnyObject) {
        generate_Click(sender)
        
        if dataIsGoodToAddLoads {
            self.a.loadCollection.append(DL_Object)
            self.a.loadCollection.append(LL_Object)
            
            if self.delegate != nil{
                delegate?.sendLoadCollection(a)
                dismiss(self)
            }
        }
    }
    
    
    @IBAction func replaceLoads_Click(_ sender: AnyObject) {
        generate_Click(sender)
        
        if dataIsGoodToAddLoads {
            newLoadCollection.append(DL_Object)
            newLoadCollection.append(LL_Object)
            self.a.loadCollection = newLoadCollection
            
            if self.delegate != nil{
                delegate?.sendLoadCollection(a)
                dismiss(self)
            }
        }
    }
    
    @IBAction func storyButton1_Click(_ sender: AnyObject) {
        storyButton2.state = 0
        
    }
    
    @IBAction func storyButton2_Click(_ sender: AnyObject) {
        storyButton1.state = 0
    }
    
    
    @IBAction func sectionView_Click(_ sender: AnyObject) {
        imageMain.image = NSImage(named: "E_Section.png")
    }
    
    @IBAction func elevationView_Click(_ sender: AnyObject) {
        imageMain.image = NSImage(named: "E_Elevation.png")
    }
    
    @IBAction func planView_Click(_ sender: AnyObject) {
     imageMain.image = NSImage(named: "E_Main.png")
    }
    
    @IBAction func cancel_Click(_ sender: AnyObject) {
        self.dismiss(self)
    }
   
}

