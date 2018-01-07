//
//  DictionaryExtensionsTests¨.swift
//  csenseSwiftTests
//
//  Created by Kasper T on 05/11/2017.
//  Copyright © 2017 commonsense. All rights reserved.
//

import Foundation
import XCTest
import csenseTests
@testable import csenseSwift

class DictionaryExtensionsTest: XCTestCase {

    func testAddOrCreate() {
        var tempDict: [Int: [String]] = [:]
        tempDict.count.assert(0, message: "should start empty")
        tempDict.addOrCreate(key: 2, item: "a")
        tempDict.count.assert(1, message: "should have 1 section")
        tempDict[2].assertNotNilAnd { it in
            it.count.assert(1, message: "should have added the item to the section.")
            it.first.assertNotNilEquals("a", message: "should have value inserted into section.")
        }
    }

    func testElementByIndex() {
        var tempDict: [Int: [String]] = [:]
        tempDict.elementByIndex(index: -20).assertNil(message: "should give nil on out of bounds")
        tempDict.elementByIndex(index: 0).assertNil(message: "should give nil on out of bounds")
        tempDict.addOrCreate(key: 1, item: "test")
        tempDict.elementByIndex(index: 0).assertNotNil()
        tempDict.elementByIndex(index: 100).assertNil(message: "should give nil on out of bounds")

    }

    func testIsIndexValid() {
        var tempDict: [Int: [String]] = [:]
        //try some various indexes.
        tempDict.isIndexValid(-100).assert(false)
        tempDict.isIndexValid(-1).assert(false)
        tempDict.isIndexValid(0).assert(false)
        tempDict.isIndexValid(1).assert(false)
        tempDict.isIndexValid(100).assert(false)
        //lets try with a single section now.
        tempDict.addOrCreate(key: 500, item: "a")
        tempDict.isIndexValid(-1).assert(false)
        tempDict.isIndexValid(0).assert(true, message: "we have 1 element, which is a index 0")
        tempDict.isIndexValid(1).assert(false)
        tempDict.addOrCreate(key: 500, item: "b")
        //we still only have 1 section
        tempDict.isIndexValid(-1).assert(false)
        tempDict.isIndexValid(0).assert(true)
        tempDict.isIndexValid(1).assert(false)
        //now we add the second section
        tempDict.addOrCreate(key: 50, item: "b")
        tempDict.isIndexValid(-1).assert(false)
        tempDict.isIndexValid(0).assert(true)
        tempDict.isIndexValid(1).assert(true)
        tempDict.isIndexValid(2).assert(false)
        //and no matter what sections keys we use, it still appends correctly.
        tempDict.addOrCreate(key: 9999, item: "c")
        tempDict.isIndexValid(-1).assert(false)
        tempDict.isIndexValid(0).assert(true)
        tempDict.isIndexValid(1).assert(true)
        tempDict.isIndexValid(2).assert(true)
        tempDict.isIndexValid(3).assert(false)
    }

    func testLookupDictionary() {
        var dict: [Int: [Int]] = [:]
        dict.lookupElement(at: IndexPath(row: 0, section: 0)).assertNil()
        dict[0] = [0]
        dict.lookupElement(at: IndexPath(row: 0, section: 0)).assertNotNilEquals(0)
        dict[0] = [42]
        dict.lookupElement(at: IndexPath(row: 0, section: 0)).assertNotNilEquals(42)
        dict[20] = [20, 20, 40, 20, 20]
        dict.lookupElement(at: IndexPath(row: 0, section: 20)).assertNotNilEquals(20)
        dict.lookupElement(at: IndexPath(row: 2, section: 20)).assertNotNilEquals(40)
        dict.lookupElement(at: IndexPath(row: 4, section: 20)).assertNotNilEquals(20)
        dict.lookupElement(at: IndexPath(row: 5, section: 20)).assertNil()
    }

}
