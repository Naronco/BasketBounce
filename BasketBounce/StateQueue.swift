//
//  StateQueue.swift
//  BasketBounce
//
//  Created by Johannes Roth on 23.03.15.
//  Copyright (c) 2015 Naronco. All rights reserved.
//

import Foundation

class StateQueue<T> {
    var state: T
    let changeDuration: NSTimeInterval
    
    var pendingChanges = [T]()
    var blocked = false
    
    var changedStateAction: ((T) -> Void)?
    
    init(state: T, changeDuration: NSTimeInterval) {
        self.state = state
        self.changeDuration = changeDuration
    }
    
    func changeStateTo(newState: T) {
        if blocked {
            pendingChanges.append(newState)
            return
        }
        
        state = newState
        changedStateAction?(newState)
        
        blocked = true
        
        NSTimer.schedule(delay: changeDuration) { timer in
            self.blocked = false
            if !self.pendingChanges.isEmpty {
                self.changeStateTo(self.pendingChanges[0])
                self.pendingChanges.removeAtIndex(0)
            }
        }
    }
}
