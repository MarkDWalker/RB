//
//  MWNSViewForTBStatus.swift
//  
//
//  Created by Mark Walker on 9/17/15.
//
//

import Cocoa

class MWNSViewForTBStatus: NSView {

    //var initialViewColor = NSColor(calibratedHue: 0.96, saturation: 0.96, brightness: 0.96, alpha: 1)
    
    var initialViewColor = NSColor(calibratedRed: 0.96, green: 0.96, blue: 0.96, alpha: 0.75)

    var gColor1:NSColor = NSColor.red
    var gColor2:NSColor = NSColor.white
    
    var circleColor:NSColor = NSColor.red
    
    var circlePath:NSBezierPath = NSBezierPath()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        //create the rounded corners of the nsview
        let clippedPath:NSBezierPath = NSBezierPath(roundedRect: dirtyRect, xRadius: 5, yRadius: 5)
        clippedPath.addClip()

        //draw the view
        initialViewColor.setFill()
        NSRectFill(self.bounds)
        
        circleColor.setFill()
        //circlePath.stroke()
        circlePath.fill()
        
        //let grad:NSGradient = NSGradient(startingColor: gColor1, endingColor: gColor2)!
        
//        //grad.drawInRect(self.frame, angle: 330)
        
        //grad.drawInBezierPath(circlePath, angle: 90)
        
    }
    
    
    fileprivate func drawLabel(_ labelString:String){
        
        let theLabel:NSTextField = NSTextField(frame: NSMakeRect(7, self.frame.size.height / 2 - 10, self.frame.width-50, self.frame.height-5))
        theLabel.drawsBackground = false
        theLabel.isBordered = false
        theLabel.stringValue = labelString
        theLabel.font=NSFont(name: "Verdana", size: 10.5)
        
        //add the shadow
//        let shadow:NSShadow = NSShadow()
//        shadow.shadowBlurRadius = 0 //set how many pixels the shadow has
//        shadow.shadowOffset = NSMakeSize(0, -2) //the distance from the text the shadow is dropped
//        shadow.shadowColor = NSColor.blackColor()
//        theLabel.shadow = shadow
        
        self.addSubview(theLabel)
    }
    
    fileprivate func drawCircle(){
        let theRect:NSRect = NSMakeRect((self.frame.width - 55), 5, 40, 15)
        circlePath.appendOval(in: theRect)
    }
    
    
    func setAndDrawContent(_ labelString:String, passColor:NSColor){
        self.subviews.removeAll()
        drawLabel(labelString)
        circleColor = passColor
        drawCircle()
    }
    
    
    
}
