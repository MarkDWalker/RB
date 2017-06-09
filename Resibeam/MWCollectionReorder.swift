//
//  MWCollectionReorder.swift
//  ResiBeam_V0.0.7
//
//  Created by Mark Walker on 5/9/16.
//  Copyright © 2016 Mark Walker. All rights reserved.
//

import Foundation

class MWCollectionReorder{


    func moveCollectionItemDown <T> (_ aCollection:[T], selectedIndex:Int) -> [T]{
        
        ///////////////////////////////////////////////////////////////////////////
        ///function takes a collection and an index, and swaps the item
        ///with the next index location. If an error occurs, a blank
        ///collection will be returned, so that should be checked by the caller
        ///////////////////////////////////////////////////////////////////////////
        
        var tempCollection = [T]()
        
        guard selectedIndex < aCollection.count-1 && selectedIndex >= 0 else{
            return tempCollection
        }
        
        let originalIndex:Int = selectedIndex
        let newIndex:Int = originalIndex + 1
        
        
        //copy the items up to the change
        if selectedIndex > 0 {
            for i in 0...newIndex - 2{
                tempCollection.append(aCollection[i])
            }
        }
        
        
        //then swap the two values
        tempCollection.append(aCollection[newIndex])
        tempCollection.append(aCollection[originalIndex])
        
        //now add the rest of the items
        if newIndex+1<aCollection.count{
            for j in newIndex + 1...aCollection.count-1{
                tempCollection.append(aCollection[j])
            }
        }
        
        return tempCollection
    }
    
    
    func moveCollectionItemUp <T> (_ aCollection:[T], selectedIndex:Int) -> [T]{
        ///////////////////////////////////////////////////////////////////////////
        ///function takes a collection and an index, and swaps the item
        ///with the previous index location. If an error occurs, a blank
        ///collection will be returned, so that should be checked by the caller
        ///////////////////////////////////////////////////////////////////////////
        
        var tempCollection = [T]()
        
        guard selectedIndex <= aCollection.count - 1 && selectedIndex > 0 else{
            return tempCollection
        }
        
        //copy the items up to the change
        if selectedIndex > 1 {
            for i in 0...selectedIndex - 2{
                tempCollection.append(aCollection[i])
            }
        }
        
        //then swap the two values
        tempCollection.append(aCollection[selectedIndex])
        tempCollection.append(aCollection[selectedIndex - 1])
        
        //now add the rest of the items
        if selectedIndex+1 < aCollection.count{
            for j in selectedIndex + 1...aCollection.count-1{
                tempCollection.append(aCollection[j])
            }
        }
        
        return tempCollection
    }
    
}

