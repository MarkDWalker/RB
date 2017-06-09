//
//  MWLoadComboResult.swift
//  BeamDesigner
//
//  Created by Mark Walker on 7/19/15.
//  Copyright (c) 2015 Mark Walker. All rights reserved.
//

//Class holds a collection of 

import AppKit

class MWLoadComboResult:NSObject, NSCoding{
    
    //MARK: Public Vars
    var resultsCollection = [MWStructuralGraphData]() //this is the main var that holds the totals and is initially blank
    var graphTotals = MWStructuralGraphData() //this holds the summation of the y items in the results collection to give a total result
    
    var archivableResultsCollection:NSMutableArray = NSMutableArray()
    
    //MARK: Public Functions
    override init(){
        
    }

    func addLoadedBeamGraphData(_ newStructuralGraphData:MWStructuralGraphData){
        
        //if this is the first one, just add it
        if resultsCollection.count == 0 {
            
            resultsCollection.append(newStructuralGraphData)
            
            //set some values of the graphTotals Object
            graphTotals.BeamGeo.length = newStructuralGraphData.BeamGeo.length
            graphTotals.BeamGeo.dataPointCount = newStructuralGraphData.BeamGeo.dataPointCount
            
            setGraphTotals()
            
            //if this is not the first one do some checks
        } else if resultsCollection.count > 0 {
            
            //data in the init graph data
            let beamLength0:Double = resultsCollection[0].BeamGeo.length
            let dataPointCount0:Int = resultsCollection[0].BeamGeo.dataPointCount
            
            //data in the newly added data
            let beamLengthNew = newStructuralGraphData.BeamGeo.length
            let dataPointCountNew = newStructuralGraphData.BeamGeo.dataPointCount
            
            //check that the the new dataset has the same beam length and the same datapoint count
            if beamLength0 == beamLengthNew && dataPointCount0 == dataPointCountNew{
                resultsCollection.append(newStructuralGraphData)
                setGraphTotals()
                
            }else{
                //should throw a flag here
            }//end if
            
        }//end if
        
        
    }//end function
    
    
    //MARK: Private Functions
    
    fileprivate func setGraphTotals(){
        
        var tempValuex:Double = 0
        var tempValuey:Double = 0
        var theDataPoint:NSPoint = NSPoint()
        //empty the collection because we are going to add all the items  again
        graphTotals.theDataCollection.removeAll(keepingCapacity: false)
        for i in 0...graphTotals.BeamGeo.dataPointCount-1{ //Outer loop thru dataPoints
            tempValuex = Double(resultsCollection[0].theDataCollection[i].x)
            for  j in 0...resultsCollection.count-1{ //inner loop thru each collection item
                tempValuey = tempValuey+Double(resultsCollection[j].theDataCollection[i].y)
            }//end inner loop
            
            theDataPoint.x = CGFloat(tempValuex)
            theDataPoint.y = CGFloat(tempValuey)
            graphTotals.theDataCollection.append(theDataPoint)
            tempValuey = 0
        } //end outer loop
        
    } //end function
    
    fileprivate func setResultsCollectionFromArray(){
        
        resultsCollection.removeAll(keepingCapacity: false)
        for i in 0...archivableResultsCollection.count-1{
            resultsCollection.append(archivableResultsCollection[i] as! MWStructuralGraphData)
        }
        
    }
    
    fileprivate func sendResultsCollectionToArray(){
    
        archivableResultsCollection.removeAllObjects()
        for i in 0...resultsCollection.count-1{
            archivableResultsCollection.add(resultsCollection[i])
        }
    }
    
    
    //MARK: NSCoding Conformance
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        resultsCollection = aDecoder.decodeObject(forKey: "resultsCollection") as! [MWStructuralGraphData]
        //sendResultsCollectionToArray()
        //archivableResultsCollection = aDecoder.decodeObjectForKey("archivableResultsCollection") as! NSMutableArray
        graphTotals = aDecoder.decodeObject(forKey: "graphTotals") as! MWStructuralGraphData
        //setResultsCollectionFromArray()
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(resultsCollection, forKey: "resultsCollection")
        
        //aCoder.encodeObject(archivableResultsCollection, forKey: "archivableResultsCollection")
        aCoder.encode(graphTotals, forKey: "graphTotals")
       
        
    }
    
} //end class
