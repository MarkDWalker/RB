//
//  vc_BeamData.swift
//  ResiBeam_V0.0.7
//
//  Created by Mark Walker on 3/9/16.
//  Copyright © 2016 Mark Walker. All rights reserved.
//

import Cocoa

class vc_BeamData: NSViewController, NSTableViewDataSource, NSTableViewDelegate, MWRadioSelectLoadTypeDelegate, MWLoadCollectionDataSource {

    
    //TableViews Declarations
    @IBOutlet weak var beamListTableView: NSTableView!
    
    @IBOutlet weak var beamPropertiesTableView: NSTableView!
    
    @IBOutlet weak var loadListTableView: NSTableView!
    
    @IBOutlet weak var loadPropetiesTableView: NSTableView!
    
    var delegate:beamDataDelegate?
    
    var loadButton = NSButton()
    
    var selectedBeamListRow:Int = -1
    var selectedLoadListRow:Int = -1
    
    var projectBeamCollection = [MWBeamAnalysis]()
    
    var collectionReorderer = MWCollectionReorder()
    
    var selectedDesignTab = -1
    
    var doc:Document = Document()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
        //This is to handle the file data
        
        
        
        
       
        
    }
    
    
    override func viewDidAppear() {
        //Main connection to the persistent file
        doc = self.view.window?.windowController?.document as! Document
        
       
        
        guard doc.saveData.beamAnalysisCollection.count != 0 else{
            return
        }
       
        projectBeamCollection = doc.saveData.beamAnalysisCollection as [MWBeamAnalysis]
        selectedBeamListRow = doc.saveData.beamInterfaceData.selectedBeamListRow
        selectedLoadListRow = doc.saveData.beamInterfaceData.selectedLoadListRow
        selectedDesignTab = projectBeamCollection[selectedBeamListRow].selectedDesignTab
        
        
        //End handle the file data
        beamListTableView.reloadData()
        beamPropertiesTableView.reloadData()
        loadListTableView.reloadData()
        loadPropetiesTableView.reloadData()
        
        beamListTableView.selectRowIndexes(IndexSet(integer: selectedBeamListRow), byExtendingSelection: false)
        loadListTableView.selectRowIndexes(IndexSet(integer: selectedLoadListRow), byExtendingSelection: false)
        
        
        
        self.sendBeamToDelegate(projectBeamCollection[selectedBeamListRow])
        
    }
    
   
    
    fileprivate func sendBeamToDelegate(_ beam:MWBeamAnalysis){
        if delegate != nil{
            beam.updateComboResults() //updates the graphs
            selectedDesignTab = projectBeamCollection[selectedBeamListRow].selectedDesignTab
            delegate?.beamDataUpdate(beam, selectedDesignTab: selectedDesignTab)
        }
    }
    
    
    
   
    
    
   //MARK: TABLEVIEW EDIT IN PLACE FUNCTIONS
    @IBAction func onFinishEditLoadListDescription(_ sender: AnyObject) {
        projectBeamCollection[selectedBeamListRow].loadCollection[selectedLoadListRow].loadDescription = sender.stringValue
        sendBeamToDelegate(projectBeamCollection[selectedBeamListRow])
        
        loadListTableView.reloadData()
        loadPropetiesTableView.reloadData()
        
        saveData()
    }
    
    @IBAction func onFinishEditLoadValue(_ sender: AnyObject) {
        guard let doubleVal = Double(sender.stringValue) else{
            loadListTableView.reloadData()
            loadPropetiesTableView.reloadData()
            return
        }
        guard doubleVal > 0 else{
            loadListTableView.reloadData()
            loadPropetiesTableView.reloadData()
            return
        }
        
        if projectBeamCollection[selectedBeamListRow].loadCollection[selectedLoadListRow].loadType == "linearup"{
            projectBeamCollection[selectedBeamListRow].loadCollection[selectedLoadListRow].loadValue2 = doubleVal
        }else{
            projectBeamCollection[selectedBeamListRow].loadCollection[selectedLoadListRow].loadValue = doubleVal
        }
        
        sendBeamToDelegate(projectBeamCollection[selectedBeamListRow])
        
        loadListTableView.reloadData()
        loadPropetiesTableView.reloadData()
        
        saveData()
    }
    
    @IBAction func onFinishEditStartLoadLocation(_ sender: AnyObject) {
        
        guard let doubleVal = Double(sender.stringValue) else{
            loadListTableView.reloadData()
            loadPropetiesTableView.reloadData()
            return
        }
        guard doubleVal >= 0 else{
            loadListTableView.reloadData()
            loadPropetiesTableView.reloadData()
            return
        }
        
        let beam = projectBeamCollection[selectedBeamListRow].BeamGeo
        let load = projectBeamCollection[selectedBeamListRow].loadCollection[selectedLoadListRow]
        
        guard doubleVal <= beam.length else{
            loadListTableView.reloadData()
            loadPropetiesTableView.reloadData()
            return
        }
        if load.loadType != "concentrated"{
            guard doubleVal < load.loadEnd else{
                loadListTableView.reloadData()
                loadPropetiesTableView.reloadData()
                return
            }
        }
        projectBeamCollection[selectedBeamListRow].loadCollection[selectedLoadListRow].loadStart = doubleVal
        
        if load.loadType == "concentrated"{
            projectBeamCollection[selectedBeamListRow].loadCollection[selectedLoadListRow].loadEnd = 0
        }
        
        sendBeamToDelegate(projectBeamCollection[selectedBeamListRow])
        
        loadListTableView.reloadData()
        loadPropetiesTableView.reloadData()
        
        saveData()
    }
    
    
    @IBAction func onFinishEditLoadEndLocation(_ sender: AnyObject) {
        guard let doubleVal = Double(sender.stringValue) else{
            loadListTableView.reloadData()
            loadPropetiesTableView.reloadData()
            return
        }
        guard doubleVal > 0 else{
            loadListTableView.reloadData()
            loadPropetiesTableView.reloadData()
            return
        }
        
        let beam = projectBeamCollection[selectedBeamListRow].BeamGeo
        let load = projectBeamCollection[selectedBeamListRow].loadCollection[selectedLoadListRow]
        guard load.loadType != "concentrated" else{
            loadListTableView.reloadData()
            loadPropetiesTableView.reloadData()
            return
        }
        
        guard doubleVal > load.loadStart && doubleVal <= beam.length else{
            loadListTableView.reloadData()
            loadPropetiesTableView.reloadData()
            return
        }
        projectBeamCollection[selectedBeamListRow].loadCollection[selectedLoadListRow].loadEnd = doubleVal
        sendBeamToDelegate(projectBeamCollection[selectedBeamListRow])
        
        loadListTableView.reloadData()
        loadPropetiesTableView.reloadData()
        
        saveData()
    }
    
    
    @IBAction func onFinishLoadValueEdit(_ sender: AnyObject) {
        let row = loadPropetiesTableView.selectedRow
        if row == 0{
            projectBeamCollection[selectedBeamListRow].loadCollection[selectedLoadListRow].loadDescription = sender.stringValue
        }else{
            guard let doubleVal = Double(sender.stringValue) else{
                loadListTableView.reloadData()
                loadPropetiesTableView.reloadData()
                return
            }
            guard doubleVal > 0 else{
                loadListTableView.reloadData()
                loadPropetiesTableView.reloadData()
                return
            }
            if row == 1{
                
                if projectBeamCollection[selectedBeamListRow].loadCollection[selectedLoadListRow].loadType == "linearup"{
                    projectBeamCollection[selectedBeamListRow].loadCollection[selectedLoadListRow].loadValue2 = doubleVal
                }
                else
                {
                  projectBeamCollection[selectedBeamListRow].loadCollection[selectedLoadListRow].loadValue = doubleVal
                }
            }else if row == 2{
                //we will have to handle type a different way
            }else if row == 3{
                let beam = projectBeamCollection[selectedBeamListRow].BeamGeo
                let load = projectBeamCollection[selectedBeamListRow].loadCollection[selectedLoadListRow]
                
                guard doubleVal < beam.length else{
                    loadListTableView.reloadData()
                    loadPropetiesTableView.reloadData()
                    return
                }
                if load.loadType != "concentrated"{
                    guard doubleVal < load.loadEnd else{
                        loadListTableView.reloadData()
                        loadPropetiesTableView.reloadData()
                        return
                    }
                }
                projectBeamCollection[selectedBeamListRow].loadCollection[selectedLoadListRow].loadStart = doubleVal
                
                if load.loadType == "concentrated"{
                projectBeamCollection[selectedBeamListRow].loadCollection[selectedLoadListRow].loadEnd = 0
                }
                
            }else if row == 4{
                 let beam = projectBeamCollection[selectedBeamListRow].BeamGeo
                let load = projectBeamCollection[selectedBeamListRow].loadCollection[selectedLoadListRow]
                guard load.loadType != "concentrated" else{
                    loadListTableView.reloadData()
                    loadPropetiesTableView.reloadData()
                    return
                }
                
                guard doubleVal > load.loadStart && doubleVal <= beam.length else{
                    loadListTableView.reloadData()
                    loadPropetiesTableView.reloadData()
                    return
                }
                projectBeamCollection[selectedBeamListRow].loadCollection[selectedLoadListRow].loadEnd = doubleVal
            }
        }
        loadListTableView.reloadData()
        loadPropetiesTableView.reloadData()
        
        saveData()
    }
    
    
    @IBAction func onFinishPropertyEdit(_ sender: NSTextField) {
        
        let row = beamPropertiesTableView.selectedRow
        if row == 0{ //Description
            projectBeamCollection[selectedBeamListRow].BeamGeo.title = sender.stringValue
        }else if row == 6{
            guard let intVal = Int(sender.stringValue) else{
                beamListTableView.reloadData()
                beamPropertiesTableView.reloadData()
                return
            }
            guard intVal >= 3 else{
                beamListTableView.reloadData()
                beamPropertiesTableView.reloadData()
                return
            }
            
            projectBeamCollection[selectedBeamListRow].BeamGeo.dataPointCount = intVal
            
        }else if row == 2{  //Support Location A
            guard let doubleVal = Double(sender.stringValue) else{
                beamListTableView.reloadData()
                beamPropertiesTableView.reloadData()
                return
            }
            
            guard doubleVal < projectBeamCollection[selectedBeamListRow].BeamGeo.length else{
                beamListTableView.reloadData()
                beamPropertiesTableView.reloadData()
                return
            }
            
            guard doubleVal < projectBeamCollection[selectedBeamListRow].BeamGeo.supportLocationB else{
                beamListTableView.reloadData()
                beamPropertiesTableView.reloadData()
                return
            }
            
            guard doubleVal >= 0 else{
                beamListTableView.reloadData()
                beamPropertiesTableView.reloadData()
                return
            }
            
            projectBeamCollection[selectedBeamListRow].BeamGeo.supportLocationA = doubleVal
            
        }else if row == 3{  //Support Location B
            guard let doubleVal = Double(sender.stringValue) else{
                beamListTableView.reloadData()
                beamPropertiesTableView.reloadData()
                return
            }
            
            guard doubleVal <= projectBeamCollection[selectedBeamListRow].BeamGeo.length else{
                beamListTableView.reloadData()
                beamPropertiesTableView.reloadData()
                return
            }
            
            guard doubleVal > projectBeamCollection[selectedBeamListRow].BeamGeo.supportLocationA else{
                beamListTableView.reloadData()
                beamPropertiesTableView.reloadData()
                return
            }
            
            projectBeamCollection[selectedBeamListRow].BeamGeo.supportLocationB = doubleVal
            
        }else{  //covers Length, I, E & No Data Points
            guard let doubleVal = Double(sender.stringValue) else{
                beamListTableView.reloadData()
                beamPropertiesTableView.reloadData()
                return
            }
            
            guard doubleVal >= 0 else{
                beamListTableView.reloadData()
                beamPropertiesTableView.reloadData()
                return
            }
            
            if row == 1{ //Length
                
                let theOldLength = projectBeamCollection[selectedBeamListRow].BeamGeo.length
                loadAdjustFromLengthChange(theOldLength, newLength: doubleVal)
                
                projectBeamCollection[selectedBeamListRow].BeamGeo.length = doubleVal
                
                if doubleVal < projectBeamCollection[selectedBeamListRow].BeamGeo.supportLocationA{
                    projectBeamCollection[selectedBeamListRow].BeamGeo.supportLocationA = 0
                    projectBeamCollection[selectedBeamListRow].BeamGeo.supportLocationB = doubleVal
                }else if doubleVal < projectBeamCollection[selectedBeamListRow].BeamGeo.supportLocationB{
                    projectBeamCollection[selectedBeamListRow].BeamGeo.supportLocationB = doubleVal
                }
                
                
            }else if row == 4{
                 projectBeamCollection[selectedBeamListRow].BeamGeo.I = doubleVal
            }else if row == 5{
                 projectBeamCollection[selectedBeamListRow].BeamGeo.E = doubleVal
            }
        }
        
        sendBeamToDelegate(projectBeamCollection[selectedBeamListRow])
        
        beamListTableView.reloadData()
        beamPropertiesTableView.reloadData()
        
        saveData()
    }
    
    
    @IBAction func onFinishLoadPropertyEdit(_ sender: NSTextField) {
        
        let row = loadPropetiesTableView.selectedRow
        
        if row == 0{
           onFinishEditLoadListDescription(sender)
        }else if row == 1{
           onFinishLoadValueEdit(sender)
        }else if row == 2{
            //loadType
            loadPropetiesTableView.reloadData()
        }else if row == 3{
            onFinishEditStartLoadLocation(sender)
        }else if row == 4{
            onFinishEditLoadEndLocation(sender)
        }
        
        sendBeamToDelegate(projectBeamCollection[selectedBeamListRow])
//        
//        beamListTableView.reloadData()
//        beamPropertiesTableView.reloadData()
//        loadListTableView.reloadData()
//        loadPropetiesTableView.reloadData()
        
        saveData()
    
    }
    
    //MARK: TABLEVIEW MAIN FUNCTIONS
    func tableViewSelectionDidChange(_ notification: Notification){
        
        let table = notification.object as! NSTableView
        if table.identifier == "beamlist"{
            guard table.selectedRow != -1 else{
                return
            }
            
            
            
            selectedBeamListRow = table.selectedRow
            selectedDesignTab = projectBeamCollection[selectedBeamListRow].selectedDesignTab
            doc.saveData.beamInterfaceData.selectedBeamListRow = table.selectedRow
            
            sendBeamToDelegate(projectBeamCollection[selectedBeamListRow])
            
            
            beamPropertiesTableView.reloadData()
            loadListTableView.reloadData()
            
            
            //if the beam has existing loads, select the first one
            guard selectedLoadListRow >= 0 else{
                return
            }
            if projectBeamCollection[selectedBeamListRow].loadCollection.count > 0{
                loadListTableView.selectRowIndexes(IndexSet(integer: selectedLoadListRow), byExtendingSelection: false)
            }
            
        }else if table.identifier == "loadlist"{
            guard table.selectedRow != -1 else{
                return
            }
            selectedLoadListRow = table.selectedRow
            doc.saveData.beamInterfaceData.selectedLoadListRow = table.selectedRow
            
            projectBeamCollection[selectedBeamListRow].selectedLoadIndex = table.selectedRow
            sendBeamToDelegate(projectBeamCollection[selectedBeamListRow])
            loadPropetiesTableView.reloadData()
        }
        
        saveData()
        
        
        
    }
    
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        if tableView.identifier == "beamlist"{
            return projectBeamCollection.count
        }else if tableView.identifier == "beamproperties"{
            return 7
        }else if tableView.identifier == "loadlist"{
            guard selectedBeamListRow >= 0 else {
                return 0
            }
            return projectBeamCollection[selectedBeamListRow].loadCollection.count
        }else if tableView.identifier == "loadproperties"{
            return 5
        }else{
            return 0
        }
        
    }
    
   
    
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let columnIdentifier:String = tableColumn!.identifier
        
        var cell = NSTableCellView()
        var cell2 = MWButtonImageTableCellViewPrototype()
        
        if tableView.identifier == "loadlist" && columnIdentifier == "type"{
            cell2 = tableView.make(withIdentifier: columnIdentifier as String, owner: self) as! MWButtonImageTableCellViewPrototype
        }  else{
            cell = tableView.make(withIdentifier: columnIdentifier as String, owner: self) as! NSTableCellView
        }
        
        if tableView.identifier == "beamlist"{
            cell.textField?.stringValue = poplulateBeamList(row, columnID: columnIdentifier)
        }else if tableView.identifier == "beamproperties"{
            cell.textField?.stringValue = populateBeamProperties(selectedBeamListRow, row: row, columnID: columnIdentifier)
        }else if tableView.identifier == "loadlist"{
            
            cell.textField?.stringValue = populateLoadList(selectedBeamListRow, row: row, columnID: columnIdentifier)
            
            if  columnIdentifier == "type"{
                
                let typeString = populateLoadList(selectedBeamListRow, row: row, columnID: columnIdentifier)

                
                if typeString == "concentrated"{
                     let myImage = NSImage(named: "12x33_concentrated.png")
                    cell2.button?.title = ""
                    cell2.button?.image = myImage
                }else if typeString == "uniform"{
                     let myImage = NSImage(named: "40x33_Uniform.png")
                    cell2.button?.title = ""
                    cell2.button?.image = myImage
                }else if typeString == "linearup"{
                    let myImage = NSImage(named: "40x33_LinearUp.png")
                    cell2.button?.title = ""
                   cell2.button?.image = myImage
                }else if typeString == "lineardown"{
                     let myImage = NSImage(named: "40x33 LinearDown.png")
                    cell2.button?.title = ""
                    cell2.button?.image = myImage
                }
                
                return cell2
            }
            
        }else if tableView.identifier == "loadproperties"{
            cell.textField?.stringValue = populatedLoadProperties(selectedBeamListRow, selectedLoadListRow: selectedLoadListRow, row: row, columnID: columnIdentifier)
        }
    
        
        
