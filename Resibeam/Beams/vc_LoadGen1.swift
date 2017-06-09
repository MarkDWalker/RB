//
//  ViewController_LoadGen1.swift
//  BeamDesigner_V0.0.3
//
//  Created by Mark Walker on 9/8/15.
//  Copyright (c) 2015 Mark Walker. All rights reserved.
//

import Cocoa

class vc_LoadGen1: NSViewController {

    
    //MARK: Outlets
    @IBOutlet weak var txt_trussSpanVal: NSTextField!
    @IBOutlet weak var radio: NSMatrix!
    
    @IBOutlet weak var txt_TA: NSTextField!
    
    @IBOutlet weak var txt_RoofLiveLoad: NSTextField!
    @IBOutlet weak var txt_SnowLoad: NSTextField!
    @IBOutlet weak var txt_DeadLoad: NSTextField!
    
    @IBOutlet weak var sumtxt_RLL: NSTextField!
    
    @IBOutlet weak var sumtxt_RSL: NSTextField!
    
    @IBOutlet weak var sumtxt_RDL: NSTextField!
    
    //MARK: Public Vars
    var a:MWBeamAnalysis = MWBeamAnalysis()
    var delegate:MWLoadCollectionDataSource?
    
    
    //MARK: Private Vars
    fileprivate var trussSpanInput:Double = 0.0
    fileprivate var roofLiveLoad:Double = 0.0
    fileprivate var errorColor:NSColor = NSColor(calibratedRed: (253/255), green: (160/255), blue: (177/255), alpha: 1)
    fileprivate var dataIsGoodToAddLoads:Bool = false
    
    
    //MARK: Actions
    @IBAction func click_Chart(_ sender: NSButton) {
        let theSegueIdentifier:String = "RoofLiveLoadChart"
        self.performSegue(withIdentifier: theSegueIdentifier, sender: sender)
    }
    
    @IBAction func click_ViewMap(_ sender: NSButton) {
        let theSegueIdentifier:String = "SnowMap"
        self.performSegue(withIdentifier: theSegueIdentifier, sender: sender)
    }
    
    @IBAction func click_DLInfo(_ sender: NSButton) {
        let theSegueIdentifier:String = "RoofDLInfo"
        self.performSegue(withIdentifier: theSegueIdentifier, sender: sender)
    }
    
    @IBAction func change_TrussSpan(_ sender: NSTextField){
        geoChange()
    }
    
    @IBAction func click_Matrix(_ sender: NSMatrix) {
        geoChange()
    }
    
    @IBAction func change_RLL(_ sender: NSTextField) {
        
        //var anError:Bool = txtError(sender)
    }
    
    @IBAction func change_SL(_ sender: NSTextField) {
        //var anError:Bool = txtError(sender)
    }
    
    @IBAction func change_DL(_ sender: NSTextField) {
        //var anError:Bool = txtError(sender)
    }
    
    @IBAction func click_Generate(_ sender: NSButton) {
        //do the error checking
        var anyError:Bool = false
        if txtError(txt_trussSpanVal){
            anyError = true
        }
        
        if txtError(txt_RoofLiveLoad){
            anyError = true
        }
        
        if txtError(txt_SnowLoad){
            anyError = true
        }
        
        if txtError(txt_DeadLoad){
            anyError = true
        }
        
        if anyError == false{ //this calculates the actual beam loads
            sumtxt_RLL.stringValue = "\((trussSpanInput/2) * txt_RoofLiveLoad.doubleValue)"
            
            sumtxt_RSL.stringValue = "\((trussSpanInput/2) * txt_SnowLoad.doubleValue)"
            
            sumtxt_RDL.stringValue = "\((trussSpanInput/2) * txt_DeadLoad.doubleValue)"
            
            dataIsGoodToAddLoads = true
        }else{
            print("dont dismiss due to error")
            dataIsGoodToAddLoads = false
            
            let noGoodText = "Error check values"
            sumtxt_RLL.stringValue = noGoodText
            sumtxt_RSL.stringValue = noGoodText
            sumtxt_RDL.stringValue = noGoodText
            
        }
        
        
    }
    
    @IBAction func click_Cancel(_ sender: NSButton) {
        self.dismiss(self)
    }
    
    
    @IBAction func click_AddLoads(_ sender: NSButton) {
        
        click_Generate(sender)
        
        if dataIsGoodToAddLoads == true{
            //calculate the beam loads
            let rdl:Double = trussSpanInput * txt_DeadLoad.doubleValue / (2 * 1000)
            let rll:Double = trussSpanInput * txt_RoofLiveLoad.doubleValue / (2*1000)
            let rsl:Double = trussSpanInput * txt_SnowLoad.doubleValue / (2*1000)
            
            //create the 3 loads objects
            let deadLoad:MWLoadData = MWLoadData(theDescription: "Header_RoofDL", theLoadValue: rdl, theLoadType: "uniform", theLoadStart: 0, theLoadEnd: a.BeamGeo.length, theBeamGeo: a.BeamGeo, theLoadValue2: 0)
            
            let liveLoad:MWLoadData = MWLoadData(theDescription: "Header_RoofLL", theLoadValue: rll, theLoadType: "uniform", theLoadStart: 0, theLoadEnd: a.BeamGeo.length, theBeamGeo: a.BeamGeo, theLoadValue2: 0)
            
            let snowLoad:MWLoadData = MWLoadData(theDescription: "Header_RoofSL", theLoadValue: rsl, theLoadType: "uniform", theLoadStart: 0, theLoadEnd: a.BeamGeo.length, theBeamGeo: a.BeamGeo, theLoadValue2: 0)
            
            
            a.appendLoadCollection(deadLoad)
            if rll>=rsl{
                a.appendLoadCollection(liveLoad)
            }else{
                a.appendLoadCollection(snowLoad)
            }
            
            if self.delegate != nil{
                delegate?.sendLoadCollection(a)
                dismiss(self)
            }
            
        }else{
            //do nothing
        }
        
    }
    
