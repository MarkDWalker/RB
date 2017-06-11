//
//  MWFlitchLoadedDesignSection.swift
//  Resibeam
//
//  Created by Mark Walker on 6/11/17.
//  Copyright © 2017 Mark Walker. All rights reserved.
//

import Cocoa

class MWFlitchLoadedDesignSection: NSObject {
    
    //MARK: Public Vars
    var useModSection:Bool = false
    var location:Double = 0 //value on feet
    var designShear:Double = 0 //value in kips
    var designMoment:Double = 0 //value in ft-kips
    var deflection:Double = 0 //inches
    
    var shearStress:Double=0 //ksi
    var bendingStress:Double=0 //ksi
    
    
    override init(){
        
    }
    
    func setShear(_ theShearVal:Double, sectionData:MWFlitchSectionDesignData){
        designShear = theShearVal
        updateShearStress(sectionData)
    }
    
    func updateShearStress(_ sectionData:MWFlitchSectionDesignData){
        if sectionData.shapeSelected == true {
            //fv = 3 * V / (2 * b * d) for rectangular section
            shearStress = 3 * designShear / (2 * sectionData.width * sectionData.depth )
        } else {
            shearStress = 1.5 * designShear /  sectionData.vArea
        }
        
    }
    
    func setMoment(_ theMomentVal:Double, sectionData:MWFlitchSectionDesignData){
        designMoment = theMomentVal
        updateBendingStress(sectionData)
    }
    
    func updateBendingStress(_ sectionData:MWFlitchSectionDesignData){
        //fb = M/S this works for steel and wood
        bendingStress = designMoment * 12 / sectionData.sectionModulus
    }
    
    func setDeflection(_ theDeflectionVal:Double, IOriginal:Double, EOriginal:Double, EAdjust:Double, sectionData:MWFlitchSectionDesignData){
        
        //The right panel I and E will probably be different that the left panel and the graph
        //perform the deflection modification for this here. Deflections are /EI... so we need
        //to * (EOriginal/sF.EAdjust) and * (IOrginal/IAdjust) and will have the modified deflection
        deflection = theDeflectionVal * (IOriginal / sectionData.I) * (EOriginal / EAdjust)
    }
    
    
    //MARK: NSCoding Conformance
    required init?(coder aDecoder: NSCoder) {
        super.init()
        useModSection = aDecoder.decodeBool(forKey: "useModSection")
        location = aDecoder.decodeDouble(forKey: "location")
        designShear = aDecoder.decodeDouble(forKey: "designShear")
        designMoment = aDecoder.decodeDouble(forKey: "designMoment")
        deflection = aDecoder.decodeDouble(forKey: "deflection")
        shearStress = aDecoder.decodeDouble(forKey: "shearStress")
        bendingStress = aDecoder.decodeDouble(forKey: "bendingStress")
        
        
    }
    
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(useModSection, forKey: "useModSection")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(designShear, forKey: "designShear")
        aCoder.encode(designMoment, forKey: "designMoment")
        aCoder.encode(deflection, forKey: "deflection")
        aCoder.encode(shearStress, forKey: "shearStress")
        aCoder.encode(bendingStress, forKey: "bendingStress")
        
    }
    
}//End Class