//        if tableView.identifier == beamListTableView.identifier{
//            if row == selectedBeamListRow{
//                
//                cell.textField?.textColor = NSColor.whiteColor()
//                tableView.rowViewAtRow(selectedBeamListRow, makeIfNecessary: false)?.backgroundColor = NSColor.blueColor()
//                
//            }else{
//                
//                cell.textField?.textColor = NSColor.blackColor()
//                tableView.rowViewAtRow(selectedBeamListRow, makeIfNecessary: false)?.backgroundColor = NSColor.clearColor()
//                
//            }
//        }
//       
        
        return cell
    }
    
    
    
    
    func populatedLoadProperties(_ selectedBeamListRow: Int, selectedLoadListRow:Int, row:Int, columnID:String) ->String{
        var returnString = ""
        
        if columnID == "property"{
            if row == 0 {
                returnString = "Description:"
            }else if row == 1{
                returnString = "Load Value:"
            }else if row == 2{
                returnString = "Load Type:"
            }else if row == 3{
                returnString = "Load Start Location:"
            }else if row == 4{
                returnString = "Load End Location:"
            }
        }else if columnID == "value"{
            if selectedLoadListRow >= 0 {
                let load = projectBeamCollection[selectedBeamListRow].loadCollection[selectedLoadListRow]
                if row == 0 {
                    returnString = load.loadDescription
                }else if row == 1{
                    if load.loadType == "linearup"{
                    returnString = String(load.loadValue2)
                    }else{
                      returnString = String(load.loadValue)
                    }
                }else if row == 2{
                    returnString = load.loadType
                }else if row == 3{
                    returnString = String(load.loadStart)
                }else if row == 4{
                    returnString = String(load.loadEnd)
                }
            }else{
                returnString = "..."
            }
        }else if columnID == "units"{
            if row == 0 {
                returnString = ""
            }else if row == 1{
                if selectedLoadListRow >= 0{
                    let load = projectBeamCollection[selectedBeamListRow].loadCollection[selectedLoadListRow]
                    if load.loadType == "concentrated"{
                        returnString = "kips"
                    }else{
                        returnString = "kips per foot"
                    }
                }else{
                    returnString = "..."
                }
            }else if row == 2{
                returnString = ""
            }else if row == 3{
                returnString = "feet"
            }else if row == 4{
                returnString = "feet"
            }
        }
        
        return returnString
    }
    
    func populateLoadList(_ selectedBeamListRow: Int, row:Int, columnID:String) ->String{
        
        var returnString = "..."
        
        guard selectedBeamListRow >= 0 else{
            return returnString
        }
        guard projectBeamCollection[selectedBeamListRow].loadCollection.count > 0 else{
            return returnString
        }
        let load = projectBeamCollection[selectedBeamListRow].loadCollection[row]
        
        if columnID == "description"{
            returnString = load.loadDescription
        }else if columnID == "value"{
            if load.loadType == "linearup"{
                returnString = String(load.loadValue2)
            }else{
                returnString = String(load.loadValue)
            }
        }else if columnID == "type"{
            returnString = load.loadType
        }else if columnID == "start"{
            returnString = String(load.loadStart)
        }else if columnID == "end"{
            if load.loadType == "concentrated"{
                returnString = "n/a"
            }else{
                returnString = String(load.loadEnd)
            }
        }
        
        
        return returnString
    }
    
    
    
    func populateBeamProperties(_ selectedBeamListRow: Int, row:Int, columnID:String) ->String{
        
        var returnString = ""
        if columnID == "property"{
            if row == 0{
                returnString = "Description:"
            }else if row == 1{
                returnString = "Length:"
            }else if row == 2{
                returnString = "Support 1 Location:"
            }else if row == 3{
                returnString = "Support 2 Location:"
            }else if row == 4{
                returnString = "Moment of Inertia (I):"
            }else if row == 5{
                returnString = "Modulus of Elasticity (E):"
            }else if row == 6{
                returnString = "No. of Data Points"
            }
        }else if columnID == "value"{
            if selectedBeamListRow >= 0 && projectBeamCollection.count > 0{
                let beamGeo = projectBeamCollection[selectedBeamListRow].BeamGeo
                if row == 0{
                    returnString = beamGeo.title
                }else if row == 1{
                    returnString = String(beamGeo.length)
                }else if row == 2{
                    returnString = String(beamGeo.supportLocationA)
                }else if row == 3{
                    returnString = String(beamGeo.supportLocationB)
                }else if row == 4{
                    returnString = String(beamGeo.I)
                }else if row == 5{
                    returnString = String(beamGeo.E)
                }else if row == 6{
                    returnString = String(beamGeo.dataPointCount)
                }
            }else{
                returnString = "..."
            }
            
        }else if columnID == "units"{
            if row == 1 {
                returnString = "feet"
            }else if row == 2{
                returnString = "feet"
            }else if row == 3{
                returnString = "feet"
            }else if row == 4{
                returnString = "in^4"
            }else if row == 5{
                returnString = "ksi"
            }
        }
        return returnString
    }
    
    func poplulateBeamList(_ rowIndex:Int, columnID:String)->String{
        var returnString = ""
        
        if columnID == "description"{
            returnString = projectBeamCollection[rowIndex].BeamGeo.title
        }else if columnID == "length"{
            returnString = String(projectBeamCollection[rowIndex].BeamGeo.length)
        }else if columnID == "noofloads"{
            returnString = String(projectBeamCollection[rowIndex].loadCollection.count)
        }
        
        return returnString
    }
    
    
    //MARK: -->
    fileprivate func loadAdjustFromLengthChange(_ oldLength:Double, newLength:Double){
        guard projectBeamCollection[selectedBeamListRow].loadCollection.count != 0 else{
            return
        }
        
        if newLength < oldLength {
        
            for i:Int in 0 ..< projectBeamCollection[selectedBeamListRow].loadCollection.count{
                let load = projectBeamCollection[selectedBeamListRow].loadCollection[i]
                
                if load.loadType == "concentrated"{
                    if newLength < load.loadStart{
                        projectBeamCollection[selectedBeamListRow].loadCollection[i].loadStart = (newLength - 0.1)
                    }
                }else{
                    if newLength <= load.loadStart{
                        projectBeamCollection[selectedBeamListRow].loadCollection[i].loadStart = (newLength - 0.1)
                        projectBeamCollection[selectedBeamListRow].loadCollection[i].loadEnd = newLength
                    }else if newLength <= load.loadEnd{
                        projectBeamCollection[selectedBeamListRow].loadCollection[i].loadEnd = newLength
                    }
                }
            }
        
            loadListTableView.reloadData()
            loadPropetiesTableView.reloadData()
        
        }
        
    }
    
  
    @IBAction func addBeam(_ sender: AnyObject) {
        let beamGeo = MWBeamGeometry(theLength: 12, theE: 1200, theI: 120.34)
        
        //temporary for testing
        beamGeo.supportLocationA = 0
        beamGeo.supportLocationB = 12
        beamGeo.dataPointCount = 29
        //temporary for testing
        
        let blankLoads = [MWLoadData]()
        
        let newBeamAnalysisObj = MWBeamAnalysis(beamGeometry: beamGeo, loads: blankLoads)
        
        self.projectBeamCollection.append(newBeamAnalysisObj)
        beamListTableView.reloadData()
        
        beamListTableView.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
        
        sendBeamToDelegate(projectBeamCollection[selectedBeamListRow])
        
        
        saveData()

        
        guard projectBeamCollection[0].loadCollection.count > 0 else{
            selectedLoadListRow = -1
            return
        }
        
        selectedLoadListRow = 0
        doc.saveData.beamInterfaceData.selectedLoadListRow = 0
        
        loadListTableView.selectRowIndexes(IndexSet(integer: selectedLoadListRow), byExtendingSelection: false)
        
        
        
        loadListTableView.reloadData()
        
       
        
    }
    
    @IBAction func deleteBeam(_ sender: NSButton) {
        let index = selectedBeamListRow
        let originalCount = projectBeamCollection.count
        
        guard projectBeamCollection.count > 1 else{
            return
        }
        
        guard index >= 0 && index < originalCount else {
            return
        }
        projectBeamCollection.remove(at: index)
        
        if index > 0
        {
        selectedBeamListRow = index-1
        doc.saveData.beamInterfaceData.selectedBeamListRow = index - 2
        }
        
        
        
        beamListTableView.reloadData()
        beamListTableView.selectRowIndexes(IndexSet(integer:selectedBeamListRow), byExtendingSelection: false)
        
     
        loadListTableView.reloadData()
        
        saveData()
    }
    
    
    
    @IBAction func copyProjectBeam(_ sender: NSButton) {
        
        let originalBeamIndex = selectedBeamListRow
        
        guard originalBeamIndex >= 0 && originalBeamIndex < projectBeamCollection.count else{
            
            return
        }
        
        
        let newBeamAnalysis = projectBeamCollection[originalBeamIndex].myCopy()
        
        projectBeamCollection.append(newBeamAnalysis)
        
        beamListTableView.reloadData()
        beamListTableView.selectRowIndexes(IndexSet(integer:selectedBeamListRow), byExtendingSelection: false)
        
//        var newLoadCollection = [MWLoadData]()
//        
//        for var i:Int = 0; i < projectBeamCollection[originalBeamIndex].loadCollection.count; ++i{
//            newLoadCollection[i] = projectBeamCollection[originalBeamIndex].loadCollection[i].copy() as! MWLoadData
//        }
        
        
        saveData()
        
    }
    
    
    @IBAction func addLoad(_ sender: AnyObject) {
        
        guard projectBeamCollection.count > selectedBeamListRow && selectedBeamListRow >= 0 else{
            return
        }
        
        
        let selectedBeam = projectBeamCollection[selectedBeamListRow].BeamGeo
        let newLoad = MWLoadData(theDescription: "new_Conc_Load", theLoadValue: 1, theLoadType: "concentrated", theLoadStart: (selectedBeam.length/2), theLoadEnd: 0, theBeamGeo: selectedBeam)
        
        projectBeamCollection[selectedBeamListRow].loadCollection.append(newLoad)
        sendBeamToDelegate(projectBeamCollection[selectedBeamListRow])
        
        beamListTableView.reloadData()
        loadListTableView.reloadData()
        
        selectedLoadListRow = projectBeamCollection[selectedBeamListRow].loadCollection.count - 1
        doc.saveData.beamInterfaceData.selectedLoadListRow = projectBeamCollection[selectedBeamListRow].loadCollection.count - 1
        loadListTableView.selectRowIndexes(IndexSet(integer: selectedLoadListRow), byExtendingSelection: false)
        
       Swift.print("Made it to the end of addLoad")
        
        saveData()
        
        
    }
    
    
    @IBAction func deleteLoad(_ sender: NSButton) {
        
        guard projectBeamCollection[selectedBeamListRow].loadCollection.count > selectedLoadListRow && selectedLoadListRow >= 0 else{
            return
        }
        
        projectBeamCollection[selectedBeamListRow].loadCollection.remove(at: selectedLoadListRow)
        loadListTableView.reloadData()
        doc.saveData.beamInterfaceData.selectedLoadListRow = 0
        
        if projectBeamCollection[selectedBeamListRow].loadCollection.count > 0{
           loadListTableView.selectRowIndexes(IndexSet(integer: selectedLoadListRow), byExtendingSelection: false)
        }
        
        
        
        sendBeamToDelegate(projectBeamCollection[selectedBeamListRow])
        
        beamListTableView.reloadData()
        
        saveData()
    }
    
    
    func updateSelectedWoodBeamDesignValues(_ woodSection:MWWoodSectionDesignData, designValues: MWWoodDesignValues){
    projectBeamCollection[selectedBeamListRow].selectedWoodSection = woodSection
    projectBeamCollection[selectedBeamListRow].selectedWoodDesignValues = designValues
        
    saveData()
        
    }
    
    func updateSelectedLVLBeamDesignValues(_ LVLSection:MWLVLSectionDesignData, designValues: MWLVLDesignValues){
        projectBeamCollection[selectedBeamListRow].selectedLVLSection = LVLSection
        projectBeamCollection[selectedBeamListRow].selectedLVLDesignValues = designValues
        
        saveData()
        
    }
    
    func updateSelectedSteelWBeamDesignValues(_ steelWSection:MWSteelWSectionDesignData, designValues: MWSteelWDesignValues){
        projectBeamCollection[selectedBeamListRow].selectedSteelWSection = steelWSection
        projectBeamCollection[selectedBeamListRow].selectedSteelWDesignValues = designValues
        
        saveData()
        
    }
    
    func updateSelectedDesignTabIndex(selectedTabIndex:Int){
        guard selectedBeamListRow >= 0 && selectedBeamListRow < projectBeamCollection.count else{
            return
        }
        projectBeamCollection[selectedBeamListRow].selectedDesignTab = selectedTabIndex
        saveData()
    }
    
    func saveData(){
        
        doc.saveData.beamAnalysisCollection = projectBeamCollection as [MWBeamAnalysis]
        doc.saveData.beamInterfaceData.selectedBeamListRow = selectedBeamListRow
        doc.saveData.beamInterfaceData.selectedLoadListRow = selectedLoadListRow
        
        doc.updateChangeCount(.changeDone)
        
        if delegate != nil{
            delegate?.changeShouldUpdateSaveDocStatus(true)
        }
        
        guard doc.saveData.beamAnalysisCollection.count > 0 else{
          return
        }
        
    }

    
    
    
    
    @IBAction func clickLoadType(_ sender: AnyObject) {
        
        let row = loadListTableView.row(for: sender as! NSView)
        
        let vc_setLoadType = storyboard?.instantiateController(withIdentifier: "loadtypeselectvc") as! vc_RadioSelectLoadType
        
        vc_setLoadType.buttonRow = row
        vc_setLoadType.beam = projectBeamCollection[selectedBeamListRow].BeamGeo
        vc_setLoadType.load = projectBeamCollection[selectedBeamListRow].loadCollection[row]
        vc_setLoadType.delegate = self
    
        self.presentViewController(vc_setLoadType, asPopoverRelativeTo: sender.frame, of: sender as! NSView, preferredEdge: NSRectEdge.maxX , behavior: NSPopoverBehavior.transient)
        
    }
    
    //Mark:ProtocolFunctions
    func updateLoad(_ modifiedLoad: MWLoadData, loadRow:Int) {
        projectBeamCollection[selectedBeamListRow].loadCollection[loadRow] = modifiedLoad
        
        sendBeamToDelegate(projectBeamCollection[selectedBeamListRow])
        
        saveData()
        
        loadListTableView.reloadData()
        loadPropetiesTableView.reloadData()
    }
    
    
    
    
    @IBAction func click_LoadDown(_ sender: NSButton) {
        
        let index = selectedLoadListRow
        let newIndex = index + 1
        
        let originalCollection = projectBeamCollection[selectedBeamListRow].loadCollection
        let tempLoadCollection = collectionReorderer.moveCollectionItemDown(originalCollection, selectedIndex: index)
        
        
        guard tempLoadCollection.count > 0 else{
            return
        }
        
        projectBeamCollection[selectedBeamListRow].loadCollection = tempLoadCollection
        projectBeamCollection[selectedBeamListRow].updateComboResults()
        
        selectedLoadListRow = newIndex
        doc.saveData.beamInterfaceData.selectedLoadListRow = newIndex
        sendBeamToDelegate(projectBeamCollection[selectedBeamListRow])
        
        saveData()
        
        loadListTableView.reloadData()
        loadListTableView.selectRowIndexes(IndexSet(integer: newIndex), byExtendingSelection: false)
        
    }
    
    @IBAction func click_LoadUp(_ sender: NSButton) {
        
        let index = selectedLoadListRow
        let newIndex = index - 1
        
        let originalCollection = projectBeamCollection[selectedBeamListRow].loadCollection
        let tempLoadCollection = collectionReorderer.moveCollectionItemUp(originalCollection, selectedIndex: index)
        
        
        guard tempLoadCollection.count > 0 else{
            return
        }
        
            projectBeamCollection[selectedBeamListRow].loadCollection = tempLoadCollection
            projectBeamCollection[selectedBeamListRow].updateComboResults()
            selectedLoadListRow = newIndex
            doc.saveData.beamInterfaceData.selectedLoadListRow = newIndex
            //now send the updated data to the splitview main
            sendBeamToDelegate(projectBeamCollection[selectedBeamListRow])
            
            loadListTableView.reloadData()
            loadListTableView.selectRowIndexes(IndexSet(integer: newIndex), byExtendingSelection: false)
        
        
        saveData()
       
    }
    
    @IBAction func click_BeamDown(_ sender: NSButton) {
        
        let index = selectedBeamListRow
        let newIndex = index + 1
        
        let originalCollection = projectBeamCollection
        let tempLoadCollection = collectionReorderer.moveCollectionItemDown(originalCollection, selectedIndex: index)
        
        
        guard tempLoadCollection.count > 0 else{
            return
        }
        
        projectBeamCollection = tempLoadCollection
        beamListTableView.reloadData()
        beamListTableView.selectRowIndexes(IndexSet(integer: newIndex), byExtendingSelection: false)
        selectedBeamListRow = newIndex
        doc.saveData.beamInterfaceData.selectedBeamListRow = newIndex
        sendBeamToDelegate(projectBeamCollection[selectedBeamListRow])
        
//        loadListTableView.reloadData()
//        loadListTableView.selectRowIndexes(NSIndexSet(index: newIndex), byExtendingSelection: false)
        
        saveData()
        
    }
    
    @IBAction func click_BeamUp(_ sender: NSButton) {
        
        let index = selectedBeamListRow
        let newIndex = index - 1
        
        let originalCollection = projectBeamCollection
        let tempLoadCollection = collectionReorderer.moveCollectionItemUp(originalCollection, selectedIndex: index)
        
        
        guard tempLoadCollection.count > 0 else{
            return
        }
        
        projectBeamCollection = tempLoadCollection
        beamListTableView.reloadData()
        beamListTableView.selectRowIndexes(IndexSet(integer: newIndex), byExtendingSelection: false)
        selectedBeamListRow = newIndex
        doc.saveData.beamInterfaceData.selectedBeamListRow = newIndex
        sendBeamToDelegate(projectBeamCollection[selectedBeamListRow])
        
        saveData()
    }
    
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoadGenSelector"{
            let VC_LoadGenSelector = segue.destinationController as! vc_GeneratorConditionSelector
            
            if projectBeamCollection.count > 0{
            VC_LoadGenSelector.a = projectBeamCollection[selectedBeamListRow]
            VC_LoadGenSelector.delegate = self
            }
            
        }
    }

    func sendLoadCollection(_ beamAndLoads:MWBeamAnalysis){
        self.projectBeamCollection[selectedBeamListRow] = beamAndLoads
        sendBeamToDelegate(projectBeamCollection[selectedBeamListRow])
        
        beamListTableView.reloadData()
        loadListTableView.reloadData()
        
        selectedLoadListRow = projectBeamCollection[selectedBeamListRow].loadCollection.count - 1
        doc.saveData.beamInterfaceData.selectedLoadListRow = projectBeamCollection[selectedBeamListRow].loadCollection.count - 1
        loadListTableView.selectRowIndexes(IndexSet(integer: selectedLoadListRow), byExtendingSelection: false)
        
        Swift.print("Made it to the end of Auto Load Generate")
        
        saveData()
        
    }
   
    
    
}


