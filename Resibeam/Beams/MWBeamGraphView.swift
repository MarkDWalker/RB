//
//  MWBeamGraphView.swift
//  BeamStory
//
//  Created by Mark Walker on 11/16/14.
//  Copyright (c) 2014 Mark Walker. All rights reserved.
//

import AppKit

class MWBeamGraphView: NSView {
    
    var title:NSString = ""
    var maxUnits:NSString = ""
    var maxX:Double = 1
    var maxY:Double = 1
    var xPad:Int = 1
    var yPad:Int = 1
    
    
    var viewColor = NSColor.white
    var graphColor = NSColor.red
    var graphColorB = NSColor.gray
    var beamColor = NSColor.green
    var graphColorSelected = NSColor.blue
    var supportColor = NSColor.purple
    
    var xPath = NSBezierPath() //path for the x values i.e. the beam
    var yPath = NSBezierPath() //path the y values i.e. the results
    var zPaths = [NSBezierPath]() //a collection of paths for the the results of separate indivigual loads
    var circPaths:[NSBezierPath] = [NSBezierPath]()
    var sPath = NSBezierPath() // path for the supports
    
    var support1:Double = 0
    var support2:Double = 0
    var beamThickness:Double = 8
    
    var loadComboResult = MWLoadComboResult()
    var selectedLoadIndex:Int = 0
    
    
    
    override func draw(_ dirtyRect: NSRect) {
        Swift.print("drawRect selected Load Index - \(selectedLoadIndex) -")
        //draw the controll
        viewColor.setFill()
        NSRectFill(self.bounds)
        
         graphColorSelected.set()
        //var i:Int=0
        //for i==0; i<circPaths.count; i += 1
        
        for i in 0...circPaths.count-1{
            //yPath[j].lineWidth = 1
            circPaths[i].stroke()
        }
        
        //draw the results for the indivudual loads
        ///var j:Int=0
        for j in 0...zPaths.count-1{
            if j==selectedLoadIndex{
                graphColorSelected.set()
            }else{
                graphColorB.set()
            }
            //yPath[j].lineWidth = 1
            zPaths[j].stroke()
        }
        
        //draw the beam
        beamColor.set()
        xPath.lineWidth = 2
        xPath.stroke()
        
        supportColor.set()
        sPath.lineWidth = 2
        sPath.stroke()
        
        //draw the main results graph
        graphColor.set()
        yPath.stroke()
    }
    
    
    
    //load member vars and does some initialization, do not want to override the NSViews init()
    func loadDataCollection(_ theBeam:MWBeamGeometry, theTitle:NSString,theLoadComboResult:MWLoadComboResult, xPadding:Int, yPadding:Int, optionalMaxUnits:String = ""){
        
        
        support1 = theBeam.supportLocationA
        support2 = theBeam.supportLocationB
        
        title = theTitle
        maxUnits = optionalMaxUnits as NSString
        loadComboResult = theLoadComboResult
        let tempCount:Int = loadComboResult.graphTotals.theDataCollection.count
        
        self.xPad = xPadding
        self.yPad = yPadding
        
        //get the max x value
        self.maxX = Double(loadComboResult.graphTotals.theDataCollection[tempCount-1].x)
        
        
        // get the max y value
        
        var tempMaxY:Double = Double(abs(loadComboResult.graphTotals.theDataCollection[0].y))
        for i in 0...loadComboResult.graphTotals.theDataCollection.count-1{
            
            if Double(abs(loadComboResult.graphTotals.theDataCollection[i].y))>tempMaxY{
                tempMaxY = Double(abs(loadComboResult.graphTotals.theDataCollection[i].y))
            } //end if
            
        }//end for
        
        self.maxY = tempMaxY
        // end get the max y value
        
        zPaths.removeAll(keepingCapacity: false)
        
        for _ in 0...loadComboResult.resultsCollection.count-1{
            //initialize the correct number of yPath items to nothing
            let newYPathItem:NSBezierPath = NSBezierPath()
            zPaths.append(newYPathItem)
            }
        
        
    }//end function
    
    
    
    func getxScaleFactor()->Double{
        let xscale:Double = (Double(self.frame.width) - Double(xPad)) / maxX
        return xscale
    }
    
    func getyScaleFactor()->Double{
        
        guard maxY != 0 else{
            return 1
        }
        
        let yscale = ((Double(self.frame.height)/2) - Double(yPad)) / maxY
        return yscale
    }
    
   
    func generateBeamCoords()->[NSPoint]{
        let xScale:Double = getxScaleFactor()
        //var yScale:Double = getyScaleFactor()
        let yAdjustment = Double(self.frame.height)/2
        var beamPoints:[NSPoint] = [NSPoint]()
    
        //get the start of the beam
        let startPoint:NSPoint = NSPoint(x: CGFloat(Double(xPad/2) + (Double(loadComboResult.graphTotals.theDataCollection[0].x) * xScale)), y: CGFloat(yAdjustment))
        beamPoints.append(startPoint)
        
        //get the end of the beam
        let pointCount:Int = loadComboResult.graphTotals.theDataCollection.count - 1
        let endPoint:NSPoint = NSPoint(x: CGFloat(Double(xPad/2) + (Double(loadComboResult.graphTotals.theDataCollection[pointCount].x) * xScale)), y: CGFloat(yAdjustment))
        beamPoints.append(endPoint)
        
        return beamPoints
    }
    
