//
//  Extensions.swift
//  ResiBeam_V0.0.7
//
//  Created by Mark Walker on 11/2/16.
//  Copyright © 2016 Mark Walker. All rights reserved.
//

import Cocoa

extension NSTextView {
    func append(_ mAttString: NSMutableAttributedString, atIndex: Int) {
        self.textStorage?.insert(mAttString, at: atIndex)
    }
    
    
}
