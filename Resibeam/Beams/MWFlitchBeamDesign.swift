//
//  MWFlitchBeamDesign.swift
//  Resibeam
//
//  Created by Mark Walker on 6/10/17.
//  Copyright © 2017 Mark Walker. All rights reserved.
//


import Cocoa

class MWFlitchBeamDesign: NSObject {
    
    var a = MWBeamAnalysis()
    
    var FlitchDesignSectionCollection = [MWFlitchLoadedDesignSection]()
    
    
    
    
    
    override init(){
        super.init()
    }
    
    init(a:MWBeamAnalysis,  FlitchSection:MWFlitchSectionDesignData, FlitchDesignValues:MWFlitchDesignValues){
        
        super.init()
        updateDesignSectionCollections()
    }
    
    func setValues(_ a:MWBeamAnalysis){
        self.a = a
        
        a.selectedFlitchDesignValues.setValues(a.selectedFlitchDesignValues.limits.species, theGrade: a.selectedFlitchDesignValues.limits.grade, memberWidth: a.selectedFlitchSection.depth)
        
        updateDesignSectionCollections()
    }
    
    func updateDesignSectionCollections(){
        //The following changes necessitate a call to this function
        //  1. a change in the shear and moment values. Basically a change to the left panel data
        //  2. a change to the section data. Bascially a change in shape (specifically I affects the defelction values)
        //  3. a change to the adjustment factors, Specifically the adjust E value which again affects deflection.
        
        FlitchDesignSectionCollection.removeAll(keepingCapacity: false)
        
        guard a.shearComboResults.graphTotals.theDataCollection.count > 0 else{
            return
        }
        for i in 0...a.shearComboResults.graphTotals.theDataCollection.count-1{
            //initialize the ith member
            //let woodLoadedSection = MWWoodLoadedDesignSection(thesectionData: a.selectedWoodSection)
            let FlitchLoadedSection = MWFlitchLoadedDesignSection()
            
            //add the new member to the collection
            FlitchDesignSectionCollection.append(FlitchLoadedSection)
            //set the remaining values of this ith item in collection
            FlitchDesignSectionCollection[i].location = Double(a.shearComboResults.graphTotals.theDataCollection[i].x)
            FlitchDesignSectionCollection[i].setShear(Double(a.shearComboResults.graphTotals.theDataCollection[i].y), sectionData: a.selectedFlitchSection)
            
            FlitchDesignSectionCollection[i].setMoment(Double(a.momentComboResults.graphTotals.theDataCollection[i].y), sectionData: a.selectedFlitchSection)
            
            FlitchDesignSectionCollection[i].setDeflection(Double(a.deflectionComboResults.graphTotals.theDataCollection[i].y), IOriginal:a.BeamGeo.I, EOriginal:a.BeamGeo.E,EAdjust:a.selectedFlitchDesignValues.EAdjust, sectionData: a.selectedFlitchSection)
            
        }//end for
    }
    
    
    //MARK: NSCoding Conformance
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        a = aDecoder.decodeObject(forKey: "a") as! MWBeamAnalysis
        a.selectedFlitchSection = aDecoder.decodeObject(forKey: "FlitchSectionData") as! MWFlitchSectionDesignData
        
        FlitchDesignSectionCollection = aDecoder.decodeObject(forKey: "FlitchDesignSectionCollection") as! [MWFlitchLoadedDesignSection]
        
        a.selectedFlitchDesignValues = aDecoder.decodeObject(forKey: "FlitchDesignValues") as! MWFlitchDesignValues
        
    }
    
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(a, forKey: "a")
        aCoder.encode(a.selectedFlitchSection, forKey: "FlitchSectionData")
        aCoder.encode(FlitchDesignSectionCollection, forKey: "FlitchDesignSectionCollection")
        aCoder.encode(a.selectedFlitchDesignValues, forKey: "FlitchDesignValues")
        
    }
}



