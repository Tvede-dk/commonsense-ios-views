//
//  BoolExtensionsTests.swift
//  csenseIosBaseTests
//
//  Created by Kasper T on 04/11/2017.
//  Copyright © 2017 commonsense. All rights reserved.
//

import Foundation
import XCTest
@testable import csenseSwift
import csenseTests

class BoolExtensionsTests: XCTestCase {

    func testMap() {
        true.map(ifTrue: 20, ifFalse: -20).assert(20, message: "true should map to first parameter")
        false.map(ifTrue: 20, ifFalse: -20).assert(-20, message: "false should map to second parameter")
    }

    func testIfTrue() {
        var didCall = false
        true.ifTrue {
            didCall = true
        }
        didCall.assert(true, message: "Should call the action in ifTrue on true value")
        false.ifTrue {
            failTests("Should not be called")
        }
    }

    func testIfFalse() {
        var didCall = false
        false.ifFalse {
            didCall = true
        }
        didCall.assert(true, message: "Should call the action in ifFalse on false value")
        true.ifFalse {
            failTests("Should not be called, true is not false")
        }
    }

}
