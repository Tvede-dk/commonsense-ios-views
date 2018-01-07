//
//  SortedArray.swift
//  csenseSwift
//
//  Created by Kasper T on 10/11/2017.
//  Copyright © 2017 commonsense. All rights reserved.
//

import Foundation

public typealias SortedArrayIndex<T> = (index: Int, value: T)

public class SortedArray<T> {
    // MARK: variables and types

    public typealias Index = SortedArrayIndex<T>

    private var data: [Index] = []

    // MARK: Constructors

    public init() {

    }

    // MARK: public functions
    @discardableResult
    public func set(value: T, forIndex: Int) -> T? {
        let index = data.binarySearchClosest(valueToFind: forIndex, extractor: extractorFunc)
        //overwrite data
        if data.isIndexValid(index) && data[index].index == forIndex {
            let old = data[index]
            data[index] = (forIndex, value)
            return old.value
        } else {
            //add data
            data.insert((forIndex, value), at: index)
            return nil
        }
    }

    @discardableResult
    public func remove(forIndex: Int) -> T? {
        let index = data.binarySearch(valueToFind: forIndex, extractor: extractorFunc)
        return index.ifNotNil(action: { index in
            return remove(forRawIndex: index)
        })
    }

    @discardableResult
    public func remove(forRawIndex: Int) -> T? {
        return data.remove(at: forRawIndex).value
    }

    public func get(forIndex: Int) -> T? {
        let index = data.binarySearch(valueToFind: forIndex, extractor: extractorFunc)
        return getOpt(index: index)
    }

    public func get(forRawIndex: Int) -> T? {
        return getOpt(index: forRawIndex)
    }

    public func removeAll() {
        data.removeAll()
    }

    public var count: Int {
        return data.count
    }

    /**
     * returns the raw index of the given index (the sparse index to a [0 -> count] index)
     */
    public func rawIndexOf(forIndex: Int) -> Int? {
        return data.binarySearch(valueToFind: forIndex, extractor: extractorFunc)
    }

    // MARK: internal functions
    private func getOpt(index: Int?) -> T? {
        return index.ifNotNil(action: { index in
            return data.getSafe(index: index)?.value
        })
    }

    private let extractorFunc: FunctionResult<Index, Int> = { (pair: Index) in
        pair.index
    }
}

public func ==<T>(first: SortedArrayIndex<T>, second: SortedArrayIndex<T>) -> Bool where T: Equatable {
    return first.value == second.value
}

public func ==<T>(first: [SortedArrayIndex<T>], second: [SortedArrayIndex<T>]) -> Bool where T: Equatable {
    return first.elementsEqual(second) { (first: SortedArrayIndex<T>, second: SortedArrayIndex<T>) in
        return first == second
    }
}

public extension SortedArray where T: Equatable {
    public static func ==(first: SortedArray, second: SortedArray) -> Bool {
        if first.count != second.count {
            return false
        }
        return first.data == second.data
    }
}