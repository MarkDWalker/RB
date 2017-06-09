//
//  CustomCell_GereratorConditionsCell.swift
//  BeamDesigner_V0.0.3
//
//  Created by Mark Walker on 9/6/15.
//  Copyright (c) 2015 Mark Walker. All rights reserved.
//

import Cocoa

protocol tableViewReloadDelegate{
    func myReloadTableView()
    func callSegueFromCell(_ theSegueIdentifier:String, theSender:AnyObject)
    
}

class CustomCell_GereratorConditionsCell: NSTableCellView {

    
    
    @IBOutlet weak var image1: NSImageView!

    @IBOutlet weak var selectButton: NSButton!
    
    @IBOutlet weak var lbl_MemberType: NSTextField!
    @IBOutlet weak var lbl_HouseStories: NSTextField!
    @IBOutlet weak var lbl_StoryLocation: NSTextField!
    @IBOutlet weak var lbl_ExInt: NSTextField!
    @IBOutlet weak var lbl_LBFloorAbove: NSTextField!
    
    var delegate:tableViewReloadDelegate?
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override func awakeFromNib() {

    }
    
    
    @IBAction func click_Select(_ sender: NSButton) {
        if delegate != nil{
        delegate?.callSegueFromCell(sender.identifier!, theSender: self)
        }
        
    }
  
    
    
}
