//
//  MWLVLBeamDesign.swift
//  ResiBeam_V0.0.7
//
//  Created by Mark Walker on 8/17/16.
//  Copyright © 2016 Mark Walker. All rights reserved.
//

import Cocoa

class MWLVLBeamDesign: NSObject {
        
        var a = MWBeamAnalysis()
    
        var LVLDesignSectionCollection = [MWLVLLoadedDesignSection]()
        
        
        
        
        
        override init(){
            super.init()
        }
        
        init(a:MWBeamAnalysis,  LVLSection:MWLVLSectionDesignData, LVLDesignValues:MWLVLDesignValues){
            
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
            
            LVLDesignSectionCollection.removeAll(keepingCapacity: false)
            
            guard a.shearComboResults.graphTotals.theDataCollection.count > 0 else{
                return
            }
            for i in 0...a.shearComboResults.graphTotals.theDataCollection.count-1{
                //initialize the ith member
                //let woodLoadedSection = MWWoodLoadedDesignSection(thesectionData: a.selectedWoodSection)
                let LVLLoadedSection = MWLVLLoadedDesignSection()
                
                //add the new member to the collection
                LVLDesignSectionCollection.append(LVLLoadedSection)
                //set the remaining values of this ith item in collection
                LVLDesignSectionCollection[i].location = Double(a.shearComboResults.graphTotals.theDataCollection[i].x)
                LVLDesignSectionCollection[i].setShear(Double(a.shearComboResults.graphTotals.theDataCollection[i].y), sectionData: a.selectedLVLSection)
                
                LVLDesignSectionCollection[i].setMoment(Double(a.momentComboResults.graphTotals.theDataCollection[i].y), sectionData: a.selectedLVLSection)
                
                LVLDesignSectionCollection[i].setDeflection(Double(a.deflectionComboResults.graphTotals.theDataCollection[i].y), IOriginal:a.BeamGeo.I, EOriginal:a.BeamGeo.E,EAdjust:a.selectedLVLDesignValues.EAdjust, sectionData: a.selectedLVLSection)
                
            }//end for
        }
        
        
        //MARK: NSCoding Conformance
        required init?(coder aDecoder: NSCoder) {
            super.init()
            
            a = aDecoder.decodeObject(forKey: "a") as! MWBeamAnalysis
            a.selectedLVLSection = aDecoder.decodeObject(forKey: "LVLSectionData") as! MWLVLSectionDesignData
            
            LVLDesignSectionCollection = aDecoder.decodeObject(forKey: "LVLDesignSectionCollection") as! [MWLVLLoadedDesignSection]
            
            a.selectedLVLDesignValues = aDecoder.decodeObject(forKey: "LVLDesignValues") as! MWLVLDesignValues
            
        }
        
        
        func encodeWithCoder(_ aCoder: NSCoder) {
            aCoder.encode(a, forKey: "a")
            aCoder.encode(a.selectedLVLSection, forKey: "LVLSectionData")
            aCoder.encode(LVLDesignSectionCollection, forKey: "LVLDesignSectionCollection")
            aCoder.encode(a.selectedLVLDesignValues, forKey: "LVLDesignValues")
            
        }
    }
    


