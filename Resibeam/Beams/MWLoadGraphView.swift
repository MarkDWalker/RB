//
//  MWLoadGraphView.swift
//  BeamStory
//
//  Created by Mark Walker on 11/16/14.
//  Copyright (c) 2014 Mark Walker. All rights reserved.
//

import AppKit


class MWLoadGraphView: NSView {
    var viewColor = NSColor.white
    var graphColor = NSColor.green
    var beamColor = NSColor.black
    var beamFillColor = NSColor.red
    var loadFillColor = NSColor.brown
    var borderColor = NSColor.lightGray
    var selectedLoadColor = NSColor.blue
    var loadBorderColor = NSColor.black
    var supportColor = NSColor.purple
    
    var xPath = NSBezierPath() //path for the x values
    var yPath = [NSBezierPath]() //path the y values
    var bPath = NSBezierPath() //path for the beam
    var sPath = NSBezierPath() //path for the supports
    
    var title:NSString = ""
    var length:NSString = ""
    var E:NSString = ""
    var I: NSString = ""
    var support1:Double = 0
    var support2:Double = 0

    var loadCollection = [MWLoadData]()
    var maxX:Double = 1
    var maxY:Double = 1
    var xPad:Int = 1
    var yPad:Int = 1
    var beamThickness:Double = 8
    
    var selectedLoadIndex:Int = 0
    
    
    override func draw(_ dirtyRect: NSRect) {
        
        
        //create the rounded corners of the nsview
        let clippedPath:NSBezierPath = NSBezierPath(roundedRect: dirtyRect, xRadius: 5, yRadius: 5)
        clippedPath.addClip()
        
        //draw the view
        viewColor.setFill()
        NSRectFill(self.bounds)
        
        
        borderColor.set()
        //bPath.lineWidth = 4
        bPath.stroke()
        
        supportColor.set()
        sPath.lineWidth = 2
        sPath.stroke()
      
        
        for j in 0...yPath.count-1{
            
            if j == selectedLoadIndex{
                loadBorderColor.set()
                selectedLoadColor.setFill()
                
            }else{
                loadBorderColor.set()
                loadFillColor.setFill()
                            }
            
            yPath[j].lineWidth = 1.5
            yPath[j].stroke()
            yPath[j].fill()
        }
        
        
        
        beamColor.set()
        xPath.lineWidth = 2
        xPath.stroke()
        NSColor.lightGray.setFill()
        xPath.fill()
        
    }
    
    func loadDataCollection(_ theBeam:MWBeamGeometry, theLoadCollection:[MWLoadData], xPadding:Int, yPadding:Int){
        
        title = theBeam.title as NSString
        length = NSString(format:"%.2f",theBeam.length)
        E = NSString(format:"%.2f",theBeam.E)
        I = NSString(format:"%.2f",theBeam.I)
        support1 = theBeam.supportLocationA
        support2 = theBeam.supportLocationB
        
        
        loadCollection = theLoadCollection
        //var tempCount:Int = loadCollection.count //the number of loads applied
        
        self.xPad = xPadding
        self.yPad = yPadding
        
        //get the max x value
        self.maxX = Double(loadCollection[0].beamGeo.length)
        //end get max x value
        
        
        // get the max y value which is the sum if the y values of the loads
        var tempY:Double = 0
        yPath.removeAll(keepingCapacity: false)
        
        for j in 0...loadCollection.count-1 {
            tempY = tempY + loadCollection[j].getMaxYInGraph()
            
            //initialize the correct number of yPath items to nothing
            let newYPathItem:NSBezierPath = NSBezierPath()
            yPath.append(newYPathItem)
        }
        
        self.maxY = tempY
        // end get the max y value which is the sum of the y values of the loads
        
    }//end function
    
