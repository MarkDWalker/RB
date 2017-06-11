//
//  vc_FlitchBeamDesignPanel.swift
//  ResiBeam_V0.0.7
//
//  Created by Mark Walker on 6/19/16.
//  Copyright © 2016 Mark Walker. All rights reserved.
//

import Cocoa

class vc_FlitchBeamDesignPanel: NSViewController, NSTableViewDataSource, NSTableViewDelegate, MWFactorReceiver{
    
    var delegate:beamDataDelegate?
    var statusDelegate:statusBarDelegate?
    
    @IBOutlet weak var sectionTableView: NSTableView!
    @IBOutlet weak var gradeTableView: NSTableView!
    @IBOutlet weak var adjustmentTableView: NSTableView!
    @IBOutlet weak var resultsTableView: NSTableView!
    
    //var a = MWBeamAnalysis() //this is set from the left panel data
    
    var design = MWFlitchBeamDesign()
    
    
    fileprivate var statusColor:NSColor = NSColor.green
    fileprivate var statusString:String = ""
    
    
    var shouldUpdateSaveDocOnSelectionChange:Bool = false
    var selectionTriggeredFromSelection:Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
    }
    
    override func viewWillAppear() {
        
        delegate?.updateSaveDocWithSelectedDesignTabIndex(selectedTabIndex: 3)
        updateStatus()
    }
    
    override func viewDidLayout() {
        delegate?.updateSaveDocWithSelectedDesignTabIndex(selectedTabIndex: 3)
        updateStatus()
    }
    
    
    
    
    
    func updateViews(){
        //selects the correct section in the tableview
        var rowForSectionTable:Int = -1
        var counter = 0
        repeat{   //repeat loop for first table
            let tableString = (sectionTableView.view(atColumn: 0, row: counter, makeIfNecessary: true) as! NSTableCellView).textField!.stringValue
            let savedShapeString = design.a.selectedFlitchSection.shape as String
            if savedShapeString == tableString{
                rowForSectionTable = counter
            }
            counter+=1
        }while rowForSectionTable == -1 && counter < sectionTableView.numberOfRows //todo Check for error if last beam is selected
        Swift.print("before sectionTableView selection func UpdateViews() --grade: \(design.a.selectedFlitchDesignValues.limits.grade.rawValue)")
        sectionTableView.selectRowIndexes(IndexSet(integer: rowForSectionTable), byExtendingSelection: false)
        sectionTableView.scrollRowToVisible(rowForSectionTable)
        //end selects section in tableview
        
        
        
        //selects the correct grade in tableview
        var rowForGradeTable:Int = -1
        counter = 0
        let gradeTableRowCount = gradeTableView.numberOfRows
        
        Swift.print("before loop func UpdateViews() --grade: \(design.a.selectedFlitchDesignValues.limits.grade.rawValue)")
        repeat{   //repeat loop for second table
            
            let tableGradeString = (gradeTableView.view(atColumn: 0, row: counter, makeIfNecessary: true) as! NSTableCellView).textField!.stringValue
            let tableSpeciesString = (gradeTableView.view(atColumn: 1, row: counter, makeIfNecessary: true) as! NSTableCellView).textField!.stringValue
            let savedGradeString = design.a.selectedFlitchDesignValues.limits.grade.rawValue
            let savedSpeciesString = design.a.selectedFlitchDesignValues.limits.species.rawValue
            
            
            
            if savedGradeString as String == tableGradeString && savedSpeciesString as String == tableSpeciesString {
                
                rowForGradeTable = counter
                Swift.print("The gradeString: \(tableGradeString) = savedValue: \(savedGradeString)")
                Swift.print("The speciesString: \(tableSpeciesString) = savedValue: \(savedSpeciesString)")
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
        
        
        
        
    }
    
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "BeamCalculations"{
            let vc_Calcs = segue.destinationController as! vc_Calculations
            
            vc_Calcs.flitchBeamDesign = self.design
            vc_Calcs.calcType = "Flitch"
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
                design.a.selectedFlitchSection.setSectionData(table.selectedRow)
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
                design.a.selectedFlitchDesignValues.setValues(design.a.selectedFlitchDesignValues.limits.species, theGrade: design.a.selectedFlitchDesignValues.limits.grade, memberWidth: design.a.selectedFlitchSection.depth)
                design.updateDesignSectionCollections()
                
                //update the tables
                resultsTableView.reloadData()
                adjustmentTableView.reloadData()
                
                if delegate != nil && shouldUpdateSaveDocOnSelectionChange == true{
                    delegate?.updateSaveDocWithFlitchDesignChange(design.a.selectedFlitchSection, designValues: design.a.selectedFlitchDesignValues)
                }
                //end take the user selection update the model and save data
                
            }else if table.identifier == "1"{
                var speciesToSet = speciesEnum.syp
                var gradeToSet = woodGradeEnum.denseSelectStructural
                
                if table.selectedRow >= 0 && table.selectedRow <= 9{
                    speciesToSet = .syp
                }
                
                if table.selectedRow == 0 {
                    gradeToSet = .denseSelectStructural
                }else if table.selectedRow == 1{
                    gradeToSet = .selectStructural
                }else if table.selectedRow == 2{
                    gradeToSet = .nonDenseSelectStructural
                }else if table.selectedRow == 3{
                    gradeToSet = .no1Dense
                }else if table.selectedRow == 4{
                    gradeToSet = .no1
                }else if table.selectedRow == 5{
                    gradeToSet = .no1NonDense
                }else if table.selectedRow == 6{
                    gradeToSet = .no2Dense
                }else if table.selectedRow == 7{
                    gradeToSet = .no2
                }else if table.selectedRow == 8{
                    gradeToSet = .no2NonDense
                }else if table.selectedRow == 9{
                    gradeToSet = .no3AndStud
                }
                
                
                //take the user selection update the model and save data
                design.a.selectedFlitchDesignValues.setValues(speciesToSet, theGrade: gradeToSet, memberWidth: design.a.selectedFlitchSection.depth)
                
                design.updateDesignSectionCollections()
                
                //update the tables
                resultsTableView.reloadData()
                adjustmentTableView.reloadData()
                
                if delegate != nil && shouldUpdateSaveDocOnSelectionChange == true{
                    delegate?.updateSaveDocWithFlitchDesignChange(design.a.selectedFlitchSection, designValues: design.a.selectedFlitchDesignValues)
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
            rowCount = 30
        }else if tableView.identifier! == "1"{
            rowCount = 10
        }else if tableView.identifier! == "2"{
            rowCount = 7
        }else if tableView.identifier! == "3"{
            rowCount = design.a.BeamGeo.dataPointCount
        }
        return rowCount
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let tempSectionData = MWFlitchSectionDesignData()
        let tempGradeData = MWFlitchDesignValues()
        
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
                cell.textField?.stringValue = ("\(tempSectionData.area)")
            }else if tableColumn?.identifier == "4"{
                cell.textField?.stringValue = ("\(tempSectionData.vArea)")
            }else if tableColumn?.identifier == "5"{
                cell.textField?.stringValue = ("\(tempSectionData.sectionModulus)")
            }else if tableColumn?.identifier == "6"{
                cell.textField?.stringValue = ("\(tempSectionData.I)")
                
            }
            
        }else if tableView.identifier == "1"{ //the member grade table
            
            if row == 0 {
                tempGradeData.setValues(speciesEnum.syp, theGrade: woodGradeEnum.denseSelectStructural, memberWidth: design.a.selectedFlitchSection.depth)
            }else if row == 1{
                tempGradeData.setValues(speciesEnum.syp, theGrade: woodGradeEnum.selectStructural, memberWidth: design.a.selectedFlitchSection.depth)
            }else if row == 2{
                tempGradeData.setValues(speciesEnum.syp, theGrade: woodGradeEnum.nonDenseSelectStructural, memberWidth: design.a.selectedFlitchSection.depth)
            }else if row == 3{
                tempGradeData.setValues(speciesEnum.syp, theGrade: woodGradeEnum.no1Dense, memberWidth: design.a.selectedFlitchSection.depth)
            }else if row == 4{
                tempGradeData.setValues(speciesEnum.syp, theGrade: woodGradeEnum.no1, memberWidth: design.a.selectedFlitchSection.depth)
            }else if row == 5{
                tempGradeData.setValues(speciesEnum.syp, theGrade: woodGradeEnum.no1NonDense, memberWidth: design.a.selectedFlitchSection.depth)
            }else if row == 6{
                tempGradeData.setValues(speciesEnum.syp, theGrade: woodGradeEnum.no2Dense, memberWidth: design.a.selectedFlitchSection.depth)
            }else if row == 7{
                tempGradeData.setValues(speciesEnum.syp, theGrade: woodGradeEnum.no2, memberWidth: design.a.selectedFlitchSection.depth)
            }else if row == 8{
                tempGradeData.setValues(speciesEnum.syp, theGrade: woodGradeEnum.no2NonDense, memberWidth: design.a.selectedFlitchSection.depth)
            }else if row == 9{
                tempGradeData.setValues(speciesEnum.syp, theGrade: woodGradeEnum.no3AndStud, memberWidth: design.a.selectedFlitchSection.depth)
            }
            
            
            
            if tableColumn?.identifier == "0"{
                cell.textField?.stringValue = tempGradeData.limits.grade.rawValue as String
            }else if tableColumn?.identifier == "1"{
                
                if tempGradeData.limits.species == speciesEnum.syp {
                    cell.textField?.stringValue = "SYP"
                }
                
            }else if tableColumn?.identifier == "2"{
                cell.textField?.stringValue = ("\(tempGradeData.limits.Fb)")
            }else if tableColumn?.identifier == "3"{
                cell.textField?.stringValue = ("\(tempGradeData.limits.Fv)")
            }else if tableColumn?.identifier == "4"{
                cell.textField?.stringValue = ("\(tempGradeData.limits.E)")
            }
            
        }else if tableView.identifier! == "2"{
            
            if tableColumn?.identifier == "factor"{
                
                if row == 0{
                    
                    cell.textField?.stringValue = "Cd"
                    
                }else if row == 1{
                    
                    cell.textField?.stringValue = "Cm"
                    
                }else if row == 2{
                    
                    cell.textField?.stringValue = "Ct"
                    
                }else if row == 3{
                    
                    cell.textField?.stringValue = "Cf"
                    
                }else if row == 4{
                    
                    cell.textField?.stringValue = "Cfu"
                    
                }else if row == 5{
                    
                    cell.textField?.stringValue = "Cr"
                    
                }else if row == 6{
                    
                    cell.textField?.stringValue = "Cl"
                }
                
            }else if tableColumn?.identifier == "description"{
                
                if row == 0{
                    
                    cell.textField?.stringValue = "Load Duration Factor"
                    
                }else if row == 1{
                    
                    cell.textField?.stringValue = "Wet Service Factor"
                    
                }else if row == 2{
                    
                    cell.textField?.stringValue = "Temperature Factor"
                    
                }else if row == 3{
                    
                    cell.textField?.stringValue = "Size Factor"
                    
                }else if row == 4{
                    
                    cell.textField?.stringValue = "Flat Use Factor"
                    
                }else if row == 5{
                    
                    cell.textField?.stringValue = "Repetitive Member Factor"
                } else if row == 6{
                    
                    cell.textField?.stringValue = "Beam Stability Factor"
                    
                }
                
            }else if tableColumn?.identifier == "qset"{
                if row == 0{
                    cell.textField?.stringValue = "..."
                }else if row == 1{
                    cell.textField?.stringValue = "..."
                }else if row == 2{
                    cell.textField?.stringValue = "..."
                }else if row == 3{
                    cell.textField?.stringValue = "-/-"
                }else if row == 4{
                    cell.textField?.stringValue = "-/-"
                }else if row == 5{
                    cell.textField?.stringValue = "-/-"
                }else if row == 6{
                    cell.textField?.stringValue = "-/-"
                }
                
            }else if tableColumn?.identifier == "fbfactor"{
                if row == 0{
                    cell.textField?.stringValue = "\(design.a.selectedFlitchDesignValues.wF.Cd)"
                }else if row == 1{
                    cell.textField?.stringValue = "\(design.a.selectedFlitchDesignValues.wF.CmFb)"
                }else if row == 2{
                    cell.textField?.stringValue = "\(design.a.selectedFlitchDesignValues.wF.CtFb)"
                }else if row == 3{
                    cell.textField?.stringValue = "\(design.a.selectedFlitchDesignValues.wF.Cf)"
                }else if row == 4{
                    cell.textField?.stringValue = "\(design.a.selectedFlitchDesignValues.wF.Cfu)"
                }else if row == 5{
                    cell.textField?.stringValue = "\(design.a.selectedFlitchDesignValues.wF.Cr)"
                }else if row == 6{
                    cell.textField?.stringValue = "\(design.a.selectedFlitchDesignValues.wF.Cl)"
                }
                
            }else if tableColumn?.identifier == "fvfactor"{
                if row == 0{
                    cell.textField?.stringValue = "\(design.a.selectedFlitchDesignValues.wF.Cd)"
                }else if row == 1{
                    cell.textField?.stringValue = "\(design.a.selectedFlitchDesignValues.wF.CmFv)"
                }else if row == 2{
                    cell.textField?.stringValue = "\(design.a.selectedFlitchDesignValues.wF.CtFv)"
                }else {
                    cell.textField?.stringValue = "n/a"
                    cell.textField?.textColor = NSColor.gray
                }
                
            }else if tableColumn?.identifier == "efactor"{
                if row == 1{
                    cell.textField?.stringValue = "\(design.a.selectedFlitchDesignValues.wF.CmE)"
                }else if row == 2{
                    cell.textField?.stringValue = "\(design.a.selectedFlitchDesignValues.wF.CtE)"
                }else {
                    cell.textField?.stringValue = "n/a"
                    cell.textField?.textColor = NSColor.gray
                }
            }
            
        }else if tableView.identifier == "3"{
            
            
            guard design.a.loadCollection.count > 0 else{
                cell.textField?.stringValue = ""
                return  cell
            }
            
            guard design.FlitchDesignSectionCollection.count > 0 else{
                cell.textField?.stringValue = ""
                return  cell
            }
            
            if tableColumn?.identifier == "Point No."{
                cell.textField?.stringValue = NSString(format:"%i",row) as String
                
            }else if tableColumn?.identifier == "Position"{
                cell.textField?.stringValue = NSString(format:"%.2f",design.FlitchDesignSectionCollection[row].location) as String
                
            }else if tableColumn?.identifier == "Fb"{
                cell.textField?.stringValue = NSString(format:"%.2f",design.a.selectedFlitchDesignValues.limits.Fb) as String
                if design.FlitchDesignSectionCollection[row].bendingStress * 1000 > design.a.selectedFlitchDesignValues.FbAdjust{
                    cell.textField?.textColor = NSColor.red
                    
                }else{
                    cell.textField?.textColor = NSColor.blue
                }
                
            }else if tableColumn?.identifier == "FbA"{
                cell.textField?.stringValue = NSString(format:"%.2f", design.a.selectedFlitchDesignValues.FbAdjust) as String
                if design.FlitchDesignSectionCollection[row].bendingStress * 1000 > design.a.selectedFlitchDesignValues.FbAdjust{
                    cell.textField?.textColor = NSColor.red
                    
                }else{
                    cell.textField?.textColor = NSColor.blue
                }
            }else if tableColumn?.identifier == "fb"{
                cell.textField?.stringValue = NSString(format:"%.2f",design.FlitchDesignSectionCollection[row].bendingStress * 1000) as String
                if design.FlitchDesignSectionCollection[row].bendingStress * 1000 > design.a.selectedFlitchDesignValues.FbAdjust{
                    cell.textField?.textColor = NSColor.red
                }else{
                    cell.textField?.textColor = NSColor.blue
                }
            }else if tableColumn?.identifier == "Fv"{
                cell.textField?.stringValue = NSString(format:"%.2f",design.a.selectedFlitchDesignValues.limits.Fv) as String
                if abs(design.FlitchDesignSectionCollection[row].shearStress * 1000) > design.a.selectedFlitchDesignValues.FvAdjust{
                    cell.textField?.textColor = NSColor.red
                }else{
                    cell.textField?.textColor = NSColor.blue
                }
            }else if tableColumn?.identifier == "FvA"{
                cell.textField?.stringValue = NSString(format:"%.2f",design.a.selectedFlitchDesignValues.FvAdjust) as String
                if abs(design.FlitchDesignSectionCollection[row].shearStress * 1000) > design.a.selectedFlitchDesignValues.FvAdjust{
                    cell.textField?.textColor = NSColor.red
                }else{
                    cell.textField?.textColor = NSColor.blue
                }
            }else if tableColumn?.identifier == "fv"{
                cell.textField?.stringValue = NSString(format:"%.2f",abs(design.FlitchDesignSectionCollection[row].shearStress * 1000)) as String
                if abs(design.FlitchDesignSectionCollection[row].shearStress * 1000) > design.a.selectedFlitchDesignValues.FvAdjust{
                    cell.textField?.textColor = NSColor.red
                }else{
                    cell.textField?.textColor = NSColor.blue
                }
                
            }else if tableColumn?.identifier == "Deflection"{
                cell.textField?.stringValue = NSString(format:"%.2f", abs(design.FlitchDesignSectionCollection[row].deflection)) as String
                
                if abs(( 12 * design.a.BeamGeo.length) / design.FlitchDesignSectionCollection[row].deflection) < Double(design.a.selectedFlitchDesignValues.limits.deflectionLimit){
                    cell.textField?.textColor = NSColor.red
                }else{
                    cell.textField?.textColor = NSColor.blue
                }
                
            }else if tableColumn?.identifier == "DeflectionRatio"{
                
                let dRatio:Double = (design.a.BeamGeo.length * 12) / (abs(design.FlitchDesignSectionCollection[row].deflection))
                if dRatio > 10000{
                    cell.textField?.stringValue = "NA"
                }else{
                    cell.textField?.stringValue = NSString(format:"%.2f", dRatio) as String
                }
                
                if abs((12 * design.a.BeamGeo.length) / design.FlitchDesignSectionCollection[row].deflection) < Double(design.a.selectedFlitchDesignValues.limits.deflectionLimit){
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
    
    
    @IBAction func onFbFactorTableEdit(_ sender: AnyObject) {
        let row = adjustmentTableView.selectedRow
        
        guard let doubleVal = Double(sender.stringValue)else{
            updateViews()//clears out the bad data
            return
        }
        
        if row == 0{
            design.a.selectedFlitchDesignValues.wF.Cd = doubleVal
        }else if row == 1{
            design.a.selectedFlitchDesignValues.wF.CmFb = doubleVal
        }else if row == 2{
            design.a.selectedFlitchDesignValues.wF.CtFb = doubleVal
        }else if row == 3{
            design.a.selectedFlitchDesignValues.wF.Cf = doubleVal
        }else if row == 4{
            design.a.selectedFlitchDesignValues.wF.Cfu = doubleVal
        }else if row == 5{
            design.a.selectedFlitchDesignValues.wF.Cr = doubleVal
        }else if row == 6{
            design.a.selectedFlitchDesignValues.wF.Cl = doubleVal
        }
        
        //update the adjusted Fb values
        design.a.selectedFlitchDesignValues.setAdjustedValues()
        updateViews()
        
    }
    
    @IBAction func onFvFactorTableEdit(_ sender: AnyObject) {
        let row = adjustmentTableView.selectedRow
        
        guard let doubleVal = Double(sender.stringValue)else{
            updateViews()//clears out the bad entry
            return
        }
        
        if row == 0{
            design.a.selectedFlitchDesignValues.wF.Cd = doubleVal
        }else if row == 1{
            design.a.selectedFlitchDesignValues.wF.CmFv = doubleVal
        }else if row == 2{
            design.a.selectedFlitchDesignValues.wF.CtFv = doubleVal
        }else{
            //do nothing
        }
        
        //update the adjusted Fb values
        design.a.selectedFlitchDesignValues.setAdjustedValues()
        updateViews()
        
    }
    
    @IBAction func onEFactorTableEdit(_ sender: AnyObject) {
        
        let row = adjustmentTableView.selectedRow
        
        guard let doubleVal = Double(sender.stringValue)else{
            updateViews()//clears out the bad entry
            return
        }
        
        if row == 1{
            design.a.selectedFlitchDesignValues.wF.CmE = doubleVal
        }else if row == 2{
            design.a.selectedFlitchDesignValues.wF.CtE = doubleVal
        }else{
            //do nothing
        }
        
        //update the adjusted Fb values
        design.a.selectedFlitchDesignValues.setAdjustedValues()
        updateViews()
        
        
    }
    
    
    
    @IBAction func clickSetAdjustment(_ sender: AnyObject) {
        
        let row = adjustmentTableView.row(for: sender as! NSView)
        
        if row >= 0 && row <= 5{
            let cdSelector = storyboard?.instantiateController(withIdentifier: "cdSelector") as! vc_cdSelector
            cdSelector.receiverDelegate = self
            
            
            if row == 0 {
                cdSelector.tableColumnTitle = "Load Duration Factor (Cd)"
                cdSelector.factor = "Cd"
                cdSelector.view.frame.size = NSMakeSize(200, 220)
                
                
            }else if row == 1{
                cdSelector.tableColumnTitle = "Wet Service Factor (Cm)"
                cdSelector.factor = "Cm"
                cdSelector.view.frame.size = NSMakeSize(500, 150)
            }else if row == 2{
                cdSelector.tableColumnTitle = "Temperature Factor (Ct)"
                cdSelector.factor = "Ct"
                cdSelector.view.frame.size = NSMakeSize(500, 210)
            }else if row == 3{
                cdSelector.tableColumnTitle = "Size Factor (Cf)"
                cdSelector.factor = "Cf"
                cdSelector.view.frame.size = NSMakeSize(500, 210)
            }else if row == 4{
                cdSelector.tableColumnTitle = "Flat Use Factor (Cfu)"
                cdSelector.factor = "Cfu"
                cdSelector.view.frame.size = NSMakeSize(500, 210)
            }else if row == 5{
                cdSelector.tableColumnTitle = "Repetative Member Factor (Cr)"
                cdSelector.factor = "Cr"
                cdSelector.view.frame.size = NSMakeSize(500, 210)
            }
            
            
            self.presentViewController(cdSelector, asPopoverRelativeTo: sender.frame, of: sender as! NSView, preferredEdge: NSRectEdge.minX , behavior: NSPopoverBehavior.transient)
            
        }else if row == 6{
            let clSelector = storyboard?.instantiateController(withIdentifier: "clSelector") as! vc_clSelector
            clSelector.title = "SPECIFY BEAM STABLIITY FACTOR (CL)"
            
            clSelector.a = self.design.a
            
            clSelector.receiverDelegate = self
            //self.presentViewController(clSelector, asPopoverRelativeToRect: sender.frame, ofView: sender as! NSView, preferredEdge: NSRectEdge.MinX , behavior: NSPopoverBehavior.Transient)
            self.presentViewControllerAsModalWindow(clSelector)
            
        }
        
    }
    
    
    func sendReceiveFactor(_ theFactor:String, theDouble:Double, secondDouble:Double, thirdDouble:Double){
        
        if theFactor == "Cd"{
            design.a.selectedFlitchDesignValues.wF.Cd = theDouble
        }else if theFactor == "Cm"{
            design.a.selectedFlitchDesignValues.wF.CmFb = theDouble
            design.a.selectedFlitchDesignValues.wF.CmFv = secondDouble
            design.a.selectedFlitchDesignValues.wF.CmE = thirdDouble
        }else if theFactor == "Ct"{
            design.a.selectedFlitchDesignValues.wF.CtFb = theDouble
            design.a.selectedFlitchDesignValues.wF.CtFv = secondDouble
            design.a.selectedFlitchDesignValues.wF.CtE = thirdDouble
        }else if theFactor == "Cf"{
            design.a.selectedFlitchDesignValues.wF.Cf = theDouble
        }else if theFactor == "Cfu"{
            design.a.selectedFlitchDesignValues.wF.Cfu = theDouble
        }else if theFactor == "Cr"{
            design.a.selectedFlitchDesignValues.wF.Cr = theDouble
        }else if theFactor == "Cl"{
            design.a.selectedFlitchDesignValues.wF.Cl = theDouble
        }
        
        design.a.selectedFlitchDesignValues.setAdjustedValues()
        adjustmentTableView.reloadData()
        resultsTableView.reloadData()
        updateStatus()
        
    }
    
    
    
    func updateStatus(){
        let failColor = NSColor(calibratedRed: 1, green: 0, blue: 0, alpha: 0.85)
        
        let warningColor = NSColor(calibratedRed: 0.95, green: 0.95, blue: 0.00, alpha: 1)
        
        let passColor = NSColor(calibratedRed: 0, green: 0.60, blue: 0.30, alpha: 1)
        
        
        let nullColor = NSColor.clear
        
        if design.FlitchDesignSectionCollection.count == 0{
            statusColor = nullColor
            statusString = "no loads"
        }else{
            statusColor = passColor
            
            
            var failCount:Int = 0
            
            
            
            for i in 0...design.FlitchDesignSectionCollection.count-1{
                
                
                if design.FlitchDesignSectionCollection[i].bendingStress * 1000 > design.a.selectedFlitchDesignValues.FbAdjust{
                    statusColor = failColor
                    failCount += 1
                }
                
                if abs(design.FlitchDesignSectionCollection[i].shearStress * 1000) >  design.a.selectedFlitchDesignValues.FbAdjust{
                    statusColor = failColor
                    failCount += 1
                }
                
                if abs(( 12 * design.a.BeamGeo.length) / design.FlitchDesignSectionCollection[i].deflection) < Double(design.a.selectedFlitchDesignValues.limits.deflectionLimit){
                    if failCount == 0{
                        statusColor = warningColor
                    }else{
                        statusColor = failColor
                    }
                }
                
            }//end for
            
            let stringZ = "\(design.a.BeamGeo.title)  |  "
            let stringA = "Flitch Section   |   "
            let stringB = design.a.selectedFlitchSection.shape as String
            let stringC = "  |  \(design.a.selectedFlitchDesignValues.limits.grade.rawValue) "
            statusString =  stringZ + stringA + stringB + stringC
            
        }
        
        if statusDelegate != nil{
            statusDelegate?.updateStatus(theString: statusString, theColor: statusColor)
        }
    }
    
    
    
    
    
    
    
}
