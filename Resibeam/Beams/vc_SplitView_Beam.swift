//
//  vc_SplitView_Beam.swift
//  ResiBeam_V0.0.7
//
//  Created by Mark Walker on 3/19/16.
//  Copyright © 2016 Mark Walker. All rights reserved.
//

import Cocoa
protocol beamDataDelegate{
    func beamDataUpdate(_ beamAndLoadData:MWBeamAnalysis, selectedDesignTab:Int)
    func updateSaveDocWithWoodDesignChange(_ sectionData:MWWoodSectionDesignData, designValues: MWWoodDesignValues)
    
    func updateSaveDocWithLVLDesignChange(_ sectionData:MWLVLSectionDesignData, designValues: MWLVLDesignValues)
    
    func updateSaveDocWithSteelWDesignChange(_ sectionData:MWSteelWSectionDesignData, designValues: MWSteelWDesignValues)
    
    func updateSaveDocWithFlitchDesignChange(_ sectionData:MWFlitchSectionDesignData, designValues: MWFlitchDesignValues)
    
    
    func updateSaveDocWithSelectedDesignTabIndex(selectedTabIndex:Int)
    
    func changeShouldUpdateSaveDocStatus(_ B:Bool)
    
    func addConcentratedLoad()
}




class vc_SplitView_Beam: NSSplitViewController, beamDataDelegate, statusBarDelegate {

    var vcBeamData = vc_BeamData()
    var vcBeamGraphs = vc_BeamGraphs()
    var tvcBeamDesign = tvc_BeamDesign()
    var vcWoodBeamDesign = vc_WoodBeamDesignPanel()
    var vcLVLBeamDesign = vc_LVLBeamDesignPanel()
    var vcSteelWBeamDesign = vc_SteelWBeamDesignPanel()
    //var vcFlitchBeamDesign = vc_FlitchBeamDesignPanel()
    
    var tvcFlitchDesign = tvc_FlitchDesign()
    var vcFlitchBeamDesignPanel = vc_FlitchBeamDesignPanel()
   
    var statDelegate:statusBarDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        vcBeamData = self.childViewControllers[0] as! vc_BeamData
        vcBeamData.delegate = self
    
        
        vcBeamGraphs = self.childViewControllers[1] as! vc_BeamGraphs
        vcBeamGraphs.splitViewDelegate = self
        
        tvcBeamDesign = self.childViewControllers[2] as! tvc_BeamDesign
        tvcBeamDesign.delegate = self
        
        vcWoodBeamDesign = tvcBeamDesign.childViewControllers[0] as! vc_WoodBeamDesignPanel
        vcWoodBeamDesign.delegate = self
        vcWoodBeamDesign.statusDelegate = self
        
        vcLVLBeamDesign = tvcBeamDesign.childViewControllers[1] as! vc_LVLBeamDesignPanel
        vcLVLBeamDesign.delegate = self
        vcLVLBeamDesign.statusDelegate = self
        
        vcSteelWBeamDesign = tvcBeamDesign.childViewControllers[2] as! vc_SteelWBeamDesignPanel
        vcSteelWBeamDesign.delegate = self
        vcSteelWBeamDesign.statusDelegate = self
        
        
//        tvcFlitchDesign = tvcBeamDesign.childViewControllers[3] as! tvc_FlitchDesign
//        tvcFlitchDesign.delegate = self
        
//        vcFlitchBeamDesignPanel = tvcBeamDesign.childViewControllers[3] as! vc_FlitchBeamDesignPanel
//        vcFlitchBeamDesignPanel.delegate = self
//        vcFlitchBeamDesignPanel.statusDelegate = self
        
        
    }
    
    
    //function pushes the MWBeamAnalyis Object to the graphs and design panel
    func beamDataUpdate(_ beamAndLoadData: MWBeamAnalysis, selectedDesignTab:Int) {
        
        vcBeamGraphs.a = beamAndLoadData
        vcBeamGraphs.updateGraphs()
        
        vcWoodBeamDesign.design.a = beamAndLoadData
        vcWoodBeamDesign.design.updateDesignSectionCollections()
        vcWoodBeamDesign.updateViews()
        
        vcLVLBeamDesign.design.a = beamAndLoadData
        vcLVLBeamDesign.design.updateDesignSectionCollections()
        vcLVLBeamDesign.updateTables()
        
        vcSteelWBeamDesign.design.a = beamAndLoadData
        vcSteelWBeamDesign.design.updateDesignSectionCollections()
        vcSteelWBeamDesign.updateViews()
        
        
        //select the correct tab
        tvcBeamDesign.updateDesignTabSelection(theTab: selectedDesignTab)
        
       //update the status
        if (selectedDesignTab == 0){
            vcWoodBeamDesign.updateStatus()
        }else if (selectedDesignTab == 1){
            vcLVLBeamDesign.updateStatus()
        }else if (selectedDesignTab == 2){
            vcSteelWBeamDesign.updateStatus()
        }
        
    }
    
    //pushes changes from the right to the left
    func updateSaveDocWithWoodDesignChange(_ sectionData:MWWoodSectionDesignData, designValues: MWWoodDesignValues){
        vcBeamData.updateSelectedWoodBeamDesignValues(sectionData,designValues: designValues)
    }
    
    func updateSaveDocWithLVLDesignChange(_ sectionData:MWLVLSectionDesignData, designValues: MWLVLDesignValues){
        vcBeamData.updateSelectedLVLBeamDesignValues(sectionData,designValues: designValues)
    }
    
    func updateSaveDocWithSteelWDesignChange(_ sectionData:MWSteelWSectionDesignData, designValues: MWSteelWDesignValues){
        vcBeamData.updateSelectedSteelWBeamDesignValues(sectionData,designValues: designValues)
    }
    
    func updateSaveDocWithFlitchDesignChange(_ sectionData:MWFlitchSectionDesignData, designValues: MWFlitchDesignValues){
        //vcBeamData.updateSelectedFlitchBeamDesignValues(sectionData, designValues: designValues)
    }
    
    func updateSaveDocWithSelectedDesignTabIndex(selectedTabIndex:Int){
        vcBeamData.updateSelectedDesignTabIndex(selectedTabIndex: selectedTabIndex)
    }
    
    func changeShouldUpdateSaveDocStatus(_ B: Bool) {
        vcWoodBeamDesign.shouldUpdateSaveDocOnSelectionChange = B
        vcLVLBeamDesign.shouldUpdateSaveDocOnSelectionChange = B
        vcSteelWBeamDesign.shouldUpdateSaveDocOnSelectionChange = B
    }
    
    func updateStatus(theString: String, theColor: NSColor) {
        if statDelegate != nil{
            statDelegate.updateStatus(theString: theString, theColor: theColor)
        }
    }
    
    
    //functions to allow loadGraph to add loads from functions in the vcBeamData
    
    func addConcentratedLoad(){
        vcBeamData.addLoad(self)
    }
    
    
    
   
}
