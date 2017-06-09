//
//  MWSteelWBeamDesign.swift
//  ResiBeam_V0.0.7
//
//  Created by Mark Walker on 8/21/16.
//  Copyright © 2016 Mark Walker. All rights reserved.
//

import Cocoa

class MWSteelWBeamDesign: NSObject {

    var a = MWBeamAnalysis()
    
    var steelWDesignSectionCollection = [MWSteelWLoadedDesignSection]()
    
    
    
    
    
    override init(){
        super.init()
    }
    
    init(a:MWBeamAnalysis,  steelWSection:MWSteelWSectionDesignData, steelWDesignValues:MWSteelWDesignValues){
        
        super.init()
        updateDesignSectionCollections()
    }
    
    func setValues(_ a:MWBeamAnalysis){
        self.a = a
        
        a.selectedLVLDesignValues.setValues(a.selectedLVLDesignValues.limits.manufacturer, theGrade: a.selectedLVLDesignValues.limits.grade, memberWidth: a.selectedLVLSection.depth)
        
        updateDesignSectionCollections()
    }
    
    func updateDesignSectionCollections(){
        //The following changes necessitate a call to this function
        //  1. a change in the shear and moment values. Basically a change to the left panel data
        //  2. a change to the section data. Bascially a change in shape (specifically I affects the defelction values)
        //  3. a change to the adjustment factors, Specifically the adjust E value which again affects deflection.
        
        steelWDesignSectionCollection.removeAll(keepingCapacity: false)
        guard a.shearComboResults.graphTotals.theDataCollection.count > 0 else{
            return
        }
        for i in 0...a.shearComboResults.graphTotals.theDataCollection.count-1{
            //initialize the ith member
            //let woodLoadedSection = MWWoodLoadedDesignSection(thesectionData: a.selectedWoodSection)
            let steelWLoadedSection = MWSteelWLoadedDesignSection()
            
            //add the new member to the collection
            steelWDesignSectionCollection.append(steelWLoadedSection)
            //set the remaining values of this ith item in collection
            steelWDesignSectionCollection[i].location = Double(a.shearComboResults.graphTotals.theDataCollection[i].x)
            steelWDesignSectionCollection[i].setShear(Double(a.shearComboResults.graphTotals.theDataCollection[i].y), sectionData: a.selectedSteelWSection)
            
            steelWDesignSectionCollection[i].setMoment(Double(a.momentComboResults.graphTotals.theDataCollection[i].y), sectionData: a.selectedSteelWSection)
            
            steelWDesignSectionCollection[i].setDeflection(Double(a.deflectionComboResults.graphTotals.theDataCollection[i].y), IOriginal:a.BeamGeo.I, EOriginal:a.BeamGeo.E,EAdjust:a.selectedSteelWDesignValues.EAdjust, sectionData: a.selectedSteelWSection)
            
        }//end for
    }
    
    
    //MARK: NSCoding Conformance
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        a = aDecoder.decodeObject(forKey: "a") as! MWBeamAnalysis
        a.selectedSteelWSection = aDecoder.decodeObject(forKey: "steelWSectionData") as! MWSteelWSectionDesignData
        
        steelWDesignSectionCollection = aDecoder.decodeObject(forKey: "steelWDesignSectionCollection") as! [MWSteelWLoadedDesignSection]
        
        a.selectedSteelWDesignValues = aDecoder.decodeObject(forKey: "steelWDesignValues") as! MWSteelWDesignValues
        
    }
    
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(a, forKey: "a")
        aCoder.encode(a.selectedSteelWSection, forKey: "steelWSectionData")
        aCoder.encode(steelWDesignSectionCollection, forKey: "steelWDesignSectionCollection")
        aCoder.encode(a.selectedSteelWDesignValues, forKey: "steelWDesignValues")
        
    }

    
}
