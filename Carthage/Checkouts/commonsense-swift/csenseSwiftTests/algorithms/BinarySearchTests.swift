//
// Created by Kasper T on 04/12/2017.
// Copyright (c) 2017 commonsense. All rights reserved.
//

import Foundation
import csenseTests
import XCTest
@testable import csenseSwift

class BinarySearchTests: XCTestCase {

    func testOnSimpleIntArray() {
        let arr = [0, 10, 20, 30]
        arr.binarySearch(valueToFind: 20)
                .assertNotNilEquals(2, message: "index should be 2 when value is found.")
        arr.binarySearch(valueToFind: 15).assertNil()
        //searching for the closest value should yield the correct index
        arr.binarySearchClosest(valueToFind: Int.min).assert(0)
        arr.binarySearchClosest(valueToFind: -20).assert(0)
        arr.binarySearchClosest(valueToFind: 5).assert(1)
        arr.binarySearchClosest(valueToFind: 20).assert(2)
        arr.binarySearchClosest(valueToFind: 18).assert(2)
        arr.binarySearchClosest(valueToFind: 28).assert(3)
        arr.binarySearchClosest(valueToFind: 33).assert(4)
        arr.binarySearchClosest(valueToFind: Int.max).assert(4)
    }

    private struct Complex {
        let str: String
        let value: Int
    }

    func testOnComplexArray() {
        let arr = [Complex(str: "a", value: 1234),
                   Complex(str: "b", value: 2345),
                   Complex(str: "c", value: 3456)]
        arr.binarySearchClosest(valueToFind: 2500) { complex -> Int in
            complex.value
        }.assert(2)

        arr.binarySearchClosest(valueToFind: "b") { complex -> String in
            complex.str
        }.assert(1)
    }
}
