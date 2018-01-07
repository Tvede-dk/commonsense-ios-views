//
// Created by Kasper T on 09/12/2017.
// Copyright (c) 2017 commonsense. All rights reserved.
//

import Foundation
import csenseTests
@testable import csenseSwift
import XCTest

class GeneralExtensionsTests: XCTestCase {
    func testUseIfSafe() {

    }

    func testIfNotNil() {
        var temp: String? = nil
        temp.ifNotNil { _ in
            failTests("should not be called on nil")
        }

        temp = "magic"
        let exp1 = expectation(description: "should call callback")
        temp.ifNotNil { str in
            str.assert("magic")
            exp1.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testValueOr() {
        var temp: String? = nil
        temp.valueOr("test").assert("test")
        temp = "1234"
        temp.valueOr("no").assert("1234")

    }
}
