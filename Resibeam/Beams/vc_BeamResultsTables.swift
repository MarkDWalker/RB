//
//  vc_BeamResultsTables.swift
//  BeamStory2
//
//  Created by Mark Walker on 12/9/14.
//  Copyright (c) 2014 Mark Walker. All rights reserved.
//

import Cocoa

class vc_BeamResultsTables: NSViewController {

    var graphData = [NSPoint]()
    var valueUnits:NSString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    
    
    
    func numberOfRowsInTableView(_ aTableView: NSTableView!) -> Int
    {

        let numberOfRows:Int = graphData.count
        return numberOfRows
    }
    
    func tableView(_ tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let strIdentifier:NSString = tableColumn!.identifier as NSString

        let intIdentifier:Int = strIdentifier.integerValue
        
        let cell = tableView.make(withIdentifier: strIdentifier as String, owner: self) as! NSTableCellView
        cell.textField?.stringValue = getStringFromCollection(row, columnIndex: intIdentifier)
        
        return cell;
    }
    
    func getStringFromCollection (_ rowIndex:Int, columnIndex:Int) -> String{
        var theString = NSString()
        var valueUnits:NSString = ""
        
        if self.title == "Shear Data" {
            valueUnits = "kips"
        }else if self.title == "Moment Data" {
            valueUnits = "ft-kips"
        }else if self.title == "Deflection Data" {
            valueUnits = "inches"
        }
    
        if columnIndex == 0{
            
            theString = NSString(format:"%i",rowIndex)
            
        }else if  columnIndex == 1 {
            
            theString = ((NSString(format:"%.2f", Float(graphData[rowIndex].x)) as String) + " ft") as NSString

        }else if columnIndex == 2 {
            
            theString = ((NSString(format:"%.2f", Float(self.graphData[rowIndex].y)) as String) + " " + (valueUnits as String)) as NSString
            
        }else {
            //catch an error
            
        }
        return theString as String
        
        
    } //end function
    
}
