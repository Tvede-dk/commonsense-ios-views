//
//  BinarySearch.swift
//  csenseSwift
//
//  Created by Kasper T on 10/11/2017.
//  Copyright © 2017 commonsense. All rights reserved.
//

import Foundation

public extension Array where Element: Comparable {
    public func binarySearchClosest(valueToFind: Element) -> Int {
        return binarySearchClosest(valueToFind: valueToFind, extractor: identityFunction())
    }
}

public extension Array where Element == Int {
    public func binarySearch(valueToFind: Int) -> Int? {
        return binarySearch(valueToFind: valueToFind, extractor: identityFunction())
    }
}

public extension Array {

    public func binarySearch<T: Comparable>(valueToFind: T, extractor: FunctionResult<Element, T>) -> Int? {
        let temp = binarySearch(valueToFind: valueToFind, extractor: extractor, defaultValueFunction: { _ in -1 })
        return temp.isNegative.map(ifTrue: nil, ifFalse: temp)
    }

    public func binarySearchClosest<T: Comparable>(valueToFind: T, extractor: FunctionResult<Element, T>) -> Int {
        return binarySearch(valueToFind: valueToFind, extractor: extractor, defaultValueFunction: { value in value })
    }

    /**
     *
     *
     * defaultValueFunction : given the middle (from the end of the iteration), calculates the result.
     */
    private func binarySearch<T: Comparable>(valueToFind: T,
                                             extractor: FunctionResult<Element, T>,
                                             defaultValueFunction: FunctionResult<Int, Int>) -> Int {
        var lowerBound = 0
        var upperBound = count
        while lowerBound < upperBound {
            let midIndex = lowerBound.middle(upperBound: upperBound)
            let toLookAt = extractor(self[midIndex])
            if toLookAt == valueToFind {
                return midIndex
            } else if toLookAt < valueToFind {
                lowerBound = midIndex + 1
            } else {
                upperBound = midIndex
            }
        }
        let middle = lowerBound.middle(upperBound: upperBound)
        return defaultValueFunction(middle)
    }
}
