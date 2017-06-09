//
//  MWSteelWFSCalculator.swift
//  BeamDesigner
//
//  Created by Mark Walker on 5/13/15.
//  Copyright (c) 2015 Mark Walker. All rights reserved.
//

import Cocoa

class MWSteelWFSCalculator: NSObject {

    
    var bf:Double = 1           //flange width (inches)
    var tf:Double = 1           //flange thickness (inches)
    var tw:Double = 1           //web thickness (inches)
    var h:Double = 1            //clear distance between flanges (inches)
    var rt:Double = 1           //flange and 1/3 web radius of gyration (inches)
    var Fy:Double = 1           //yield strength of steel (ksi)
    var d:Double = 1            //beam depth (inches)
    var LuInches:Double = 1     //unbraced length (inches)
    let Cb:Double = 1.0         //set conservatively at 1.0
    
    var compactLimitRolledFlange:Double{
        get{
            return 65 / sqrt(Fy)
        }
    }
    
    var nonCompactLimitRolledFlange:Double{
        get{
            return 95 / sqrt(Fy)
        }
    }
    
    var rolledFlangeBTRatio:Double{
        get{
           return (bf / 2) / tf
        }
    }
    
    var compact:Bool = false
    var nonCompact:Bool = false
    var slender:Bool = false
    
    override init(){
        super.init()
    }
    
    init(bf:Double, tf:Double, rt:Double, Fy:Double, d:Double, Lu:Double){
        super.init()
        self.bf = bf
        self.tf = tf
        self.rt = rt
        self.Fy = Fy
        self.d = d
        self.LuInches = Lu
        
        if rolledFlangeBTRatio <= compactLimitRolledFlange{
            compact = true; nonCompact = false; slender = false
        }else if rolledFlangeBTRatio > compactLimitRolledFlange && rolledFlangeBTRatio <= nonCompactLimitRolledFlange{
            compact = false; nonCompact = true; slender = false
        }else if rolledFlangeBTRatio > nonCompactLimitRolledFlange{
            compact = false; nonCompact = false; slender = true
        }
    }
    
    func setValues(_ bf:Double, tf:Double, rt:Double, Fy:Double, d:Double, Lu:Double, h:Double, tw:Double){
        self.bf = bf
        self.tf = tf
        self.rt = rt
        self.Fy = Fy
        self.d = d
        self.LuInches = Lu
        self.h = h
        self.tw = tw
        
        if rolledFlangeBTRatio <= compactLimitRolledFlange{
            compact = true; nonCompact = false; slender = false
        }else if rolledFlangeBTRatio > compactLimitRolledFlange && rolledFlangeBTRatio <= nonCompactLimitRolledFlange{
            compact = false; nonCompact = true; slender = false
        }else if rolledFlangeBTRatio > nonCompactLimitRolledFlange{
            compact = false; nonCompact = false; slender = true
        }
    }
    
    func setLuValue(_ Lu:Double){
        self.LuInches = Lu
        
        if rolledFlangeBTRatio <= compactLimitRolledFlange{
            compact = true; nonCompact = false; slender = false
        }else if rolledFlangeBTRatio > compactLimitRolledFlange && rolledFlangeBTRatio <= nonCompactLimitRolledFlange{
            compact = false; nonCompact = true; slender = false
        }else if rolledFlangeBTRatio > nonCompactLimitRolledFlange{
            compact = false; nonCompact = false; slender = true
        }
    }
    
    
    ///////////////////////////////////////
    
    func Lc1()->Double{
        return 76 * bf / sqrt(Fy) //(F1-2)
    }
    
    func Lc2()->Double{
        let Af:Double = bf*tf
        return 20000 / ((d / Af) * Fy) //(F1-2)
    }
    
    func Lc()->Double{
        if Lc1() <= Lc2(){
            return Lc1()
        }else{
            return Lc2()
        }
    }
    
    func lOverRtLimit1()->Double{
        return sqrt(102000 * Cb / Fy)
    }
    
    func lOverRtLimit2()->Double{
        return sqrt(510000 * Cb / Fy)
    }
    
    func lOverRt()->Double{
        return LuInches / rt
    }
    
    func FSFbSimpleNonCompact()->Double{
        var returnValue:Double = 0
        returnValue = 0.79 - (0.002 * bf * sqrt(Fy) / (2 * tf))
        
        if returnValue > 0.66 {
            returnValue = 0.66
        }
        
        return returnValue
    }
    
    ///this is what we are really after
    func FSFb()->Double{
        var returnValue:Double = 0.00
        if compact == true && LuInches <= Lc(){ //(F1-1)
            returnValue = 0.66
        }else if nonCompact == true && LuInches <= Lc(){   //(F1-3)
            returnValue = 0.79 - (0.002 * bf * sqrt(Fy) / (2 * tf))
        }else if slender == false && LuInches > Lc() && lOverRt() <= lOverRtLimit2(){
            let fs:Double = 0.67 - (Fy * pow(lOverRt(), 2)/(1530000 * Cb))
            if fs < 0.60 {
                returnValue = fs
            }else{
                returnValue = 0.60
            }
        }else if slender == false && LuInches > Lc() && lOverRt() > lOverRtLimit2(){
            let fs:Double = 170000 * Cb / (pow(lOverRt(), 2))
            if fs < 0.60 {
                returnValue = fs
            }else{
                returnValue = 0.60
            }
        }
        
        print ("L/Rt = \(lOverRt())")
        print ("Limit 1 = \(lOverRtLimit1())")
        print ("Limit 2 = \(lOverRtLimit2())")
        return returnValue
        
        
    }
    
    
    ////////////////Shear
    
    func vLimit()->Double{
        var vLimit:Double
        print("vlimit Fy: \(Fy)")
        vLimit = 380.00 / sqrt(Fy)
        print("Vlimit: \(vLimit)")
        return vLimit
    }
    
    func hOverTw()->Double{
        let returnVal = h / tw
        
        print("hOverTw: \(returnVal)")
        
        return returnVal
    }
    
    func aOverH()->Double{
        let a:Double = h //assumes no traverse stiffeners
        return a / h
    }
    
    func Kv1()->Double{
        return 4 + (5.34 / (pow(aOverH(), 2)))
    }
    
    func Kv2()->Double{
        return 5.34 + (4 / (pow(aOverH(), 2)))
    }
    
    func Cv1()->Double{
        var returnValue:Double = 0.00
        if aOverH()<=1{ //this means we use Kv1
            returnValue = 45000 * Kv1() / (Fy * pow(hOverTw(), 2))
        }else{          //this means we use Kv2
           returnValue = 45000 * Kv2() / (Fy * pow(hOverTw(), 2))
        }
        
        return returnValue
    }
    
    func Cv2()->Double{
        var returnValue:Double = 0.00
        
        if aOverH()<=1{ //this means we use Kv1
            returnValue = (190 / hOverTw()) * sqrt(Kv1()/Fy)
        }else{          //this means we use Kv2
            returnValue = (190 / hOverTw()) * sqrt(Kv2()/Fy)
        }
        
        return returnValue
    }
    
    func FSFv()->Double{
        var returnValue:Double = 0.00
        
        if hOverTw() <= vLimit(){
            returnValue = 0.40
        }else if hOverTw() > vLimit() && Cv1() <= 0.80{
            returnValue = Cv1() / 2.89
        }else if hOverTw() > vLimit() && Cv1() > 0.80{
            returnValue = Cv2() / 2.89
        }
        return returnValue
    }
    
    
}
