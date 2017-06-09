//
//  MWTextField_NumberInput.swift
//  BeamDesigner_V0.0.4
//
//  Created by Mark Walker on 9/30/15.
//  Copyright © 2015 Mark Walker. All rights reserved.
//

import Cocoa

class MWTextField_NumberInput: NSTextField {

    var allowsNegative = false
    var allowsZero = false
    var hasPositiveLimit = true
    var positiveLimit:Double = 1000000
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    func isValid()->Bool{
        var returnVal = true
        
        if allowsNegative == false{
            if isPositive() == false{
                returnVal = false
            }
        }
        
        if allowsZero == false{
            if isNonZero() == false{
                returnVal = false
            }
        }
        
        if hasPositiveLimit == true{
            if isWithinLimits() == false{
                returnVal = false
            }
        }
        
        if isNumber() == false{
            returnVal = false
        }
        
        
        if returnVal == false{
            setInvalidBackground()
        }else{
            setValidBackGround()
        }
        
        return returnVal
    }
    
    fileprivate func setInvalidBackground(){
        self.backgroundColor = NSColor(calibratedRed: 1, green: 0, blue: 0, alpha: 0.40)
        self.window?.makeFirstResponder(self.window?.contentView)
    
    }
    
    fileprivate func setValidBackGround(){
        self.backgroundColor = NSColor.white
    }
    
    fileprivate func isPositive()->Bool{
        var returnVal = false
        if self.doubleValue >= 0 {
            returnVal = true
        }
        return returnVal
    }
    
    fileprivate func isNonZero()->Bool{
        var returnVal = false
        if self.doubleValue != 0.0{
            returnVal = true
        }
        return returnVal
    }
    
    fileprivate func isNumber()->Bool{
        var returnVal = false
        
        if self.doubleValue == 0.0 && self.stringValue != "0"{
            returnVal = false
        }else{
            returnVal = true
        }
        return returnVal
    }

    fileprivate func isWithinLimits()->Bool{
        var returnVal = false
        
        if self.doubleValue <= positiveLimit{
            returnVal = true
        }
        return returnVal
    }
    
    
}
