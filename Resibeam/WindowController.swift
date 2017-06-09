//
//  WindowController.swift
//  BeamDesigner_V0.0.4
//
//  Created by Mark Walker on 9/18/15.
//  Copyright © 2015 Mark Walker. All rights reserved.
//

import Cocoa

protocol statusBarDelegate{
    func updateStatus(theString:String, theColor:NSColor)
}

class WindowController: NSWindowController, NSWindowDelegate, statusBarDelegate {

    var win:NSWindow = NSWindow()
    let mainView:NSView = NSView()
    let v:MWNSViewForTBStatus = MWNSViewForTBStatus()
    let vH:CGFloat = 25; let vW:CGFloat = 500
  
    override func windowDidLoad() {
        super.windowDidLoad()
        
        //sets the size of initial document window
        let screenRect:NSRect = NSScreen.main()!.frame
        
        self.window?.setFrame(screenRect, display: true)
        Swift.print("screenRect x,y,w,h: \(screenRect.origin.x),\(screenRect.origin.y),\(screenRect.width),\(screenRect.height)")
        
    //(NSApplication.sharedApplication().delegate as! AppDelegate).window = self.window!
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.window?.delegate = self
        
        
        
        let winFrame:NSRect = (self.window?.frame)!
        
        let oX = winFrame.origin.x; let oY = winFrame.origin.y
        
        let childWinFrame:NSRect = NSMakeRect(oX + (winFrame.width/2 - vW/2), oY + (winFrame.height - 60), vW, vH)
        
        Swift.print("winFrame x,y,w,h: \(winFrame.origin.x),\(winFrame.origin.y),\(winFrame.width),\(winFrame.height)")
        Swift.print("childWinFrame x,y,w,h: \(childWinFrame.origin.x),\(childWinFrame.origin.y),\(childWinFrame.width),\(childWinFrame.height)")
        let viewRect:NSRect = NSMakeRect(0, 0, vW, vH)
        
        
//        let win:NSWindow = NSWindow(contentRect: winFrame, styleMask: NSBorderlessWindowMask, backing: NSBackingStoreType.Buffered, `defer`: false)
        
        win.setFrame(childWinFrame, display: true)
        //win.contentRectForFrameRect(childWinFrame)
        win.styleMask = NSBorderlessWindowMask
        win.backingType = NSBackingStoreType.buffered
        
        win.backgroundColor = NSColor.clear
        win.isOpaque = false
        win.ignoresMouseEvents = true
        
        //mainView.frame = winFrame
        //mainView.addSubview(v)
        v.frame = viewRect
        //v.setAndDrawContent("", passColor: NSColor(calibratedRed: 0, green: 0.60, blue: 0.30, alpha: 1))
        v.setAndDrawContent("", passColor: NSColor.clear)
        Swift.print("viewRect x,y,w,h: \(viewRect.origin.x),\(viewRect.origin.y),\(viewRect.width),\(viewRect.height)")
        Swift.print("win.frame x,y,w,h: \(win.frame.origin.x),\(win.frame.origin.y),\(win.frame.width),\(win.frame.height)")
        
        win.contentView = v
        self.window?.addChildWindow(win, ordered: NSWindowOrderingMode.above)
        
        //add a the split view controller as the statdelegate
        
            }
    
    
    
    
    
  func windowDidResize(_ notification: Notification) {
    let winFrame:NSRect = (self.window?.frame)!
    
    let oX = winFrame.origin.x; let oY = winFrame.origin.y
    
    let childWinFrame:NSRect = NSMakeRect(oX + (winFrame.width/2 - vW/2), oY + (winFrame.height - 48), vW, vH)
    
    win.setFrame(childWinFrame, display: true)

    
    let tabViewMain:NSTabViewController = self.window?.contentViewController as! NSTabViewController
    
    let vc_BeamSplitView:vc_SplitView_Beam = tabViewMain.childViewControllers[0] as! vc_SplitView_Beam
    vc_BeamSplitView.statDelegate = self

    
    
    }
    
    func updateStatus(theString: String, theColor: NSColor) {
        v.setAndDrawContent(theString, passColor: theColor)
        Swift.print(theString);
    }
    
    
    
    
}
