//
//  MWStructuralGraphData.swift
//  BeamDesigner
//
//  Created by Mark Walker on 7/19/15.
//  Copyright (c) 2015 Mark Walker. All rights reserved.
//

import AppKit

class MWStructuralGraphData: NSObject{
    
    //MARK: Public Vars
    var BeamGeo:MWBeamGeometry = MWBeamGeometry()
    var load:MWLoadData = MWLoadData()
    var calcType:String = "moment"
    var equations:MWStructuralEquations = MWStructuralEquations()
    var theDataCollection = [NSPoint]()
    
    
    //MARK: Public Functions
    override init(){
        
    }
    
    init(theBeamGeo:MWBeamGeometry, theLoad:MWLoadData, theCalcType:String){
        super.init()
        
        
        BeamGeo = theBeamGeo    //sets value of class var
        load = theLoad          //sets value of class var
        calcType = theCalcType  //sets value of class var
        
        //loads the initial required values into the equations object when a init() is used
        equations.loadEquationValues(calcType, theLoad:load, theBeamGeo: BeamGeo)
        
        //loads theDataCollection class var
        loadCalcDataCollection()
        
    }
    
    func update(_ theBeamGeo:MWBeamGeometry, theLoad:MWLoadData, theCalcType:String){
        
        BeamGeo = theBeamGeo    //sets value of class var
        load = theLoad          //sets value of class var
        calcType = theCalcType  //sets value of class var
        
        //loads the initial required values into the equations object when a init() is used
        equations.loadEquationValues(calcType, theLoad:load, theBeamGeo: BeamGeo)
        
        //loads theDataCollection class var
        loadCalcDataCollection()
        
    }
    
    func getMaxCalcValue()->Double{
        var returnValue:Double = Double(abs(theDataCollection[0].y))
        for i in 0...theDataCollection.count-1{
            if Double(abs(theDataCollection[i].y))>returnValue{
                returnValue = Double(abs(theDataCollection[i].y))
            }
        }
        
        return returnValue
    }
    
    
    //MARK: Private Functions
    //function loads the acutal x,y values into theDataCollection
    fileprivate func loadCalcDataCollection(){
        //empties the data collection
        theDataCollection.removeAll()
        
        //find the distance increment
        let increment:Double = BeamGeo.length/(Double(BeamGeo.dataPointCount)-1)
        
        var incCounter:Double = 0.0
        var tempCalcValue:Double = 0.0
        var tempPoint:NSPoint = NSPoint(x: 0, y: 0)
        
        //the following line looks goofy because the .10 added to the length. It is necessary due to the rounding error induced by the use of Double for the counter
        
        while incCounter <= (BeamGeo.length + 0.05){
            tempCalcValue = equations.performCalc(incCounter)//loadData*incCounter*(beamLength-incCounter)/2  //*****this line calcs moment at increments****//
            
            tempPoint.x = CGFloat(incCounter)
            tempPoint.y = CGFloat(tempCalcValue)
            theDataCollection.append(tempPoint)
            incCounter = (incCounter + increment)
        }//end While
    }
    
    
    //MARK: NSCoding Conformance
    required init(coder aDecoder: NSCoder) {
        super.init()
        
        BeamGeo = aDecoder.decodeObject(forKey: "BeamGeo") as! MWBeamGeometry
        load = aDecoder.decodeObject(forKey: "load") as! MWLoadData
        calcType = aDecoder.decodeObject(forKey: "calcType") as! String
        equations = aDecoder.decodeObject(forKey: "equations") as! MWStructuralEquations
        //theDataCollection = aDecoder.decodeObjectForKey("theDataCollection") as! [NSPoint]
        loadCalcDataCollection()
    }
    
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(BeamGeo, forKey: "BeamGeo")
        aCoder.encode(load, forKey: "load")
        aCoder.encode(calcType, forKey: "calcType")
        aCoder.encode(equations, forKey: "equations")
        //aCoder.encodeObject(theDataCollection, forKey: "theDataCollection")
        
        
    }
    
    
    
}//End class
