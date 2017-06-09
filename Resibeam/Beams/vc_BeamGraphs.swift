//
//  ViewController2.swift
//  BeamStory
//
//  Created by Mark Walker on 11/16/14.
//  Copyright (c) 2014 Mark Walker. All rights reserved.
//

import Cocoa

protocol graphDataDelegate{
    
    func graphDataUpdate(_ beamAndLoads:MWBeamAnalysis)
}


class vc_BeamGraphs: NSViewController{
    
    
    //MARK: Public Vars
    //this defines the protocol and this object as the master
    var delegate: graphDataDelegate?
    
    //Four custom views to add to the view Controller
    var loadGraph = MWLoadGraphView()
    var shearGraph = MWBeamGraphView()
    var momentGraph = MWBeamGraphView()
    var deflectionGraph = MWBeamGraphView()

    //these one (1) item is udpated by the the left pane via the splitview
    var a:MWBeamAnalysis = MWBeamAnalysis()
    
//    var loadCollection = [MWLoadData]()
//    var beam = MWBeamGeometry(theLength: 10, theE: 1600, theI: 105.47)
//    var selectedLoadIndex:Int = 0
//    
//    var myShearGraphTotal = MWLoadComboResult()
//    var myMomentGraphTotal = MWLoadComboResult()
//    var myDeflectionGraphTotal = MWLoadComboResult()
    
   
    //MARK:IBOutlets
    @IBOutlet weak var radioLoadLabels: NSMatrix!
    
    
    //MARK:Public Functions
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        updateGraphs()
    }
    
    
    func addControls(){
        self.view.addSubview(loadGraph)
        self.view.addSubview(shearGraph)
        self.view.addSubview(momentGraph)
        self.view.addSubview(deflectionGraph)
        
        
        ///////////Dictionary for the layout constraints
        var myDict = Dictionary<String, NSView>()
        
        self.loadGraph.translatesAutoresizingMaskIntoConstraints = false
        self.shearGraph.translatesAutoresizingMaskIntoConstraints = false
        self.momentGraph.translatesAutoresizingMaskIntoConstraints = false
        self.deflectionGraph.translatesAutoresizingMaskIntoConstraints = false
        
        myDict["LG"] = self.loadGraph
        myDict["SG"] = self.shearGraph
        myDict["MG"] = self.momentGraph
        myDict["DG"] = self.deflectionGraph
        ///////////
        
        
        //Layout Constraints
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[LG(>=400)]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: myDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[SG(>=400)]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: myDict))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[MG(>=400)]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: myDict))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[DG(>=400)]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: myDict))
        
        
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-65-[LG(>=150)]-[SG(==LG)]-[MG(==SG)]-[DG(==SG)]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: myDict))
        
        
        
        
//        // this is the initial load
//        let cLoad = MWLoadData(theDescription: "L1", theLoadValue : 0.125, theLoadType : "uniform", theLoadStart : 0, theLoadEnd : 10,theBeamGeo : a.BeamGeo)
//        
//        
//        //add the initial load
//        a.appendLoadCollection(cLoad)
        
        
    }
    
    
    
    
    func updateGraphs(){
        
        
            
            if self.view.subviews.count == 5 {
            self.view.subviews.remove(at: 4)
            self.view.subviews.remove(at: 3)
            self.view.subviews.remove(at: 2)
            self.view.subviews.remove(at: 1)
            }
        
        
        if a.loadCollection.count > 0 {
            addControls()
            
            //now put the load combo results into the actual beam view object that are subviews
            shearGraph.loadDataCollection(a.BeamGeo, theTitle: "Shear", theLoadComboResult: a.shearComboResults, xPadding: 80, yPadding: 50, optionalMaxUnits:"kips")
            
            momentGraph.loadDataCollection(a.BeamGeo, theTitle: "Moment", theLoadComboResult: a.momentComboResults, xPadding: 80, yPadding: 50, optionalMaxUnits: "ft-Kips")
            
            deflectionGraph.loadDataCollection(a.BeamGeo, theTitle: "Deflection", theLoadComboResult: a.deflectionComboResults, xPadding: 80, yPadding: 50, optionalMaxUnits: "inches")
            
            
            //redraw the view objects
            var shearPointsToLabel=[NSPoint]()
            var momentPointsToLabel=[NSPoint]()
            var deflectionPointsToLabel=[NSPoint]()
            
            //println("the tag is - \(radioLoadLabels.selectedCell().tag())")
            
            //////////      let selectedTag = radioLoadLabels.selectedCell()!.tag
            //let selectedLoadIndex = a.selectedLoadIndex
            //////////print ("Cell Selected - \(selectedTag) - Load# - \(selectedLoadIndex)")
            if a.selectedLoadIndex < a.shearComboResults.resultsCollection.count && a.selectedLoadIndex >= 0 && radioLoadLabels.selectedCell()!.tag == 0{
                shearPointsToLabel = a.shearComboResults.resultsCollection[a.selectedLoadIndex].theDataCollection
                momentPointsToLabel = a.momentComboResults.resultsCollection[a.selectedLoadIndex].theDataCollection
                deflectionPointsToLabel = a.deflectionComboResults.resultsCollection[a.selectedLoadIndex].theDataCollection
            }else{
                shearPointsToLabel = a.shearComboResults.graphTotals.theDataCollection
                momentPointsToLabel = a.momentComboResults.graphTotals.theDataCollection
                deflectionPointsToLabel = a.deflectionComboResults.graphTotals.theDataCollection
            }
            
            shearGraph.drawAllWithLabelsOn(shearPointsToLabel, selectedLoadIndex:a.selectedLoadIndex)
            momentGraph.drawAllWithLabelsOn(momentPointsToLabel, selectedLoadIndex:a.selectedLoadIndex)
            deflectionGraph.drawAllWithLabelsOn(deflectionPointsToLabel, selectedLoadIndex:a.selectedLoadIndex)
            ////////////////////////
            
            
            
            //for the load graph
            //this gives the load graph view the appropriate data
            loadGraph.loadCollection = a.loadCollection
            loadGraph.loadDataCollection(a.BeamGeo, theLoadCollection: a.loadCollection, xPadding: 80, yPadding: 50)
            
            //This should redraw the based upon the new data
            self.loadGraph.drawGraphs(a.selectedLoadIndex) //for the load
            loadGraph.display()
            
            //send the data graphs up the chain to the splitViewController
            if delegate != nil{
                delegate?.graphDataUpdate(a)
            }
        }
        
    }
    
    override func viewDidLayout() {
        
        if a.loadCollection.count > 0{
            
            
            self.loadGraph.drawGraphs(a.selectedLoadIndex)
            
            //redraw the view objects
            var shearPointsToLabel=[NSPoint]()
            var momentPointsToLabel=[NSPoint]()
            var deflectionPointsToLabel=[NSPoint]()
            
            if a.selectedLoadIndex < a.shearComboResults.resultsCollection.count && a.selectedLoadIndex >= 0 && radioLoadLabels.selectedCell()!.tag == 0{
                shearPointsToLabel = a.shearComboResults.resultsCollection[a.selectedLoadIndex].theDataCollection
                momentPointsToLabel = a.momentComboResults.resultsCollection[a.selectedLoadIndex].theDataCollection
                deflectionPointsToLabel = a.deflectionComboResults.resultsCollection[a.selectedLoadIndex].theDataCollection
            }else{
                shearPointsToLabel = a.shearComboResults.graphTotals.theDataCollection
                momentPointsToLabel = a.momentComboResults.graphTotals.theDataCollection
                deflectionPointsToLabel = a.deflectionComboResults.graphTotals.theDataCollection
            }
            
            self.shearGraph.drawAllWithLabelsOn(shearPointsToLabel, selectedLoadIndex:a.selectedLoadIndex)
            self.momentGraph.drawAllWithLabelsOn(momentPointsToLabel, selectedLoadIndex:a.selectedLoadIndex)
            self.deflectionGraph.drawAllWithLabelsOn(deflectionPointsToLabel, selectedLoadIndex:a.selectedLoadIndex)
            
            //send the data graphs up the chain to the splitViewController
            if delegate != nil{
                
                delegate?.graphDataUpdate(a)
            }
        }
    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
         let VC_Dest:vc_BeamResultsTables = segue.destinationController as! vc_BeamResultsTables
        
        if radioLoadLabels.selectedCell()!.tag == 0 { //if tag != 1 i.e. 0 then we show the graph data for the selected load
            if segue.identifier == "V" {
                VC_Dest.graphData = a.shearComboResults.resultsCollection[a.selectedLoadIndex].theDataCollection
                VC_Dest.title = "Shear Data"
            }else if segue.identifier == "M" {
                VC_Dest.graphData = a.momentComboResults.resultsCollection[a.selectedLoadIndex].theDataCollection
                VC_Dest.title = "Moment Data"
            }else if segue.identifier == "D" {
                VC_Dest.graphData = a.deflectionComboResults.resultsCollection[a.selectedLoadIndex].theDataCollection
                VC_Dest.title = "Deflection Data"
            }//end if

       
           
        }else {//if tag = 1 then we show the tables for the graph totals
            if segue.identifier == "V" {
                VC_Dest.graphData = a.shearComboResults.graphTotals.theDataCollection
                VC_Dest.title = "Shear Data"
            }else if segue.identifier == "M" {
                VC_Dest.graphData = a.momentComboResults.graphTotals.theDataCollection
                VC_Dest.title = "Moment Data"
            }else if segue.identifier == "D" {
                VC_Dest.graphData = a.deflectionComboResults.graphTotals.theDataCollection
                VC_Dest.title = "Deflection Data"
            } //end if
            
                    }//end if
    
    }//end function
    
    
    
    //MARK:IBActions
    @IBAction func clck_LoadLabels(_ sender: NSMatrix) {
        updateGraphs()
    }
}






