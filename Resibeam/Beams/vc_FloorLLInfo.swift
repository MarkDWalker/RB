//
//  ViewController_FloorLLInfo.swift
//  
//
//  Created by Mark Walker on 9/16/15.
//
//

import Cocoa

class vc_FloorLLInfo: NSViewController {

    @IBOutlet var txt: NSTextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        txt.string = "Minimum Live loads in a residential structure are typically taken from building code requirements, and a typical example is shown in the chart above. For most if not all interior floors, a value of 40 psf can be used. It is possible to reduce this number to 30 psf for sleeping rooms, as shown in the chart above, which can complicate the process, as seldom is the member being designed support only one type of room. I prefer the conservative approach and use 40 psf, except the few cases where higher loads are called for. "
    }
    
}
