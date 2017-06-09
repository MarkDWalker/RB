//
//  ViewController_FSFvSelector.swift
//  BeamDesigner
//
//  Created by Mark Walker on 5/16/15.
//  Copyright (c) 2015 Mark Walker. All rights reserved.
//

import Cocoa

protocol FSFvMatrixSelectDelegate{
    func setFSFvMatrixIndex(_ theIndex:Int, CalculatedFSFv:Double)
}

class vc_FSFvSelector: NSViewController {

    var delegate:FSFvMatrixSelectDelegate?
    
    var selectedIndex:Int = -1
    var initialTag:Int = 2
    var inputError = false
    
    var specifiedSectionData = MWSteelWSectionDesignData()
    var FsCalc:MWSteelWFSCalculator = MWSteelWFSCalculator()
    var designValues = MWSteelWDesignValues()

    
    @IBOutlet weak var textView_Custom: NSTextField!
    @IBOutlet weak var radioMatrix: NSMatrix!
    @IBOutlet weak var label_Index1String: NSTextField!
    @IBOutlet weak var label_h: NSTextField!
    @IBOutlet weak var label_tw: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        print("designValues.limits.FY:\(designValues.limits.Fy)")
        
        FsCalc.setValues(specifiedSectionData.bf, tf: specifiedSectionData.tf, rt: specifiedSectionData.rt, Fy: designValues.limits.Fy/1000, d: specifiedSectionData.depth, Lu: designValues.steelFactors.FSLu, h: specifiedSectionData.h, tw:specifiedSectionData.webThickness)
        
        if initialTag == 2{
            textView_Custom.stringValue =  "\(designValues.steelFactors.fvSafetyFactor)"

        }
        
        
        label_Index1String.stringValue = NSString(format:"%.2f",FsCalc.FSFv()) as String + " x Fy"
        label_h.stringValue = "\(specifiedSectionData.h)"
        label_tw.stringValue = "\(specifiedSectionData.webThickness)"
        
        radioMatrix.selectCell(withTag: initialTag)
        
        selectedIndex = initialTag
        
        
        print("the h(3) is \(specifiedSectionData.h).........")
    }
    
    @IBAction func click_Matrix(_ sender: NSMatrix) {
        
        selectedIndex = radioMatrix.selectedCell()!.tag
    }
    
    @IBAction func click_Select(_ sender: NSButton) {
        if selectedIndex == 2 {
            if textView_Custom.stringValue != "0.0" && textView_Custom.doubleValue == 0.0{
                inputError = true
            }else{
                inputError = false
            }
            
            
            if inputError == true{
                //do nothing throw a flag
                textView_Custom.stringValue = "INPUT ERROR"
            }else if inputError == false && delegate != nil{
                delegate?.setFSFvMatrixIndex(selectedIndex, CalculatedFSFv: textView_Custom.doubleValue)
                self.dismissViewController(self)
            }//end if

        }else if selectedIndex == 1{
            delegate?.setFSFvMatrixIndex(selectedIndex, CalculatedFSFv: FsCalc.FSFv())
            self.dismissViewController(self)
        }
    }
}
