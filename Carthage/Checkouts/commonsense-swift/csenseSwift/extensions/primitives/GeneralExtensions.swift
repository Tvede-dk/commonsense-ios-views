//
//  GeneralExtensions.swift
//  csenseSwift
//
//  Created by Kasper T on 07/11/2017.
//  Copyright © 2017 commonsense. All rights reserved.
//

import Foundation

public extension Optional {
    /**
     * Uses the value iff safe (not nil)
     */
    public func ifNotNil(action : Function<Wrapped>){
        if let safeSelf = self {
            action(safeSelf)
        }
    }
    /**
     * Another name for "iFNotNil"
     */
    public func useSafe(action : Function<Wrapped>){
        ifNotNil(action: action)
    }
    
}