    func drawGraphs(_ selectedLoadIndex:Int){
        
        self.selectedLoadIndex = selectedLoadIndex
        var previousLoadsYSum:Double = 0
    
        
        //draw the beam
        drawBeam(loadCollection[0].graphPointCollection)
        
        
        for i in 0...loadCollection.count-1{
            drawGraph(loadCollection[i].graphPointCollection, thePrevLoadsYs: previousLoadsYSum, thei:i)
            previousLoadsYSum = previousLoadsYSum + loadCollection[i].getMaxYInGraph()
        }//end for
        
        self.subviews.removeAll()
        drawTitle()
        drawSupports()
    }
    
    func drawBeam(_ dataCollection:[NSPoint]){
        let Xscale:Double = getxScaleFactor()
        //var Yscale:Double = getyScaleFactor()
        let yAdjustment:Double = Double(self.frame.height)/2// + thePrevLoadsYs
        
        xPath.removeAllPoints()
        
        //draw the beam
        let P1:NSPoint = NSPoint(x: Double(xPad/2), y: yAdjustment-(beamThickness/2))
        let P2:NSPoint = NSPoint(x: Double(xPad/2), y: yAdjustment+(beamThickness/2))
        let P3:NSPoint = NSPoint(x: Double(xPad/2) + (loadCollection[loadCollection.count-1].beamGeo.length * Xscale), y: yAdjustment+(beamThickness/2))
        let P4:NSPoint = NSPoint(x: Double(xPad/2) + (loadCollection[loadCollection.count-1].beamGeo.length * Xscale), y: yAdjustment-(beamThickness/2))
        xPath.move(to: P1)
        xPath.line(to: P2)
        xPath.line(to: P3)
        xPath.line(to: P4)
        xPath.close()
        
        //draw the beam end
    }
    
