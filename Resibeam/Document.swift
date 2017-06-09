//
//  Document.swift
//  ResiBeam_V0.0.7
//
//  Created by Mark Walker on 3/7/16.
//  Copyright © 2016 Mark Walker. All rights reserved.
//

import Cocoa

class Document: NSDocument {

    //var saveDataBeamDesigns = NSMutableArray()
    
    var saveData = MWSaveFileData()
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override func windowControllerDidLoadNib(_ aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController has loaded the document's window.
    }

    override class func autosavesInPlace() -> Bool {
        return true
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! NSWindowController
        self.addWindowController(windowController)
    }

    override func data(ofType typeName: String) throws -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: saveData)
      //return NSKeyedArchiver.archivedDataWithRootObject(saveDataBeamDesigns)
    }

    override func read(from data: Data, ofType typeName: String) throws {
        saveData = NSKeyedUnarchiver.unarchiveObject(with: data) as! MWSaveFileData
    }


}

