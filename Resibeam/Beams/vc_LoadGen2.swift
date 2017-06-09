//
//  ViewController_LoadGen2.swift
//  
//
//  Created by Mark Walker on 9/15/15.
//
//

import Cocoa

class vc_LoadGen2: NSViewController {

    //MARK: Outlets
    @IBOutlet weak var txt_trussSpanVal: NSTextField!
    @IBOutlet weak var txt_roofTA: NSTextField!
    
    @IBOutlet weak var radio: NSMatrix!
    
    @IBOutlet weak var txt_floorSpanVal: NSTextField!

    
    @IBOutlet weak var txt_roofLiveLoad: NSTextField!
    @IBOutlet weak var txt_snowLoad: NSTextField!
    @IBOutlet weak var txt_roofDeadLoad: NSTextField!
    
    @IBOutlet weak var txt_floorLiveLoad: NSTextField!
    @IBOutlet weak var txt_floorDeadLoad: NSTextField!
    
    
    @IBOutlet weak var sumtxt_RLL: NSTextField!
    
    @IBOutlet weak var sumtxt_RSL: NSTextField!
    
    @IBOutlet weak var sumtxt_RDL: NSTextField!
    
    @IBOutlet weak var sumtxt_FLL: NSTextField!
    
    @IBOutlet weak var sumtxt_FDL: NSTextField!
    
    
    //MARK: Public Vars
    var a = MWBeamAnalysis()
    var delegate:MWLoadCollectionDataSource?
    
    //MARK: Private Vars
    var trussSpanInput:Double = 0.0
    var floorSpanInput:Double = 0.0
    var roofLiveLoad:Double = 0.0
    
    var errorColor = NSColor(calibratedRed: (253/255), green: (160/255), blue: (177/255), alpha: 1)
    var dataIsGoodToAddLoads = false
    
    
    
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
    

    @IBAction func click_FloorLLInfo(_ sender: NSButton) {
        let theSegueIdentifier:String = "FloorLLInfo"
        self.performSegue(withIdentifier: theSegueIdentifier, sender: sender)
    }
    
    
    @IBAction func change_TrussSpan(_ sender: NSTextField){
        trussSpanChange()
    }
    
    @IBAction func click_Matrix(_ sender: NSMatrix) {
        trussSpanChange()
    }
    
    @IBAction func change_FloorJoistSpan(_ sender: NSTextField) {
        floorJoistSpanChange()
    }
    