    func drawGraph(_ dataCollection:[NSPoint], thePrevLoadsYs:Double, thei:Int){
        let Xscale:Double = getxScaleFactor()
        let Yscale:Double = getyScaleFactor()
        
        let yAdjustment:Double = Double(self.frame.height)/2 + (beamThickness/2)
        
        //xPath.removeAllPoints()
        yPath[thei].removeAllPoints()
        
        
        let startPointLoad:NSPoint = NSPoint(x: Double(xPad/2) + (Double(dataCollection[0].x) * Xscale), y: yAdjustment + thePrevLoadsYs*Yscale)
        
        
        //draw the load
        yPath[thei].move(to: startPointLoad)
        for i in 0...dataCollection.count-1{
            let xVal:Double = Double(xPad/2) + (Double(dataCollection[i].x) * Xscale)
            let yVal:Double = (Double(dataCollection[i].y)*Yscale) + yAdjustment + (thePrevLoadsYs * Yscale)
            
            let yPoints = NSPoint(x: CGFloat(xVal),y: CGFloat(yVal))
            
            
            if i == 0{
                yPath[thei].line(to: yPoints)
                
            }else if i == dataCollection.count-1{
                yPath[thei].line(to: yPoints)
            }else{
                
                yPath[thei].line(to: yPoints)
                
            }//end if
            
        }//end for
        
        //do some special things for different load types
        if loadCollection[thei].loadType == "uniform" || loadCollection[thei].loadType == "linearup" || loadCollection[thei].loadType == "lineardown"{
            
        yPath[thei].close()//close the shape for the uniform loads
            
        }else if loadCollection[thei].loadType == "concentrated"{
            let xTemp:Double = Double(xPad/2) + (Double(dataCollection[1].x) * Xscale) - 10
            let yTemp:Double = (Double(dataCollection[1].y)*Yscale) + yAdjustment + (thePrevLoadsYs * Yscale) + 10
            let ptTemp:NSPoint = NSPoint(x: xTemp, y: yTemp)
            yPath[thei].move(to: ptTemp)
            
            let xTemp2:Double = Double(xPad/2) + (Double(dataCollection[1].x) * Xscale)
            let yTemp2:Double = (Double(dataCollection[1].y)*Yscale) + yAdjustment + (thePrevLoadsYs * Yscale)
            let ptTemp2:NSPoint = NSPoint(x: xTemp2, y: yTemp2)
            yPath[thei].line(to: ptTemp2)
            
            let xTemp3:Double = Double(xPad/2) + (Double(dataCollection[1].x) * Xscale) + 10
            let yTemp3:Double = (Double(dataCollection[1].y)*Yscale) + yAdjustment + (thePrevLoadsYs * Yscale) + 10
            let ptTemp3:NSPoint = NSPoint(x: xTemp3, y: yTemp3)
            yPath[thei].line(to: ptTemp3)
        }
        
    }//end function
    
    
    func drawSupports(){
        
        sPath.removeAllPoints() //set it up for a new draw
        let xScale = getxScaleFactor()
        //let yScale = getyScaleFactor()
        let legLength:CGFloat = 10
        let yAdjustment:Double = Double(self.frame.height - 3)/2 - (beamThickness/2)
        
        //populates the bezierPath with the the support strokes
        let s1Localx:CGFloat = CGFloat((Double(xPad/2) + (support1 * xScale)))
        let s1Localy:CGFloat = CGFloat(yAdjustment)
        
        let s1Start  = NSMakePoint(s1Localx, s1Localy)
        
        let s1A = NSMakePoint(s1Localx - legLength, s1Localy - legLength)
        let s1B = NSMakePoint(s1Localx + legLength, s1Localy - legLength)
        
        ////////////////////////////////////////////////////////////////////
        
        let s2Localx:CGFloat = CGFloat((Double(xPad/2) + (support2 * xScale)))
        let s2Localy:CGFloat = CGFloat(yAdjustment)
        
        let s2Start  = NSMakePoint(s2Localx, s2Localy)
        
        let s2A = NSMakePoint(s2Localx - legLength, s2Localy - legLength)
        let s2B = NSMakePoint(s2Localx + legLength, s2Localy - legLength)
        
        sPath.move(to: s1Start)
        sPath.line(to: s1A)
        sPath.move(to: s1Start)
        sPath.line(to: s1B)
        
        sPath.move(to: s2Start)
        sPath.line(to: s2A)
        sPath.move(to: s2Start)
        sPath.line(to: s2B)
        
    }
    
    
    func drawTitle(){
        let titleLabel:NSTextField = NSTextField(frame:NSMakeRect(10, 20, 250, 30))
        titleLabel.isBordered = false
        titleLabel.font = NSFont(name: "Arial Bold", size: 12)
        titleLabel.backgroundColor = NSColor.clear
        
        
        let titleString1:String = "Beam Length = "
        let titleString2:String = (length as String) + " Feet" //+ ", E= " + (E as String) + ", I=" + (I as String)

        titleLabel.stringValue = titleString1 + titleString2
        self.addSubview(titleLabel)
        
        let theString:NSString = titleLabel.stringValue as NSString
        let charCount:Int = theString.length
        let newSize = NSMakeSize(CGFloat(charCount) * 7, 30)
        titleLabel.setFrameSize(newSize)
        
    }
    
    
    func drawLabels(_ originalP:NSPoint, adjustP:NSPoint){
        
        let theLabel:NSTextField = NSTextField(frame: NSMakeRect(adjustP.x, adjustP.y, 70, 17))
        theLabel.drawsBackground = false
        let xString = String(format: "%.2f", Double(originalP.x))
        let yString = String(format: "%.2f", Double(originalP.y))
        theLabel.stringValue = xString + ", " + yString
        theLabel.font=NSFont(name: "Verdana", size: 8)
        self.addSubview(theLabel)
    }
    
    func getxScaleFactor()->Double{
        var returnValue:Double = 1.0
        let xscale:Double = (Double(self.frame.width) - Double(xPad)) / maxX
        returnValue = xscale
        return returnValue
    }
    
    func getyScaleFactor()->Double{
        var returnValue:Double = 1.0
        let yscale = ((Double(self.frame.height)/2) - Double(yPad)) / maxY
        returnValue = yscale
        return returnValue
    }
    
    
    
    
}// end of class
//////////////////////////////////working on this to draw the loads
