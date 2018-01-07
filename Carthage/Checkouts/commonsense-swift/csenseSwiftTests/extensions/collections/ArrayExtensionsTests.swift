//
// Created by Kasper T on 06/12/2017.
// Copyright (c) 2017 commonsense. All rights reserved.
//

import Foundation
@testable import csenseSwift
import XCTest
import csenseTests

public class ArrayExtensionsTests: XCTestCase {

    private let emptyArr: [Int] = []
    private let singleArr = ["20"]
    private let dualArr = [true, false, true, false, false]

    func testOptionalArrayCount() {

        let optEmpty: [Int]? = emptyArr
        let optSingle: [String]? = singleArr
        let optMulti: [Bool]? = dualArr
        optEmpty.countOrZero.assert(emptyArr.count)
        optSingle.countOrZero.assert(singleArr.count)
        optMulti.countOrZero.assert(dualArr.count)
        let optNil: [Int]? = nil
        optNil.countOrZero.assert(0)
    }

    func testIsIndexValid() {

        emptyArr.isIndexValid(-1).assert(false)
        emptyArr.isIndexValid(0).assert(false)
        emptyArr.isIndexValid(1).assert(false)

        singleArr.isIndexValid(-1).assert(false)
        singleArr.isIndexValid(0).assert(true)
        singleArr.isIndexValid(1).assert(false)
        singleArr.isIndexValid(2).assert(false)

        dualArr.isIndexValid(-1).assert(false)
        for index in 0...dualArr.count - 1 {
            dualArr.isIndexValid(index).assert(true)
        }
        dualArr.isIndexValid(dualArr.count).assert(false)

    }

    func testGetSafe() {
        emptyArr.getSafe(index: 0).assertNil()
        singleArr.getSafe(index: 0).assertNotNil()
        singleArr.getSafe(index: -1).assertNil()
        singleArr.getSafe(index: 1).assertNil()

        dualArr.getSafe(index: Int.min).assertNil()
        dualArr.getSafe(index: Int.max).assertNil()
        dualArr.getSafe(index: dualArr.count).assertNil()
        dualArr.getSafe(index: dualArr.count - 1).assertNotNil()

    }

    func testPlusEqualsOperator() {

        var emptyArr: [Int] = []
        emptyArr += emptyArr
        emptyArr.assertCount(0)

        emptyArr += [20]
        emptyArr.assertCount(1)

    }

    func testInsertOrUpdate() {
        var arr = emptyArr
        arr.insertOrUpdate(index: 0, value: 20).assertNil()
        arr.insertOrUpdate(index: 0, value: 30).assert(20, message: "should overwrite old value")
        arr.insertOrUpdate(index: 1, value: 40).assertNil()
        arr.insertOrUpdate(index: 1, value: 50).assert(40)
        arr.insertOrUpdate(index: 0, value: 50).assert(30)
        arr.assertCount(2)
    }
}
