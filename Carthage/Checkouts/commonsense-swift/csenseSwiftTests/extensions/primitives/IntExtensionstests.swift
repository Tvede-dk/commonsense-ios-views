//
//  IntExtensionstests.swift
//  csenseSwiftTests
//
//  Created by Kasper T on 10/11/2017.
//  Copyright © 2017 commonsense. All rights reserved.
//

import Foundation
import csenseTests
@testable import csenseSwift
import XCTest

class IntExtensionsTests: XCTestCase {

    func testMiddle() {
        0.middle(upperBound: 100).assert(50)
        50.middle(upperBound: 100).assert(75)
        20.middle(upperBound: 50).assert(35)
    }

    func testIsPositive() {
        0.isPositive.assert(false, message: "0 is not positive. it is neutral")
        (0 - 1).isPositive.assert(false)
        (0 - 100).isPositive.assert(false)
        1.isPositive.assert(true)
        Int.max.isPositive.assert(true)
        Int.min.isPositive.assert(false)
        10.isPositive.assert(true)
        100000.isPositive.assert(true)
    }

    func testIsZero() {
        0.isZero.assert(true, message: "0 is neutral")
        (0 - 1).isZero.assert(false)
        (0 - 100).isZero.assert(false)
        1.isZero.assert(false)
        Int.max.isZero.assert(false)
        Int.min.isZero.assert(false)
        10.isZero.assert(false)
        100000.isZero.assert(false)
    }

    func testIsNegative() {
        0.isNegative.assert(false, message: "0 is not negative. it is neutral")
        (0 - 1).isNegative.assert(true)
        (0 - 100).isNegative.assert(true)
        1.isNegative.assert(false)
        Int.max.isNegative.assert(false)
        Int.min.isNegative.assert(true)
        10.isNegative.assert(false)
        100000.isNegative.assert(false)
    }

    func testIsZeroOrPositive() {
        0.isZeroOrPositive.assert(true, message: "0 is zero")
        (0 - 1).isZeroOrPositive.assert(false)
        (0 - 100).isZeroOrPositive.assert(false)
        1.isZeroOrPositive.assert(true)
        Int.max.isZeroOrPositive.assert(true)
        Int.min.isZeroOrPositive.assert(false)
        10.isZeroOrPositive.assert(true)
        100000.isZeroOrPositive.assert(true)
    }

    func testIsZeroOrNegative() {
        0.isZeroOrNegative.assert(true, message: "0 is zer0")
        (0 - 1).isZeroOrNegative.assert(true)
        (0 - 100).isZeroOrNegative.assert(true)
        1.isZeroOrNegative.assert(false)
        Int.max.isZeroOrNegative.assert(false)
        Int.min.isZeroOrNegative.assert(true)
        10.isZeroOrNegative.assert(false)
        100000.isZeroOrNegative.assert(false)
    }

    func testPerformTimes() {
        0.performTimes { (_) in
            failTests("should not be called")
        }
        (0 - 100).performTimes { (_) in
            failTests("should not be called")
        }
        Int.min.performTimes { (_) in
            failTests("should not be called")
        }
        var counter1Times = 0
        1.performTimes { (value) in
            value.assert(0)
            counter1Times += 1
        }
        counter1Times.assert(1)

        var counter22Times = 0
        22.performTimes { (value) in
            value.assert(counter22Times)
            counter22Times += 1
        }
        counter22Times.assert(22)
    }

    func testOptionalOrZero() {
        let opt: Int? = nil
        opt.orZero.assert(0)

        let opt2: Int? = 42
        opt2.orZero.assert(42)

        let opt3: Int? = 0
        opt3.orZero.assert(0)
    }

}