    func generateGraphCoords(_ points:[NSPoint])->[NSPoint]{
        let xScale = Double(getxScaleFactor())
        let yScale = Double(getyScaleFactor())
        let yAdjustment = Double((self.frame.height)/2)
        var mainGraphPoints:[NSPoint] = [NSPoint]()
        
        //preStart point will be at the beginning of the beam
        let preStartPoint:NSPoint = NSPoint(x: CGFloat(Double(xPad/2) + Double(points[0].x) * xScale), y: CGFloat(yAdjustment))
        mainGraphPoints.append(preStartPoint)
        
        for i in 0...points.count-1{
            let tempX:Double = Double(xPad/2)+(Double(points[i].x) * xScale)
            let tempY:Double = -Double(points[i].y) * yScale
            
            let point = NSPoint(x: CGFloat(tempX), y: CGFloat((tempY) + yAdjustment))
            mainGraphPoints.append(point)
        }
        
        let postEndPoint = NSPoint(x: CGFloat(Double(xPad/2) + (Double(points[points.count-1].x) * xScale)), y: CGFloat(yAdjustment))
        mainGraphPoints.append(postEndPoint)
        
        return mainGraphPoints
    }
    
    
    func drawGraphItem(_ points:[NSPoint], theBezierPath:NSBezierPath){
        theBezierPath.removeAllPoints()
        theBezierPath.move(to: points[0])
        
        for i in 0...points.count-1{
            theBezierPath.line(to: points[i])
        }
    }

    func drawAllWithLabelsOn(_ collectionToLabel:[NSPoint], selectedLoadIndex:Int){
        
        //set the selected load index
        Swift.print("function selected load index - \(selectedLoadIndex)")
        self.selectedLoadIndex = selectedLoadIndex
        //draw the subgraphs
    
        for i in 0...loadComboResult.resultsCollection.count-1{
            let subGraphPoints:[NSPoint] = generateGraphCoords(loadComboResult.resultsCollection[i].theDataCollection)
            drawGraphItem(subGraphPoints, theBezierPath: zPaths[i])
        }
        
        //draws the beam
        let beamPoints:[NSPoint] = generateBeamCoords()
        drawGraphItem(beamPoints, theBezierPath: xPath)
        
        //draws the Main Graph
        let graphPoints:[NSPoint] = generateGraphCoords(loadComboResult.graphTotals.theDataCollection)
        drawGraphItem(graphPoints, theBezierPath: yPath)
        
        //remove all of the subviews
        self.subviews.removeAll(keepingCapacity: false)
        
        //add the title back
        drawTitle()
        drawSupports()
        //add the labels to the chosen graph
        drawLabels(collectionToLabel)
    }
    func drawSupports(){
        
        sPath.removeAllPoints() //set it up for a new draw
        let xScale = getxScaleFactor()
        //let yScale = getyScaleFactor()
        let legLength:CGFloat = 10
        let yAdjustment:Double = Double(self.frame.height - 3)/2
        
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
        //var titleLabel:NSTextField = NSTextField(frame:NSMakeRect(10, self.frame.height-CGFloat(30), 250, 30))
        let titleLabel:NSTextField = NSTextField(frame:NSMakeRect(10, 0, 250, 30))
        titleLabel.isBordered = false
        titleLabel.font = NSFont(name: "Arial Bold", size: 12)
        titleLabel.backgroundColor = NSColor.clear
        
        titleLabel.stringValue = (title as String) + " - Max = " + (NSString(format: "%.2f", maxY) as String) + " " + (maxUnits as String)
        self.addSubview(titleLabel)
        
        let theString:NSString = titleLabel.stringValue as NSString
        let charCount:Int = theString.length
        let newSize = NSMakeSize(CGFloat(charCount) * 7, 30)
        titleLabel.setFrameSize(newSize)
    }
    
    
    
    
    func drawLabels(_ points:[NSPoint]){
        let xScale = Double(getxScaleFactor())
        let yScale = Double(getyScaleFactor())
        let yAdjustment = Double((self.frame.height)/2)
        var labelSpread:Int = 1
        
        circPaths.removeAll(keepingCapacity: false)
        
        for i in 0...points.count-1{
        //draw the label
            
            if points.count < 6 {
                labelSpread  = 1
            }else{
            labelSpread = points.count/6
            }
            
            
            
            if  i%labelSpread == 0{
                
                //set the original point for the text values
                let originalP = NSPoint(x: points[i].x, y: points[i].y)
                
                //set the adjusted points for the label locations
                let tempX:Double = Double(xPad/2)+(Double(points[i].x) * xScale)
                let tempY:Double = -Double(points[i].y) * yScale
                var adjustP = NSPoint(x: CGFloat(tempX), y: CGFloat((tempY) + yAdjustment))
                
                //the next line is for circle at the points
                if i >= 0 && i < points.count{
                    let rect:NSRect = NSMakeRect(adjustP.x-2.5, adjustP.y-2.5, 5, 5)
                    let circlePath:NSBezierPath = NSBezierPath()
                    circlePath.appendOval(in: rect)
                    circPaths.append(circlePath)
                }
                
                //if it is the last label make an x adjustment so that the label appear on the control
                if i == points.count-1{
                    adjustP.x = adjustP.x - CGFloat(60)
                    
                    if originalP.y <= 0{
                        adjustP.y = adjustP.y - CGFloat(10)
                    }else{
                        adjustP.y = adjustP.y + CGFloat(20)
                    }
                }
                
                //create and add the label
                let theLabel:NSTextField = NSTextField(frame: NSMakeRect(adjustP.x, adjustP.y, 70, 17))
                theLabel.drawsBackground = false
                theLabel.isBordered = false
                let xString = NSString(format: "%.2f", Double(originalP.x))
                let yString = NSString(format: "%.2f", Double(originalP.y))
                theLabel.stringValue = (xString as String) + ", " + (yString as String)
                theLabel.font=NSFont(name: "Verdana", size: 8)
                self.addSubview(theLabel)
            
            }//end if
        }//end for
        
    }//end function
    
    
    
}// end of class
