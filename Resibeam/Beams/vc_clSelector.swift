//
//  vc_clSelector.swift
//  ResiBeam_V0.0.7
//
//  Created by Mark Walker on 7/3/16.
//  Copyright © 2016 Mark Walker. All rights reserved.
//

import Cocoa

class vc_clSelector: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var criteriaTable: NSTableView!
    @IBOutlet weak var leTable: NSTableView!
    @IBOutlet weak var geometryTable: NSTableView!
    
    var receiverDelegate:MWFactorReceiver?
    var factor = "Cl"
    
    var clCalc = MWWoodCLCalculator()
    var selectedLoadingCondition = clLoadingCondition.AnyOtherLoadingCondition
    var a = MWBeamAnalysis()
    
    var w = 1.0
    var d = 1.0
    var lu = 1.0
    var fbStar = 1.0
    var eMin = 1.0
    
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
        //set the local variable
        w = a.selectedWoodSection.width
        d = a.selectedWoodSection.depth
        fbStar = a.selectedWoodDesignValues.FbStar
        eMin = a.selectedWoodDesignValues.limits.Emin
        
        
        leTable.isEnabled = false
        geometryTable.isEnabled = false
        
        
    }
    
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let table = notification.object as! NSTableView
        
        guard table.selectedRow != -1 else{
            return
        }
        
        
        
        if table.identifier == "criteriaTable"{
            if table.selectedRow == 5{
                leTable.isEnabled = true
                geometryTable.isEnabled = true
            }else{
                leTable.isEnabled = false
                geometryTable.isEnabled = false
            }
        }else if table.identifier == "leTable"{
            switch table.selectedRow{
            case 0: selectedLoadingCondition = clLoadingCondition.Cantilever_UniformlyDistributed
            case 1: selectedLoadingCondition = clLoadingCondition.Cantilever_ConcentratedLoadAtUnsupportedEnds
            case 2: selectedLoadingCondition = clLoadingCondition.SimpleSpan_UniformlyDistributedLoad
            case 3: selectedLoadingCondition = clLoadingCondition.SimpleSpan_ConcentratedLoadAtCenterWithNoIntermediateSupportAtCenter
            case 4: selectedLoadingCondition = clLoadingCondition.SimpleSpan_ConcentratedLoadAtCenterWithLateralSupportAtCenter
            case 5: selectedLoadingCondition = clLoadingCondition.SimpleSpan_TwoEqualConcrentratedLoadsAtThirdPointsWithLateralSupportsAtThirdPoints
            case 6: selectedLoadingCondition = clLoadingCondition.SimpleSpan_ThreeEqualConcrentratedLoadsAtFourthPointsWithLateralSupportsAtFourthPoints
            case 7: selectedLoadingCondition = clLoadingCondition.SimpleSpan_FourEqualConcrentratedLoadsAtFifthPointsWithLateralSupportsAtFifthPoints
            case 8: selectedLoadingCondition = clLoadingCondition.SimpleSpan_FiveEqualConcrentratedLoadsAtSixthPointsWithLateralSupportsAtSixthPoints
            case 9: selectedLoadingCondition = clLoadingCondition.SimpleSpan_SixEqualConcrentratedLoadsAtSeventhPointsWithLateralSupportsAtSeventhPoints
            case 10: selectedLoadingCondition = clLoadingCondition.SimpleSpan_SevenOrMoreEqualConcentratedLoadsEvenlySpacedWithLateralSupportAtPointsOfLoadApplication
            case 11: selectedLoadingCondition = clLoadingCondition.SimpleSpan_SevenOrMoreEqualConcentratedLoadsEvenlySpacedWithLateralSupportAtPointsOfLoadApplication
            case 12: selectedLoadingCondition = clLoadingCondition.AnyOtherLoadingCondition
            default: selectedLoadingCondition = clLoadingCondition.AnyOtherLoadingCondition
                
            }
            
            clCalc.loadingCondition = selectedLoadingCondition
            
            criteriaTable.reloadData()
            criteriaTable.selectRowIndexes(IndexSet(integer: 5), byExtendingSelection: false)
        }
        
        
        
    }
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        var rowCount = 0
        guard let tableID = tableView.identifier else{
            return 0
        }
        
        switch tableID{
        case ("criteriaTable"): rowCount = 6
        case ("leTable"): rowCount = 13
        case ("geometryTable"): rowCount = 5
        default: rowCount = 0
        }
        
        return rowCount
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let strIdentifier:NSString = tableColumn!.identifier as NSString
        let cell = tableView.make(withIdentifier: strIdentifier as String, owner: self) as! NSTableCellView
        
        guard let columnIndex = Int(strIdentifier as String) else{
            return cell
        }

        let grid = (row, columnIndex)
        var str = ""
        
        
        if tableView.identifier == "criteriaTable"{
            
            let cl = clCalc.calculatedCl
            
            switch grid{
            case (0,0): str = "depth / width < 2.."; case (0,1): str = "Cd = 1.00"
            case (1,0): str = "depth / width between 2 & 4, end bracing provided"; case(1,1): str = "Cd = 1.00"
            case (2,0): str = "depth / width between 4 & 5, end bracing & subfloor provided"; case(2,1): str = "Cd = 1.00"
            case (3,0): str = "depth / width between 5 & 6, brace@8' + ends & subfloor provided"; case(3,1): str = "Cd = 1.00"
            case (4,0): str = "depth / width between 6 & 7, contiuous top & bottom bracing"; case(4,1): str = "Cd = 1.00"
            case (5,0):str = "Calculate based upon unbraced length lu"; case (5,1): str = String(cl)
                
            default: str = "x"
            }
            
        }else if tableView.identifier == "leTable"{
            
            if clCalc.luOverd < 7{
                switch grid{
                case (0,0): str = "Cantilever - Uniformly distributed"; case(0,1): str = "le = 1.33 x lu"
                case (1,0): str = "Cantilever - Concentrated loat at unsupported ends"; case(1,1): str = "le = 1.87 x lu"
                case (2,0): str = "Simple Span - Uniformly distributed load";  case(2,1): str = "le = 2.06 x lu"
                case (3,0): str = "Simple Span - Concentrated load at center with no intermediate support at center"; case(3,1): str = "le = 1.80 x lu"
                case (4,0): str = "Simple Span - Concentrated Load at center with lateral support at center"; case (4,1): str = "le = 1.11 x lu"
                case (5,0): str = "Simple Span - Two equal concrentrated loads at 1/3 points with lateral supports at 1/3 points"; case (5,1): str = "le = 1.68 x lu"
                case (6,0): str = "Simple Span -  Three equal concentrated loads at 1/4 points with lateral support at 1/4 points"; case (6,1): str = "le = 1.54 x lu"
                case (7,0): str = "Simple Span - Four equal concentrated loads at 1/5 points with lateral support at 1/5 points"; case (7,1): str = "le = 1.68 x lu"
                case (8,0): str = "Simple Span - Five equal concentrated loads at 1/6 points with lateral support at 1/6 points"; case (8,1): str = "le = 1.73 x lu"
                case (9,0): str = "Simple Span - Six equal concentrated loads at 1/7 points with lateral support at 1/7 points"; case (9,1): str = "le = 1.78 x lu"
                case (10,0): str = "Simple Span - Seven or more equal concentrated loads, evenly spaced, with lateral support at points of load application"; case (10,1): str = "le = 1.84 x lu"
                case (11,0): str = "Simple Span: Equal end moments"; case (11,1): str = "le = 1.84 x lu"
                case (12,0): str = "Any loading condition than listed above"; case(12,1): str = "le = 2.06 x lu"
                default: str = "error"
                }

            
            }else if clCalc.luOverd >= 7 && clCalc.luOverd <= 14.3{
                
                
                switch grid{
                case (0,0): str = "Cantilever - Uniformly Distributed"; case(0,1): str = "le = 0.90 x lu + 3d"
                case (1,0): str = "Cantilever - Concentrated loat at unsupported ends"; case(1,1): str = "le = 1.44 x lu + 3d"
                case (2,0): str = "Simple Span - Uniformly Distributed Load"; case(2,1): str = "le = 1.63 x lu + 3d"
                case (3,0): str = "Simple Span - Concentrated Load At Center With No Intermediate Support At Center"; case(3,1): str = "le = 1.37 x lu + 3d"
                case (4,0): str = "Simple Span - Concentrated Load At Center With Lateral Support At Center"; case (4,1): str = "le = 1.11 x lu"
                case (5,0): str = "Simple Span - Two Equal Concrentrated Loads At 1/3 Points With Lateral Supports At 1/3 Points"; case (5,1): str = "le = 1.68 x lu"
                case (6,0): str = "Simple Span -  Three equal concentrated loads at 1/4 points with lateral support at 1/4 points"; case (6,1): str = "le = 1.54 x lu"
                case (7,0): str = "Simple Span - Four equal concentrated loads at 1/5 points with lateral support at 1/5 points"; case (7,1): str = "le = 1.68 x lu"
                case (8,0): str = "Simple Span - Five equal concentrated loads at 1/6 points with lateral support at 1/6 points"; case (8,1): str = "le = 1.73 x lu"
                case (9,0): str = "Simple Span - Six equal concentrated loads at 1/7 points with lateral support at 1/7 points"; case (9,1): str = "le = 1.78 x lu"
                case (10,0): str = "Simple Span - Seven Or More Equal Concentrated Loads, Evenly Spaced, With Lateral Support At Points Of Load Application"; case (10,1): str = "le = 1.84 x lu"
                case (11,0): str = "Simple Span  - Equal End Moments"; case (11,1): str = "le = 1.84 x lu"
                case (12,0): str = "Any Other Loading Condition"; case(12,1): str = "le = 1.63 x lu + 3d"
                default: str = "error"
                }
                
                
            }else if clCalc.luOverd > 14.3{
                
             
                
                switch grid{
                case (0,0): str = "Cantilever - Uniformly distributed"; case(0,1): str = "le = 0.90 x lu + 3d"
                case (1,0): str = "Cantilever - Concentrated loat at unsupported ends"; case(1,1): str = "le = 1.44 x lu + 3d"
                case (2,0): str = "Simple Span - Uniformly distributed load"; case(2,1): str = "le = 1.63 x lu + 3d"
                case (3,0): str = "Simple Span - Concentrated load at center with no intermediate support at center"; case(3,1): str = "le = 1.37 x lu + 3d"
                case (4,0): str = "Simple Span - Concentrated Load at center with lateral support at center"; case (4,1): str = "le = 1.11 x lu"
                case (5,0): str = "Simple Span - Two equal concrentrated loads at 1/3 points with lateral supports at 1/3 points"; case (5,1): str = "le = 1.68 x lu"
                case (6,0): str = "Simple Span -  Three equal concentrated loads at 1/4 points with lateral support at 1/4 points"; case (6,1): str = "le = 1.54 x lu"
                case (7,0): str = "Simple Span - Four equal concentrated loads at 1/5 points with lateral support at 1/5 points"; case (7,1): str = "le = 1.68 x lu"
                case (8,0): str = "Simple Span - Five equal concentrated loads at 1/6 points with lateral support at 1/6 points"; case (8,1): str = "le = 1.73 x lu"
                case (9,0): str = "Simple Span - Six equal concentrated loads at 1/7 points with lateral support at 1/7 points"; case (9,1): str = "le = 1.78 x lu"
                case (10,0): str = "Simple Span - Seven or more equal concentrated loads, evenly spaced, with lateral support at points of load application"; case (10,1): str = "le = 1.84 x lu"
                case (11,0): str = "Simple Span: Equal end moments"; case (11,1): str = "le = 1.84 x lu"
                case (12,0): str = "Any loading condition than listed above";  case(12,1): str = "le = 1.84 x lu"
                default: str = "error"
                }
               
             
                
            }
            
            
        }else if tableView.identifier == "geometryTable"{
            
            switch grid{
            case (0,0): str = "member width (w)"; case (0,1): str = String(w)
            case (1,0): str = "member depth (d)"; case (1,1): str = String(d)
            case (2,0): str = "unbranced length (lu)"; case (2,1): str = String(lu)
            case (3,0): str = "Fb*"; case (3,1): str = String(fbStar)
            case(4,0): str = "Emin"; case (4,1):str = String(eMin)
            default: str = "error"
            }
            
        }
        
        
        
        
        cell.textField?.stringValue = str
        
        return cell
    }
    
    
    
    
    @IBAction func click_Save(_ sender: AnyObject) {
        
        guard receiverDelegate != nil else{
            return
        }
        
        if criteriaTable.selectedRow == 5{
            receiverDelegate?.sendReceiveFactor(factor, theDouble: clCalc.calculatedCl, secondDouble: 1.0, thirdDouble: 1.0)
        }else{
           receiverDelegate?.sendReceiveFactor(factor, theDouble: 1.0, secondDouble: 1.0, thirdDouble: 1.0)
        }
        
        self.dismiss(self)
    }
    
    
    @IBAction func click_PerformCalc(_ sender: AnyObject) {
        
        clCalc.setValues(w, d: d, Lu: lu, Emin: eMin, FbStar: fbStar, loadCondition: selectedLoadingCondition)
    
        criteriaTable.reloadData()
    }

    @IBAction func onGeometryValueEdit(_ sender: AnyObject) {
        
        let row = geometryTable.selectedRow
       
        guard let doubleVal = Double(sender.stringValue) else{
            criteriaTable.reloadData()
            geometryTable.reloadData()
            return
        }
        
        if row == 0{
            w = doubleVal
        }else if row == 1{
            d = doubleVal
        }else if row == 2{
            lu = doubleVal
        }else if row == 3{
            fbStar = doubleVal
        }else if row == 4{
            eMin = doubleVal
        }
        
        clCalc.setValues(w, d: d, Lu: lu, Emin: eMin, FbStar: fbStar, loadCondition: selectedLoadingCondition)
        criteriaTable.reloadData()
        geometryTable.reloadData()
        
        criteriaTable.selectRowIndexes(IndexSet(integer: 5), byExtendingSelection: false)
        
    }
    
}
