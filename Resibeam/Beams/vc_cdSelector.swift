//
//  vc_cdSelector.swift
//  ResiBeam_V0.0.7
//
//  Created by Mark Walker on 7/1/16.
//  Copyright © 2016 Mark Walker. All rights reserved.
//

import Cocoa

class vc_cdSelector: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!
    
    
    var receiverDelegate:MWFactorReceiver?
    
    var tableColumnTitle = "Description"
    
    var factor = "Cd"
    var factorVal = 1.0
    var factorValFv = 1.0
    var factorValE = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
         tableView.tableColumns[0].title = tableColumnTitle
        
        
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        var rowCount = 0
        
        if factor == "Cd"{
           rowCount = 6
        }else if factor == "Cm"{
            rowCount = 2
        }else if factor == "Ct"{
            rowCount = 5
        }else if factor == "Cf"{
            rowCount = 3
        }else if factor == "Cfu"{
            rowCount = 5
        }else if factor == "Cr"{
            rowCount = 2
        }else if factor == "Cl"{
            rowCount = 6
        }
        
        return rowCount
    }
    
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let table = notification.object as! NSTableView
        
        guard table.selectedRow != -1 else{
            return
        }
        
        let row = table.selectedRow
        
        
        if factor == "Cd"{
            if row == 0{
                factorVal = 0.90
            }else if row == 1{
                factorVal = 1.0
            }else if row == 2{
                factorVal = 1.15
            }else if row == 3{
                factorVal = 1.25
            }else if row == 4{
                factorVal = 1.60
            }else if row == 5{
                factorVal = 2.0
            }
        }else if factor == "Cm"{
            if row == 0{
                factorVal = 1.0 //"Moisture Content < 19% ....... Cm_Fb = 1.00  |  Cm_Fv = 1.00  |  Cm_E = 1.00"
                factorValFv = 1.0
                factorValE = 1.0
            }else if row == 1{
                factorVal = 0.85//"Moisture Content < 19% ....... Cm_Fb = 0.85  |  Cm_Fv = 0.97  |  Cm_E = 0.90"
                factorValFv = 0.97
                factorValE = 0.97
            }
        }else if factor == "Ct"{
            if row == 0 {
                factorVal = 1.00 //"Temperature < 100 (wet or dry) ....... Ct_Fb = 1.00  |  Ct_Fv = 1.00  |  Ct_E = 1.00"
                factorValFv = 1.0
                factorValE = 1.0
            }else if row == 1{
                factorVal = 0.80//"Temperature > 100  & < 125 (dry) .... Ct_Fb = 0.80  |  Ct_Fv = 0.80  |  Ct_E = 0.90"
                factorValFv = 0.80
                factorValE = 0.90
            }else if row == 2{
                factorVal = 0.70 //"Temperature > 100  & < 125 (wet) .... Ct_Fb = 0.70  |  Ct_Fv = 0.70  |  Ct_E = 0.90"
                factorValFv = 0.70
                factorValE = 0.90
            }else if row == 3{
                factorVal =  0.70 //"Temperature > 125 (dry) ................... Ct_Fb = 0.70  |  Ct_Fv = 0.70  |  Ct_E = 0.90"
                factorValFv = 0.70
                factorValE = 0.90
            }else if row == 4{
                factorVal = 0.50 //"Temperature > 125 (wet) ................... Ct_Fb = 0.50  |  Ct_Fv = 0.50  |  Ct_E = 0.90"
                factorValFv = 0.50
                factorValE = 0.90
            }
        }else if factor == "Cf"{
            if row == 0{
                factorVal = 0.90
            }else if row == 1{
                factorVal = 1.0
            }else if row == 2{
                factorVal = 0.9
            }
        }else if factor == "Cfu"{
            if row == 0{
                factorVal = 1.0
            }else if row == 1{
                factorVal = 1.10
            }else if row == 2{
                factorVal = 1.20
            }else if row == 3{
                factorVal = 1.10
            }else if row == 4{
                factorVal = 1.10
            }
        }else if factor == "Cr"{
            if row == 0{
                factorVal = 1.0
            }else if row == 1{
                factorVal = 1.15
            }
        }

        
        
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        
        let strIdentifier:NSString = tableColumn!.identifier as NSString
        //let intIdentifier:Int = strIdentifier.integerValue
        
        let cell = tableView.make(withIdentifier: strIdentifier as String, owner: self) as! NSTableCellView
        
        var str = ""
        
        if factor == "Cd"{
            if row == 0{
                str = " Cd = 0.90, Permanent"
            }else if row == 1{
                str = " Cd = 1.0, Ten Years"
            }else if row == 2{
                str = " Cd = 1.15, Two Months"
            }else if row == 3{
                str = " Cd = 1.25, Seven Days"
            }else if row == 4{
                str = " Cd = 1.60, Ten Minutes"
            }else if row == 5{
                str = " Cd = 2.0, Impact"
            }
        }else if factor == "Cm"{
            if row == 0{
                str = "Moisture Content <= 19% ...... Cm_Fb = 1.00  |  Cm_Fv = 1.00  |  Cm_E = 1.00"
            }else if row == 1{
                str = "Moisture Content > 19% ....... Cm_Fb = 0.85  |  Cm_Fv = 0.97  |  Cm_E = 0.90"
            }
        }else if factor == "Ct"{
            if row == 0 {
                str = "Temperature < 100 (wet or dry) ....... Ct_Fb = 1.00  |  Ct_Fv = 1.00  |  Ct_E = 1.00"
            }else if row == 1{
                str = "Temperature > 100  & < 125 (dry) .... Ct_Fb = 0.80  |  Ct_Fv = 0.80  |  Ct_E = 0.90"
            }else if row == 2{
                str = "Temperature > 100  & < 125 (wet) .... Ct_Fb = 0.70  |  Ct_Fv = 0.70  |  Ct_E = 0.90"
            }else if row == 3{
                str = "Temperature > 125 (dry) ................... Ct_Fb = 0.70  |  Ct_Fv = 0.70  |  Ct_E = 0.90"
            }else if row == 4{
                str = "Temperature > 125 (wet) ................... Ct_Fb = 0.50  |  Ct_Fv = 0.50  |  Ct_E = 0.90"
            }
        }else if factor == "Cf"{
            if row == 0{
                str = "Member Depth > 12 inches .............. Cf_Fb = 0.90"
            }else if row == 1{
                str = "Member Depth < 4 inches ............... Cf_Fb = 1.00"
            }else if row == 2{
                str = "Member Depth between 4 & 8 inches ..... Cf_Fb = 0.90"
            }
        }else if factor == "Cfu"{
            if row == 0{
                str = "Member Loaded on Narrow Face .......................... Cfu_Fb = 1.0"
            }else if row == 1{
                str = "2x & 3x, 4-8 inch depth, Load on Wide Face ............ Cfu_Fb = 1.10"
            }else if row == 2{
                str = "2x & 3x, 10 inch & wider depth, Load on Wide Face ..... Cfu_Fb = 1.20"
            }else if row == 3{
                str = "4x up to 10 inch depth Load on Wide Face .............. Cfu_Fb = 1.10"
            }else if row == 4{
                str = "4x 10 inch depth and wider, Load on Wide Face ......... Cfu_Fb = 1.10"
            }
        }else if factor == "Cr"{
            if row == 0{
                str = "Not a repetative member ..... Cr = 1.0"
            }else if row == 1{
                str = "Repetative member. More then 3 members < 24 inch spacing .. Cr = 1.15"
            }
        }
    
        cell.textField?.stringValue = str
    
        return cell
        
    }
    
    
    @IBAction func click_Save(_ sender: AnyObject) {
        
        guard receiverDelegate != nil else{
            return
        }
    
            receiverDelegate?.sendReceiveFactor(factor, theDouble: factorVal, secondDouble: factorValFv, thirdDouble: factorValE)
        
        
        self.dismiss(self)
    }
    
    
}
