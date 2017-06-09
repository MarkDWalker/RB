//
//  vc_WBeamDesignPanel.swift
//  ResiBeam_V0.0.7
//
//  Created by Mark Walker on 8/21/16.
//  Copyright © 2016 Mark Walker. All rights reserved.
//

import Cocoa

class vc_SteelWBeamDesignPanel: NSViewController, NSTableViewDataSource, NSTableViewDelegate, FSFbMatrixSelectDelegate, FSFvMatrixSelectDelegate  {

    var delegate:beamDataDelegate?
    var statusDelegate:statusBarDelegate?
    
    @IBOutlet weak var sectionTableView: NSTableView!
    @IBOutlet weak var gradeTableView: NSTableView!
    @IBOutlet weak var adjustmentTableView: NSTableView!
    @IBOutlet weak var resultsTableView: NSTableView!
    
    //var a = MWBeamAnalysis() //this is set from the left panel data
    
    var design = MWSteelWBeamDesign()
    
    
    fileprivate var statusColor:NSColor = NSColor.green
    fileprivate var statusString:String = ""
    
    
    var shouldUpdateSaveDocOnSelectionChange:Bool = false
    var selectionTriggeredFromSelection:Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
    }
    
    
    override func viewWillAppear() {
        delegate?.updateSaveDocWithSelectedDesignTabIndex(selectedTabIndex: 2)
        updateStatus()
    }
    
    override func viewDidLayout() {
        delegate?.updateSaveDocWithSelectedDesignTabIndex(selectedTabIndex: 2)
        updateStatus()
    }
    
    
    
    
    
    func updateViews(){
        //selects the correct section in the tableview
        var rowForSectionTable:Int = -1
        var counter = 0
        repeat{   //repeat loop for first table
            let tableString = (sectionTableView.view(atColumn: 0, row: counter, makeIfNecessary: true) as! NSTableCellView).textField!.stringValue
            let savedShapeString = design.a.selectedSteelWSection.shape as String
            if savedShapeString == tableString{
                rowForSectionTable = counter
            }
            counter+=1
            
        }while rowForSectionTable == -1 && counter < sectionTableView.numberOfRows //todo Check for error if last beam is selected
        Swift.print("before sectionTableView selection func UpdateViews() --grade: \(design.a.selectedSteelWDesignValues.limits.grade.rawValue)")
        sectionTableView.selectRowIndexes(IndexSet(integer: rowForSectionTable), byExtendingSelection: false)
        sectionTableView.scrollRowToVisible(rowForSectionTable)
        //end selects section in tableview
        
        
        
        //selects the correct grade in tableview
        var rowForGradeTable:Int = -1
        counter = 0
        let gradeTableRowCount = gradeTableView.numberOfRows
        
        
        repeat{   //repeat loop for second table
            
            let tableGradeString = (gradeTableView.view(atColumn: 0, row: counter, makeIfNecessary: true) as! NSTableCellView).textField!.stringValue
            let savedGradeString = design.a.selectedSteelWDesignValues.limits.grade.rawValue
            
            
            
            
            if savedGradeString == tableGradeString {
                
                rowForGradeTable = counter
               
            }
            
            counter+=1
            
        }while rowForGradeTable == -1 && counter < gradeTableRowCount //todo Check for error if last beam is selected
        
        gradeTableView.selectRowIndexes(IndexSet(integer: rowForGradeTable), byExtendingSelection: false)
        gradeTableView.scrollRowToVisible(rowForGradeTable)
        ///end selects the correct grade in tableview
        
        
        
        //update the tables
        resultsTableView.reloadData()
        adjustmentTableView.reloadData()
        
        Swift.print("It made it")
        
        //updateStatus()
        //update the save doc
        //send the the first analysis object back to the split view to update the savedata for saving
        //self.doc.saveData[0] = design.a
        
        
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "BeamCalculations"{
            let vc_Calcs = segue.destinationController as! vc_Calculations
            
            vc_Calcs.steelWBeamDesign = self.design
            vc_Calcs.calcType = "SteelW"
        }
        
    }
    
    
    //MARK: TableView Functions
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        
        
        if selectionTriggeredFromSelection == false{
            let table = notification.object as! NSTableView
            
            guard table.selectedRow != -1 else{
                return
            }
            
            if table.identifier == "0"{
                design.a.selectedSteelWSection.setSectionData(table.selectedRow)
                let existingRowSelected = gradeTableView.selectedRow
                gradeTableView.reloadData()
                
                selectionTriggeredFromSelection = true
                if existingRowSelected == -1{
                    gradeTableView.selectRowIndexes(IndexSet(integer: 7), byExtendingSelection: false)
                    gradeTableView.scrollRowToVisible(7)
                }else{
                    gradeTableView.selectRowIndexes(IndexSet(integer:existingRowSelected) , byExtendingSelection: false)
                    gradeTableView.scrollRowToVisible(existingRowSelected)
                }
                
                //take the user selection update the model and save data
                design.a.selectedSteelWDesignValues.setValues(design.a.selectedSteelWDesignValues.limits.grade)
                design.updateDesignSectionCollections()
                
                //update the tables
                resultsTableView.reloadData()
                adjustmentTableView.reloadData()
                
                if delegate != nil && shouldUpdateSaveDocOnSelectionChange == true{
                    delegate?.updateSaveDocWithSteelWDesignChange(design.a.selectedSteelWSection, designValues: design.a.selectedSteelWDesignValues)
                }
                //end take the user selection update the model and save data
                
            }else if table.identifier == "1"{
                var gradeToSet = steelGradeEnum.ksi50
                
                if table.selectedRow == 0{
                    gradeToSet = .ksi36
                }else if table.selectedRow == 1{
                    gradeToSet = .ksi50
                }
                
                
                
                
                //take the user selection update the model and save data
                design.a.selectedSteelWDesignValues.setValues(gradeToSet)
                
                design.updateDesignSectionCollections()
                
                //update the tables
                resultsTableView.reloadData()
                adjustmentTableView.reloadData()
                
                if delegate != nil && shouldUpdateSaveDocOnSelectionChange == true{
                    delegate?.updateSaveDocWithSteelWDesignChange(design.a.selectedSteelWSection, designValues: design.a.selectedSteelWDesignValues)
                }
                //end take the user selection update the model and save data
                
            }
        }//end if selectionTriggeredFromSelection
        updateStatus()
        selectionTriggeredFromSelection = false
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        var rowCount:Int = 0
            if tableView.identifier! == "0" {
                rowCount = 141
            }else if tableView.identifier! == "1"{
                rowCount = 2
            }else if tableView.identifier! == "2"{
                rowCount = 2
            }else if tableView.identifier! == "3"{
                rowCount = design.a.BeamGeo.dataPointCount
            }
        return rowCount
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let tempSectionData = MWSteelWSectionDesignData()
        let tempGradeData = MWSteelWDesignValues()
        
        let strIdentifier:NSString = tableColumn!.identifier as NSString
        //let intIdentifier:Int = strIdentifier.integerValue
        
        let cell = tableView.make(withIdentifier: strIdentifier as String, owner: self) as! NSTableCellView
        
        
        
        
        if tableView.identifier == "0"{ //the member section table
            
            
            tempSectionData.setSectionData(row)
            
            if tableColumn?.identifier == "0"{
                cell.textField?.stringValue = tempSectionData.shape as String
            }else if tableColumn?.identifier == "1"{
                cell.textField?.stringValue = ("\(tempSectionData.depth)")
            }else if tableColumn?.identifier == "2"{
                cell.textField?.stringValue = ("\(tempSectionData.width)")
            }else if tableColumn?.identifier == "3"{
                cell.textField?.stringValue = ("\(tempSectionData.sectionModulus)")
            }else if tableColumn?.identifier == "4"{
                cell.textField?.stringValue = ("\(tempSectionData.I)")
            }else if tableColumn?.identifier == "5"{
                cell.textField?.stringValue = ("\(tempSectionData.webThickness)")
            }else if tableColumn?.identifier == "6"{
                cell.textField?.stringValue = ("\(tempSectionData.bf)")
            }else if tableColumn?.identifier == "7"{
                cell.textField?.stringValue = ("\(tempSectionData.tf)")
            }else if tableColumn?.identifier == "8"{
                cell.textField?.stringValue = ("\(tempSectionData.h)")
            }else if tableColumn?.identifier == "9"{
                cell.textField?.stringValue = ("\(tempSectionData.rt)")
            }
            
        }else if tableView.identifier == "1"{ //the member grade table
            
            if row == 0 {
                tempGradeData.setValues(steelGradeEnum.ksi36)
            }else if row == 1{
                tempGradeData.setValues(steelGradeEnum.ksi50)
            }
            
           cell.textField?.stringValue = tempGradeData.limits.grade.rawValue
            
            //////////////////////////
            
        }else if tableView.identifier! == "2"{
            
            if tableColumn?.identifier == "description"{
                
                if row == 0{
                    
                    cell.textField?.stringValue = "Steel Bending F.S."
                    
                }else if row == 1{
                    
                    cell.textField?.stringValue = "Steel Shear F.S."
                    
                }
                
            }else if tableColumn?.identifier == "qset"{
                if row == 0{
                    cell.textField?.stringValue = "..."
                }else if row == 1{
                    cell.textField?.stringValue = "..."
                }
                
            }else if tableColumn?.identifier == "factor"{
                if row == 0{
                    cell.textField?.stringValue = NSString(format:"%.2f", design.a.selectedSteelWDesignValues.steelFactors.fbSafetyFactor) as String
                }else if row == 1{
                    cell.textField?.stringValue = NSString (format:"%.2f",design.a.selectedSteelWDesignValues.steelFactors.fvSafetyFactor) as String
                }
            }
            
        }else if tableView.identifier == "3"{
            
            guard design.a.loadCollection.count > 0 else{
                cell.textField?.stringValue = ""
                return  cell
            }
            
            
            guard design.steelWDesignSectionCollection.count > 0 else{
                cell.textField?.stringValue = ""
                return  cell
            }
            
            if tableColumn?.identifier == "Point No."{
                cell.textField?.stringValue = NSString(format:"%i",row) as String
                
            }else if tableColumn?.identifier == "Position"{
                cell.textField?.stringValue = NSString(format:"%.2f",design.steelWDesignSectionCollection[row].location) as String
                
            }else if tableColumn?.identifier == "Fb"{
                cell.textField?.stringValue = NSString(format:"%.2f",design.a.selectedSteelWDesignValues.limits.Fb / 1000) as String
                if design.steelWDesignSectionCollection[row].bendingStress * 1000 > design.a.selectedSteelWDesignValues.FbAdjust{
                    cell.textField?.textColor = NSColor.red
                    
                }else{
                    cell.textField?.textColor = NSColor.blue
                }
                
               
            }else if tableColumn?.identifier == "FbA"{
                cell.textField?.stringValue = NSString(format:"%.2f", design.a.selectedSteelWDesignValues.FbAdjust / 1000) as String
                if design.steelWDesignSectionCollection[row].bendingStress * 1000 > design.a.selectedSteelWDesignValues.FbAdjust{
                    cell.textField?.textColor = NSColor.red
                    
                }else{
                    cell.textField?.textColor = NSColor.blue
                }
                
            }else if tableColumn?.identifier == "fb"{
                cell.textField?.stringValue = NSString(format:"%.2f",design.steelWDesignSectionCollection[row].bendingStress) as String
                if design.steelWDesignSectionCollection[row].bendingStress * 1000 > design.a.selectedSteelWDesignValues.FbAdjust{
                    cell.textField?.textColor = NSColor.red
                }else{
                    cell.textField?.textColor = NSColor.blue
                }
                
               
            }else if tableColumn?.identifier == "Fv"{
                cell.textField?.stringValue = NSString(format:"%.2f",design.a.selectedSteelWDesignValues.limits.Fv / 1000) as String
                if abs(design.steelWDesignSectionCollection[row].shearStress * 1000) > design.a.selectedSteelWDesignValues.FvAdjust{
                    cell.textField?.textColor = NSColor.red
                }else{
                    cell.textField?.textColor = NSColor.blue
                }
            }else if tableColumn?.identifier == "FvA"{
                cell.textField?.stringValue = NSString(format:"%.2f",design.a.selectedSteelWDesignValues.FvAdjust / 1000) as String
                if abs(design.steelWDesignSectionCollection[row].shearStress * 1000) > design.a.selectedSteelWDesignValues.FvAdjust{
                    cell.textField?.textColor = NSColor.red
                }else{
                    cell.textField?.textColor = NSColor.blue
                }
            }else if tableColumn?.identifier == "fv"{
                cell.textField?.stringValue = NSString(format:"%.2f",abs(design.steelWDesignSectionCollection[row].shearStress)) as String
                if abs(design.steelWDesignSectionCollection[row].shearStress * 1000) > design.a.selectedSteelWDesignValues.FvAdjust{
                    cell.textField?.textColor = NSColor.red
                }else{
                    cell.textField?.textColor = NSColor.blue
                }
                
            }else if tableColumn?.identifier == "Deflection"{
                cell.textField?.stringValue = NSString(format:"%.2f", abs(design.steelWDesignSectionCollection[row].deflection)) as String
                
                if abs(( 12 * design.a.BeamGeo.length) / design.steelWDesignSectionCollection[row].deflection) < Double(design.a.selectedSteelWDesignValues.limits.deflectionLimit){
                    cell.textField?.textColor = NSColor.red
                }else{
                    cell.textField?.textColor = NSColor.blue
                }
                
            }else if tableColumn?.identifier == "DeflectionRatio"{
                
                let dRatio:Double = (design.a.BeamGeo.length * 12) / (abs(design.steelWDesignSectionCollection[row].deflection))
                if dRatio > 10000{
                    cell.textField?.stringValue = "NA"
                }else{
                    cell.textField?.stringValue = NSString(format:"%.2f", dRatio) as String
                }
                
                if abs((12 * design.a.BeamGeo.length) / design.steelWDesignSectionCollection[row].deflection) < Double(design.a.selectedSteelWDesignValues.limits.deflectionLimit){
                    cell.textField?.textColor = NSColor.red
                }else{
                    cell.textField?.textColor = NSColor.blue
                }
                
            }else{
                cell.textField?.stringValue = "Error"
                cell.textField?.textColor = NSColor.purple
            }
            
        }
        
        
        return cell;
    }
    
    
    @IBAction func onFactorTableEdit(_ sender: AnyObject) {
        let row = adjustmentTableView.selectedRow
        
        guard let doubleVal = Double(sender.stringValue)else{
            updateViews()//clears out the bad data
            return
        }
        
        if row == 0{
            design.a.selectedSteelWDesignValues.steelFactors.fbSafetyFactor = doubleVal
        }else if row == 1{
            design.a.selectedSteelWDesignValues.steelFactors.fvSafetyFactor = doubleVal
        }
        
        //update the adjusted Fb values
        design.a.selectedSteelWDesignValues.setAdjustedValues()
        updateViews()
        
    }
    
    
    
    
    
    
    
    @IBAction func clickSetAdjustment(_ sender: AnyObject) {
        
        let row = adjustmentTableView.row(for: sender as! NSView)
        
        if row == 0{
            let selector = storyboard?.instantiateController(withIdentifier: "fbSelector") as! vc_FSFbSelector
            
            selector.specifiedSectionData = self.design.a.selectedSteelWSection
            selector.designValues = self.design.a.selectedSteelWDesignValues
            selector.delegate = self
            
            self.presentViewController(selector, asPopoverRelativeTo: sender.frame, of: sender as! NSView, preferredEdge: NSRectEdge.minX , behavior: NSPopoverBehavior.transient)
            
        }else if row == 1{
            let selector = storyboard?.instantiateController(withIdentifier: "fvSelector") as! vc_FSFvSelector

            selector.specifiedSectionData = self.design.a.selectedSteelWSection
            selector.designValues = self.design.a.selectedSteelWDesignValues
            selector.delegate = self
            
            self.presentViewController(selector, asPopoverRelativeTo: sender.frame, of: sender as! NSView, preferredEdge: NSRectEdge.minX , behavior: NSPopoverBehavior.transient)
            
            
        }
        
    }
    
    //Steel W Factor Delegates
    func setFSFbMatrixIndex(_ theIndex:Int, CalculatedFSFb:Double, Lu:Double){
        design.a.selectedSteelWDesignValues.steelFactors.fbSafetyFactor = CalculatedFSFb
        design.a.selectedSteelWDesignValues.steelFactors.FSLu = Lu
        design.a.selectedSteelWDesignValues.steelFactors.fbSFCalcType = theIndex
        
        design.a.selectedSteelWDesignValues.setAdjustedValues()
        adjustmentTableView.reloadData()
        resultsTableView.reloadData()
        updateStatus()
    }
    
  
    func setFSFvMatrixIndex(_ theIndex: Int, CalculatedFSFv: Double) {
        design.a.selectedSteelWDesignValues.steelFactors.fvSafetyFactor = CalculatedFSFv
        design.a.selectedSteelWDesignValues.steelFactors.fvSFCalcType = theIndex
        design.a.selectedSteelWDesignValues.setAdjustedValues()
        adjustmentTableView.reloadData()
        resultsTableView.reloadData()
        updateStatus()
    }
    
    
    
    func updateStatus(){
        let failColor = NSColor(calibratedRed: 1, green: 0, blue: 0, alpha: 0.85)
        
        let warningColor = NSColor(calibratedRed: 0.95, green: 0.95, blue: 0.00, alpha: 1)
        
        let passColor = NSColor(calibratedRed: 0, green: 0.60, blue: 0.30, alpha: 1)
        
        let nullColor = NSColor.clear
        
        if design.steelWDesignSectionCollection.count == 0{
            statusColor = nullColor
            statusString = "no load"
        }else{
        statusColor = passColor
        var failCount:Int = 0
        
        
        
        for i in 0...design.steelWDesignSectionCollection.count-1{
            
            
            if design.steelWDesignSectionCollection[i].bendingStress * 1000 > design.a.selectedSteelWDesignValues.FbAdjust{
                statusColor = failColor
                failCount += 1
            }
            
            if abs(design.steelWDesignSectionCollection[i].shearStress * 1000) >  design.a.selectedSteelWDesignValues.FbAdjust{
                statusColor = failColor
                failCount += 1
            }
            
            if abs(( 12 * design.a.BeamGeo.length) / design.steelWDesignSectionCollection[i].deflection) < Double(design.a.selectedSteelWDesignValues.limits.deflectionLimit){
                if failCount == 0{
                    statusColor = warningColor
                }else{
                    statusColor = failColor
                }
            }
            
        }//end for
        
        let stringZ = "\(design.a.BeamGeo.title)  |  "
        let stringA = "Steel W Section   |   "
        let stringB = design.a.selectedSteelWSection.shape as String
        let stringC = "  |  \(design.a.selectedSteelWDesignValues.limits.grade.rawValue) "
        statusString =  stringZ + stringA + stringB + stringC
        }
        if statusDelegate != nil{
            statusDelegate?.updateStatus(theString: statusString, theColor: statusColor)
        }
    }

    
}