    @IBAction func click_Generate(_ sender: NSButton) {
        //do the error checking
        var anyError = false
        if txtError(txt_trussSpanVal){
            anyError = true
        }
        
        if txtError(txt_floorSpanVal){
            anyError = true
        }
        
        if txtError(txt_roofLiveLoad){
            anyError = true
        }
        
        if txtError(txt_snowLoad){
            anyError = true
        }
        
        if txtError(txt_roofDeadLoad){
            anyError = true
        }
        
        if txtError(txt_floorLiveLoad){
            anyError = true
        }
        
        if txtError(txt_floorDeadLoad){
            anyError = true
        }
        
        if anyError == false{ //this calculates the actual beam loads
            sumtxt_RLL.stringValue = "\((trussSpanInput/2) * txt_roofLiveLoad.doubleValue)"
            
            sumtxt_RSL.stringValue = "\((trussSpanInput/2) * txt_snowLoad.doubleValue)"
            
            sumtxt_RDL.stringValue = "\((trussSpanInput/2) * txt_roofDeadLoad.doubleValue)"
            
            sumtxt_FLL.stringValue = "\((floorSpanInput/2) * txt_floorLiveLoad.doubleValue)"
            
            sumtxt_FDL.stringValue = "\((floorSpanInput/2) * txt_floorDeadLoad.doubleValue)"
            
            dataIsGoodToAddLoads = true
        }else{
            print("dont dismiss due to error")
            dataIsGoodToAddLoads = false
            let noGoodText = "Error check values"
            sumtxt_RLL.stringValue = noGoodText
            sumtxt_RSL.stringValue = noGoodText
            sumtxt_RDL.stringValue = noGoodText
            sumtxt_FLL.stringValue = noGoodText
            sumtxt_FDL.stringValue = noGoodText
            
        }
        
        
    }
    
    
    @IBAction func click_Cancel(_ sender: NSButton) {
        self.dismiss(self)
    }
    
    
    @IBAction func click_AddLoads(_ sender: NSButton) {
        click_Generate(sender)
        
        if dataIsGoodToAddLoads == true{
            //calculate the beam loads
            let rdl : Double = trussSpanInput * txt_roofDeadLoad.doubleValue / (2 * 1000)
            let rll : Double = trussSpanInput * txt_roofLiveLoad.doubleValue / (2 * 1000)
            let rsl : Double = trussSpanInput * txt_snowLoad.doubleValue / (2 * 1000)
            
            let fll : Double = floorSpanInput * txt_floorLiveLoad.doubleValue / (2 * 1000)
            let fdl : Double = floorSpanInput * txt_floorDeadLoad.doubleValue / (2 * 1000)
            
            //create the 5 loads objects
            let roofDeadLoad = MWLoadData(theDescription: "Con2_RoofDL", theLoadValue: rdl, theLoadType: "uniform", theLoadStart: 0, theLoadEnd: a.BeamGeo.length, theBeamGeo: a.BeamGeo, theLoadValue2: 0)
            
            let roofLiveLoad = MWLoadData(theDescription: "Con2_RoofLL", theLoadValue: rll, theLoadType: "uniform", theLoadStart: 0, theLoadEnd: a.BeamGeo.length, theBeamGeo: a.BeamGeo, theLoadValue2: 0)
            
            let snowLoad = MWLoadData(theDescription: "Con2_RoofSL", theLoadValue: rsl, theLoadType: "uniform", theLoadStart: 0, theLoadEnd: a.BeamGeo.length, theBeamGeo: a.BeamGeo, theLoadValue2: 0)
            
            let floorLiveLoad = MWLoadData(theDescription: "Con2_FloorLL", theLoadValue: fll, theLoadType: "uniform", theLoadStart: 0, theLoadEnd: a.BeamGeo.length, theBeamGeo: a.BeamGeo, theLoadValue2: 0)
            
            let floorDeadLoad = MWLoadData(theDescription: "Con2_FloorDL", theLoadValue: fdl, theLoadType: "uniform", theLoadStart: 0, theLoadEnd: a.BeamGeo.length, theBeamGeo: a.BeamGeo, theLoadValue2: 0)
            
            
            a.appendLoadCollection(roofDeadLoad)
            if rll>=rsl{
                a.appendLoadCollection(roofLiveLoad)
            }else{
                a.appendLoadCollection(snowLoad)
            }
            
            a.appendLoadCollection(floorLiveLoad)
            a.appendLoadCollection(floorDeadLoad)
            
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
            let rdl : Double = trussSpanInput * txt_roofDeadLoad.doubleValue / (2 * 1000)
            let rll : Double = trussSpanInput * txt_roofLiveLoad.doubleValue / (2*1000)
            let rsl : Double = trussSpanInput * txt_snowLoad.doubleValue / (2*1000)
            
            let fll : Double = floorSpanInput * txt_floorLiveLoad.doubleValue / (2*1000)
            let fdl : Double = floorSpanInput * txt_floorDeadLoad.doubleValue / (2*1000)
            
            var newLoadCollection:[MWLoadData] = [MWLoadData]()
            
            
            //create the 5 loads objects
            let roofDeadLoad = MWLoadData(theDescription: "Header_RoofDL", theLoadValue: rdl, theLoadType: "uniform", theLoadStart: 0, theLoadEnd: a.BeamGeo.length, theBeamGeo: a.BeamGeo, theLoadValue2: 0)
            
            let roofLiveLoad = MWLoadData(theDescription: "Header_RoofLL", theLoadValue: rll, theLoadType: "uniform", theLoadStart: 0, theLoadEnd: a.BeamGeo.length, theBeamGeo: a.BeamGeo, theLoadValue2: 0)
            
            let snowLoad = MWLoadData(theDescription: "Header_RoofSL", theLoadValue: rsl, theLoadType: "uniform", theLoadStart: 0, theLoadEnd: a.BeamGeo.length, theBeamGeo: a.BeamGeo, theLoadValue2: 0)
            
            let floorLiveLoad = MWLoadData(theDescription: "Header_FloorLL", theLoadValue: fll, theLoadType: "uniform", theLoadStart: 0, theLoadEnd: a.BeamGeo.length, theBeamGeo: a.BeamGeo, theLoadValue2: 0)
            
            let floorDeadLoad = MWLoadData(theDescription: "Header_FloorDL", theLoadValue: fdl, theLoadType: "uniform", theLoadStart: 0, theLoadEnd: a.BeamGeo.length, theBeamGeo: a.BeamGeo, theLoadValue2: 0)
            
            newLoadCollection.append(roofDeadLoad)
            if rll>=rsl{
                newLoadCollection.append(roofLiveLoad)
            }else{
                newLoadCollection.append(snowLoad)
            }
            
            newLoadCollection.append(floorLiveLoad)
            newLoadCollection.append(floorDeadLoad)
            
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
        txt_floorSpanVal.stringValue = "Input"
        txt_roofLiveLoad.stringValue = "Calc"
        txt_snowLoad.stringValue = "Input"
        txt_roofDeadLoad.stringValue = "15"
        txt_floorLiveLoad.stringValue = "40"
        txt_floorDeadLoad.stringValue = "10"
        
        
        let initText = "Not yet Calculated"
        sumtxt_RLL.stringValue = initText
        sumtxt_RSL.stringValue = initText
        sumtxt_RLL.stringValue = initText
        sumtxt_FLL.stringValue = initText
        sumtxt_FDL.stringValue = initText
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
            
        }else if identifier == "FloorLLInfo"{
            let VC_FloorLLInfo = self.storyboard?.instantiateController(withIdentifier: "FloorLLInfo") as! vc_FloorLLInfo
            self.presentViewControllerAsModalWindow(VC_FloorLLInfo)
        }
        
    }
    
    
  
