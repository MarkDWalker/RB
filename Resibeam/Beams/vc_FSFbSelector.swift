//
//  vc_FSFbSelector.swift
//  BeamDesigner
//
//  Created by Mark Walker on 5/13/15.
//  Copyright (c) 2015 Mark Walker. All rights reserved.
//

import Cocoa

protocol FSFbMatrixSelectDelegate{
    func setFSFbMatrixIndex(_ theIndex:Int, CalculatedFSFb:Double, Lu:Double)
}

class vc_FSFbSelector: NSViewController {

    var delegate:FSFbMatrixSelectDelegate?
    
    var selectedIndex:Int = -1
    var initialTag:Int = 4
    var inputError:Bool = false
    
    var specifiedSectionData = MWSteelWSectionDesignData()
    var FsCalc:MWSteelWFSCalculator = MWSteelWFSCalculator()
    var designValues = MWSteelWDesignValues()
    var classificationString:String = "Compact"
    
    @IBOutlet weak var radioMatrix: NSMatrix!
    
    @IBOutlet weak var textView_Custom: NSTextField!
    @IBOutlet weak var textView_Lu: NSTextField!
    @IBOutlet weak var label_index2String: NSTextField!
    @IBOutlet weak var label_index3String: NSTextField!
    @IBOutlet weak var theBox: NSBox!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
       
        
        //set up the object that will do the calculations
        FsCalc.setValues(specifiedSectionData.bf, tf: specifiedSectionData.tf, rt: specifiedSectionData.rt, Fy: designValues.limits.Fy/1000, d: specifiedSectionData.depth, Lu: designValues.steelFactors.FSLu, h:specifiedSectionData.h, tw:specifiedSectionData.webThickness)
        
       
        
        //set the title of the box
        if FsCalc.compact == true{
            classificationString = "Compact"
        }else if FsCalc.nonCompact == true{
            classificationString = "Non Compact"
        }else if FsCalc.slender == true{
            classificationString = "Slender"
        }
        
        print("designVales.FSLu = \(designValues.steelFactors.FSLu) inches")
        print("FSCalc.LC() = \(FsCalc.Lc()) inches")
        
        theBox.title = "Fy Bending Factor of Safety - \(classificationString), Lc = " + (NSString(format:"%.2f",FsCalc.Lc()) as String) as String + " inches"
        
        //set up the Lu values
        textView_Lu.stringValue = "\(designValues.steelFactors.FSLu)"
        
        if initialTag == 4{
            textView_Custom.stringValue = NSString(format:"%.2f",designValues.steelFactors.fbSafetyFactor) as String
        }
        
        label_index2String.stringValue = NSString(format:"%.2f",FsCalc.FSFbSimpleNonCompact()) as String + " x Fy"
        label_index3String.stringValue = NSString(format:"%.2f",FsCalc.FSFb()) as String + " x Fy"
        textView_Lu.stringValue = "\(designValues.steelFactors.FSLu)"
        selectedIndex = initialTag

        radioMatrix.selectCell(withTag: initialTag)
    }
    
    @IBAction func click_Matrix(_ sender: AnyObject) {
        selectedIndex = radioMatrix.selectedCell()!.tag
    }
    
   
    @IBAction func click_reCalculate(_ sender: NSButton) {
        designValues.steelFactors.FSLu = textView_Lu.doubleValue
        designValues.steelFactors.fbSafetyFactor = FsCalc.FSFb()
        
        //set the title of the box
        if FsCalc.compact == true{
            classificationString = "Compact"
        }else if FsCalc.nonCompact == true{
            classificationString = "Non Compact"
        }else if FsCalc.slender == true{
            classificationString = "Slender"
        }
        
        //set the index 3 stuff
        
        if textView_Lu.stringValue != "0.0" && textView_Lu.doubleValue == 0.0 {
            //we have an error
            textView_Lu.stringValue = "INPUT ERROR"
        } else{
            FsCalc.setLuValue(textView_Lu.doubleValue)
            designValues.steelFactors.FSLu = FsCalc.LuInches
            label_index3String.stringValue = NSString(format:"%.2f",FsCalc.FSFb()) as String + " x Fy"
        }

    }
    
    
    
    
    @IBAction func click_Select(_ sender: NSButton) {
        
        if selectedIndex == 4 {
            if textView_Custom.stringValue != "0.0" && textView_Custom.doubleValue == 0.0{
                inputError = true
            }else{
                inputError = false
            }
            
            
            if inputError == true{
                //do nothing throw a flag
                textView_Custom.stringValue = "INPUT ERROR"
            }else if inputError == false && delegate != nil{
                delegate?.setFSFbMatrixIndex(selectedIndex, CalculatedFSFb: textView_Custom.doubleValue, Lu: designValues.steelFactors.FSLu)
                self.dismissViewController(self)
            }//end if
            
        }else if selectedIndex == 3{
            if textView_Lu.stringValue != "0.0" && textView_Lu.doubleValue == 0.0{
                inputError = true
            }else{
                inputError = false
            }
            
            if inputError == true{
                textView_Lu.stringValue = "INPUT ERROR"
            }else{
                delegate?.setFSFbMatrixIndex(selectedIndex, CalculatedFSFb: FsCalc.FSFb(), Lu: FsCalc.LuInches)
                self.dismissViewController(self)
            }
            
        }else if selectedIndex == 2 {
            delegate?.setFSFbMatrixIndex(selectedIndex, CalculatedFSFb: FsCalc.FSFbSimpleNonCompact(), Lu: designValues.steelFactors.FSLu)
            self.dismissViewController(self)
        }else if selectedIndex == 1 {
            delegate?.setFSFbMatrixIndex(selectedIndex, CalculatedFSFb: 0.66, Lu: FsCalc.LuInches)
            self.dismissViewController(self)
        }
    }

}
