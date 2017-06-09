//
//  vc_RadioSelectLoadType.swift
//  ResiBeam_V0.0.7
//
//  Created by Mark Walker on 3/12/16.
//  Copyright © 2016 Mark Walker. All rights reserved.
//

protocol MWRadioSelectLoadTypeDelegate{
    func updateLoad(_ modifiedLoad:MWLoadData, loadRow:Int)
}

import Cocoa

class vc_RadioSelectLoadType: NSViewController {
    //////////////////////////////////////////////////////////
    var load = MWLoadData()     //set from the delegate
    var beam = MWBeamGeometry() //prior to segue being called
    var buttonRow:Int = 0
    //////////////////////////////////////////////////////////

    var delegate:MWRadioSelectLoadTypeDelegate?
    
    @IBOutlet weak var matrix: NSMatrix!
    
    @IBOutlet weak var buttonUpdate: NSButton!
    
    
    var startedAs = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        if load.loadType == "concentrated"{
            matrix.selectCell(withTag: 0)
        }else if load.loadType == "uniform"{
            matrix.selectCell(withTag: 1)
        }else if load.loadType == "linearup"{
            matrix.selectCell(withTag: 2)
        }else if load.loadType == "lineardown"{
            matrix.selectCell(withTag: 3)
        }
        
       
        startedAs = load.loadType
        
        
        
        
    }

    
    @IBAction func clickUpdate(_ sender: AnyObject) {
        
        guard let t = matrix.selectedCell()?.tag else {
            return
        }
        
        
        if t == 0{
            load.loadType = "concentrated"
            load.loadEnd = 0
            if startedAs == "linearup"{
                let val = load.loadValue2
                load.loadValue = val
                load.loadValue2 = 0
            }
            
        }else if t == 1{
            load.loadType = "uniform"
            if startedAs == "concentrated"{
              load.loadEnd = beam.length
            }else if startedAs == "linearup"{
                load.loadValue = load.loadValue2
            }
        }else if t == 2{
            load.loadType = "linearup"
            if startedAs == "concentrated"{
                load.loadEnd = beam.length
                let val = load.loadValue
                load.loadValue2 = val
                load.loadValue = 0
            }else if startedAs != "linearup"{
                let val = load.loadValue
                load.loadValue = 0
                load.loadValue2 = val
            }
        }else if t == 3{
            load.loadType = "lineardown"
            if startedAs == "concentrated"{
                load.loadEnd = beam.length
            }else if startedAs == "linearup"{
                let val = load.loadValue2
                load.loadValue = val
                load.loadValue2 = 0
            }
        }
        
        guard delegate != nil else{
            return
        }
        
        delegate?.updateLoad(load, loadRow:buttonRow)
        
        dismiss(self)
        
    }
 
    
}