  //MARK: Utility Functions
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
    

    
    
    fileprivate func trussSpanChange(){
        //check to make sure there is a valid value
        if txtError(txt_trussSpanVal) {
            //we have an error
            txt_roofTA.stringValue = "not yet calculated"
        }else if txt_trussSpanVal.doubleValue <= 0 {
            //we have another error
            txt_roofTA.stringValue = "not yet calculated"
        }else{
            //we should be good
            //first calculate the tributary area of the beam
            trussSpanInput = txt_trussSpanVal.doubleValue
            let roofTA:Double = a.BeamGeo.length * trussSpanInput / 2
            txt_roofTA.stringValue = "\(roofTA)"
            if radio.selectedRow == 0{
                if roofTA <= 200.00{
                    roofLiveLoad = 20.0
                }else if roofTA > 200.0 && roofTA <= 600.0{
                    roofLiveLoad = 16.0
                }else if roofTA > 600.0{
                    roofLiveLoad = 12.0
                }
                
            }else if radio.selectedRow == 1{
                if roofTA <= 200.00{
                    roofLiveLoad = 16.0
                }else if roofTA > 200.0 && roofTA <= 600.0{
                    roofLiveLoad = 14.0
                }else if roofTA > 600.0{
                    roofLiveLoad = 12.0
                }
            }else if radio.selectedRow == 2{
                if roofTA <= 200.00{
                    roofLiveLoad = 12.0
                }else if roofTA > 200.0 && roofTA <= 600.0{
                    roofLiveLoad = 12.0
                }else if roofTA > 600.0{
                    roofLiveLoad = 12.0
                }
            }//end radio if
            txt_roofLiveLoad.stringValue = "\(roofLiveLoad)"
            txt_trussSpanVal.backgroundColor = NSColor.white
            txt_roofLiveLoad.backgroundColor = NSColor.white
            
        }//end error if
    }

    func floorJoistSpanChange(){
        if txtError(txt_floorSpanVal){
            //we have an error
        }else if txt_floorSpanVal.doubleValue < 0 {
            //we have an error
        }else{
//            var floorJoistSpanInput:Double = txt_floorSpanVal.doubleValue
//            var floorJoistTA:Double = a.BeamGeo.length * floorJoistSpanInput / 2
//            
//            txt_floorTA.stringValue = "\(floorJoistTA)"
            
            floorSpanInput = txt_floorSpanVal.doubleValue
            txt_floorSpanVal.backgroundColor = NSColor.white
        }//end if
        
        
    }
    
    
    
    
}
