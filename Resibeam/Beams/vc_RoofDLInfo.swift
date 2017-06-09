//
//  ViewController_RoofDLInfo.swift
//  
//
//  Created by Mark Walker on 9/15/15.
//
//

import Cocoa

class vc_RoofDLInfo: NSViewController {

    @IBOutlet var txt: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        txt.string = "The roof dead load is the material weights of the roof structure itself. In a typical single family structure we are talking about items such as fiberglass shingles (2 psf), plywood roof sheathing (2 psf), trusses (5-7 psf but varies widely), drywall ceiling material (2 psf) and  insulation (0.20 psf). Adding up a typical home with fiberglass shingles and trusses 24 inches o.c. we arrive at number of about 13-14 psf. It does not hurt to be conservative in this calculation, so one would typically add the weights of all the materials together and then round up to the nearest 5 psf, so with the example weights and conditions above, 15 psf would be a good number to use...... Typical weights of materials can be found in most building codes, and a quick search of the internet will reveal multiple examples of only a couple pages in length that can be referred to for specific conditions."
        
        
    }
    
}
