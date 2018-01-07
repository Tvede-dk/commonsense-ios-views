//
// Created by Kasper T on 11/11/2017.
// Copyright (c) 2017 commonsense. All rights reserved.
//

import Foundation
import csenseTests
@testable import csenseSwift
import XCTest

class SortedArrayTests: XCTestCase {

    func testGeneralFunctions() {
        let array = SortedArray<String>()
        array.set(value: "test", forIndex: 0).assert(nil)
        array.set(value: "test2", forIndex: 10).assert(nil)
        array.set(value: "test3", forIndex: 5).assert(nil)
        array.count.assert(3)

        array.get(forRawIndex: 0).assertNotNilEquals("test")
        array.get(forRawIndex: 1).assertNotNilEquals("test3")
        array.get(forRawIndex: 2).assertNotNilEquals("test2")

        array.get(forIndex: 0).assertNotNilEquals("test")
        array.get(forIndex: 10).assertNotNilEquals("test2")
        array.get(forIndex: 5).assertNotNilEquals("test3")
        array.get(forIndex: 20).assertNil()

        array.remove(forIndex: 5).assertNotNilEquals("test3")
        array.count.assert(2)
        array.get(forIndex: 5).assertNil()
        array.get(forRawIndex: 1).assertNotNilEquals("test2")
        array.get(forRawIndex: 2).assertNil()

        array.set(value: "test4", forIndex: 5)
        array.count.assert(3)
        array.get(forRawIndex: 1).assertNotNilEquals("test4")
        array.get(forIndex: 5).assertNotNilEquals("test4")

        array.remove(forRawIndex: 0).assertNotNilEquals("test")
        array.count.assert(2)
        array.get(forRawIndex: 1).assertNotNilEquals("test2")
        array.get(forRawIndex: 0).assertNotNilEquals("test4")
        array.count.assert(2)
    }
}
