//
//  DragImageView.swift
//  Resibeam
//
//  Created by Mark Walker on 11/1/17.
//  Copyright © 2017 Mark Walker. All rights reserved.
//

import Cocoa

class DragImageView: NSImageView, NSDraggingSource, NSPasteboardItemDataProvider {
    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        return NSDragOperation.copy
    }
    

    
    func pasteboard(_ pasteboard: NSPasteboard?, item: NSPasteboardItem, provideDataForType type: String) {
        //pasteboard?.setValue(self.image, forType: NSPasteboardTypePNG)
      pasteboard?.setData(item.data(forType: NSPasteboardTypePNG), forType: NSPasteboardTypePNG)
    }
    

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func mouseDragged(with event: NSEvent) {
//         NSPasteboardItem *pbItem = [NSPasteboardItem new];
        let pbItem = NSPasteboardItem()
//        [pbItem setDataProvider:self forTypes:[NSArray arrayWithObjects:NSPasteboardTypeTIFF, NSPasteboardTypePDF, kPrivateDragUTI, nil]];
        pbItem.setDataProvider(self, forTypes: [NSPasteboardTypePNG])
//        NSDraggingItem *dragItem = [[NSDraggingItem alloc] initWithPasteboardWriter:pbItem];
        let dragItem = NSDraggingItem(pasteboardWriter: pbItem)
//        NSRect draggingRect = self.bounds;
        let oRect = self.bounds
        let draggingRect = NSMakeRect(oRect.minX + oRect.width/4, oRect.minY, oRect.width/2, oRect.height/1.2)
        
//        [dragItem setDraggingFrame:draggingRect contents:[self image]];
        dragItem.setDraggingFrame(draggingRect, contents: self.image)
//        NSDraggingSession *draggingSession = [self beginDraggingSessionWithItems:[NSArray arrayWithObject:[dragItem autorelease]] event:event source:self];
        let draggingSession = self.beginDraggingSession(with: [dragItem], event: event, source: self)
//        draggingSession.animatesToStartingPositionsOnCancelOrFail = YES;
        draggingSession.animatesToStartingPositionsOnCancelOrFail = true
//        draggingSession.draggingFormation = NSDraggingFormationNone;
        draggingSession.draggingFormation = NSDraggingFormation.none
    }
    
    
  
    
}
