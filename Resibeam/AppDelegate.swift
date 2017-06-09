//
//  AppDelegate.swift
//  ResiBeam_V0.0.7
//
//  Created by Mark Walker on 3/7/16.
//  Copyright © 2016 Mark Walker. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        
        
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


    func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
        return false
    }
    
    
//    @IBAction func myHelp(_ sender:AnyObject){
//        
//        let accessoryView = NSTextView()
//        accessoryView.frame = NSMakeRect(0, 0, 300, 10)
//        let mString = NSMutableAttributedString(string: "www.walker-engineering.com/resibeam/support")
//        let range = NSMakeRange(0, mString.length)
//        accessoryView.insertText(mString, replacementRange: range)
//        
//        let alert = NSAlert.init()
//        alert.messageText = "Support and Feedback"
//        alert.informativeText = "For help and to report bugs, go to:"
//        alert.accessoryView = accessoryView
//        alert.addButton(withTitle: "OK")
//        alert.addButton(withTitle: "Cancel")
//        alert.runModal()
//    }
    
}