    @IBAction func click_ReplaceLoad(_ sender: NSButton) {
        click_Generate(sender)
        
        if dataIsGoodToAddLoads == true{
            //calculate the beam loads
            let rdl:Double = trussSpanInput * txt_DeadLoad.doubleValue / (2 * 1000)
            let rll:Double = trussSpanInput * txt_RoofLiveLoad.doubleValue / (2*1000)
            let rsl:Double = trussSpanInput * txt_SnowLoad.doubleValue / (2*1000)
            
            var newLoadCollection:[MWLoadData] = [MWLoadData]()
            
            
            //create the 3 loads objects
            let deadLoad:MWLoadData = MWLoadData(theDescription: "Header_RoofDL", theLoadValue: rdl, theLoadType: "uniform", theLoadStart: 0, theLoadEnd: a.BeamGeo.length, theBeamGeo: a.BeamGeo, theLoadValue2: 0)
            
            let liveLoad:MWLoadData = MWLoadData(theDescription: "Header_RoofLL", theLoadValue: rll, theLoadType: "uniform", theLoadStart: 0, theLoadEnd: a.BeamGeo.length, theBeamGeo: a.BeamGeo, theLoadValue2: 0)
            
            let snowLoad:MWLoadData = MWLoadData(theDescription: "Header_RoofSL", theLoadValue: rsl, theLoadType: "uniform", theLoadStart: 0, theLoadEnd: a.BeamGeo.length, theBeamGeo: a.BeamGeo, theLoadValue2: 0)
            
            
            newLoadCollection.append(deadLoad)
            if rll>=rsl{
                newLoadCollection.append(liveLoad)
            }else{
                newLoadCollection.append(snowLoad)
            }
            
            a.loadCollection = newLoadCollection
            
            if self.delegate != nil{
                delegate?.sendLoadCollection(a)
                dismiss(self)
            }
            
        }else{
            //do nothing
        }
        
    }
    
    
    
    //MARK: NSViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        txt_trussSpanVal.stringValue = "Input"
        txt_RoofLiveLoad.stringValue = "Calc"
        txt_SnowLoad.stringValue = "Input"
        txt_DeadLoad.stringValue = "Input"
        
        let initText = "Not yet Calculated"
        sumtxt_RLL.stringValue = initText
        sumtxt_RSL.stringValue = initText
        sumtxt_RLL.stringValue = initText
        
    }
    
    
    
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        
    if identifier == "RoofLiveLoadChart"{
        let VC_RoofLiveLoadChart = self.storyboard?.instantiateController(withIdentifier: "RoofLiveLoadChart") as! vc_RoofLiveLoadChart
        
        self.presentViewControllerAsModalWindow(VC_RoofLiveLoadChart)
        }else if identifier == "SnowMap"{
            let VC_SnowMap = self.storyboard?.instantiateController(withIdentifier: "SnowMap") as! vc_SnowMap
            
            self.presentViewControllerAsModalWindow(VC_SnowMap)
        }else if identifier == "RoofDLInfo"{
        let VC_RoofDLInfo = self.storyboard?.instantiateController(withIdentifier: "RoofDLInfo") as! vc_RoofDLInfo
        self.presentViewControllerAsModalWindow(VC_RoofDLInfo)
        }
        
    }
        
    
    //MARK: Utility Functions
    fileprivate func geoChange(){
        //check to make sure there is a valid value
        if txtError(txt_trussSpanVal){
            //we have an error
            
        }else if txt_trussSpanVal.doubleValue <= 0{
            //we have another error
            
        }else{
            //we should be good
            //first calculate the tributary area of the beam
            trussSpanInput = txt_trussSpanVal.doubleValue
            let ta:Double = a.BeamGeo.length * trussSpanInput
            txt_TA.stringValue = "\(ta)"
            if radio.selectedRow == 0{
                if ta <= 200.00{
                    roofLiveLoad = 20.0
                }else if ta > 200.0 && ta <= 600.0{
                    roofLiveLoad = 16.0
                }else if ta > 600.0{
                    roofLiveLoad = 12.0
                }
                
            }else if radio.selectedRow == 1{
                if ta <= 200.00{
                    roofLiveLoad = 16.0
                }else if ta > 200.0 && ta <= 600.0{
                    roofLiveLoad = 14.0
                }else if ta > 600.0{
                    roofLiveLoad = 12.0
                }
            }else if radio.selectedRow == 2{
                if ta <= 200.00{
                    roofLiveLoad = 12.0
                }else if ta > 200.0 && ta <= 600.0{
                    roofLiveLoad = 12.0
                }else if ta > 600.0{
                    roofLiveLoad = 12.0
                }
            }//end radio if
            
            txt_RoofLiveLoad.stringValue = "\(roofLiveLoad)"
            txt_trussSpanVal.backgroundColor = NSColor.white
            txt_RoofLiveLoad.backgroundColor = NSColor.white
            
        }//end error if
    }
    
    fileprivate func txtError(_ field:NSTextField)->Bool{
        var returnVal:Bool = false
        
        if field.doubleValue == 0 && field.stringValue != "0"{
            returnVal = true
        }
        
        if returnVal == true{
            field.backgroundColor = errorColor
        }else{
            field.backgroundColor = NSColor.white
        }
        
        return returnVal
    }
   
    
    
}
