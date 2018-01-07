//
//  AdvancedFunctions.swift
//  csenseSwift
//
//  Created by Kasper T on 25/11/2017.
//  Copyright © 2017 commonsense. All rights reserved.
//

import Foundation

public func isCalledRecursive<T>(callingFunction: String = #function, type: T.Type) -> Bool {
    return isCalledRecursive(callingFunction: callingFunction,
            className: String(describing: type))
}

/**
 *
 */
public func isCalledRecursive(callingFunction: String = #function, className: String) -> Bool {
    let fncToCompareTo = callingFunction.stripFunctionName()

    //we are a function, and of cause, this call will be performed in the interesting function,
    //thus we are to skip that as well. so we skip 1 more iff we have objc to go though...
    let full = Thread.callStackSymbols
    let findFunction: (String) -> Bool = { element in
        let didContainClass = element.contains(className)
        return didContainClass && element.contains(fncToCompareTo)
    }
    let inverseFind: (String) -> Bool = { element in
        return !findFunction(element)
    }
    let afterDropped = full.drop(while: inverseFind).drop(while: findFunction)
    return afterDropped.contains(where: findFunction)
}

public extension String {
    /**
     * if the string is like a function in swift ( "someFunction(parameters)"), then
     * calling this will strip all parameters ect.
     */

    public func stripFunctionName() -> String {
        //function names will include "name(parameters..)"
        if let range = self.range(of: "(") {
            let endIndex = self.index(before: range.lowerBound)
            return String(self[...endIndex])
        } else {
            return self
        }
    }
}

public func identityFunction<T>() -> FunctionResult<T, T> {
    return { (value: T) -> T in
        value
    }
}
