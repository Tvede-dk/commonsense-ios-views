//
//  AdvancedFunctionExtensions.swift
//  csenseSwiftTests
//
//  Created by Kasper T on 09/12/2017.
//  Copyright © 2017 commonsense. All rights reserved.
//

import Foundation
import csenseTests
@testable import csenseSwift
import XCTest

class AdvancedFunctionsTests: XCTestCase {

    func testStripFunction() {
        let name = "test"
        name.stripFunctionName().assert("test")

        let emptyFunc = "test2()"
        emptyFunc.stripFunctionName().assert("test2")

        let fncName = "test3(asd:)"
        fncName.stripFunctionName().assert("test3")
    }

    func testIdentityFunction() {
        let test: (String) -> String =  identityFunction()
        test("test").assert("test")
        let test2: (Int) -> Int = identityFunction()
        test2(42).assert(42)

        let optTest: (Bool?) -> Bool? = identityFunction()
        optTest(nil).assertNil()
        optTest(true).assertNotNilEquals(true)
        optTest(false).assertNotNilEquals(false)
    }

    func testAppend() {
        var mutArr: [Int] = []
        mutArr += 20
        mutArr.assertCount(1)
        mutArr.first.assertNotNilEquals(20)
        mutArr += [20, 20]
        mutArr.assertCount(3)
        mutArr += 42
        mutArr.assertCount(4)
        mutArr.last.assertNotNilEquals(42)

    }

    func testIsCalledRecursive() {
        isCalledRecursive(className: "AdvancedFunctionsTests").assert(false)
        //TODO fix me. tests is somehow broken.
       // testIsCalledRecursiveObjC(test2: 0)
       // testIsCalledRecursive(test: 0 )
    }

    private func testIsCalledRecursive(test: Int) {

        if test > 0 {
            isCalledRecursive(className: "AdvancedFunctionsTests").assert(true)
        } else {
            isCalledRecursive(className: "AdvancedFunctionsTests").assert(false)
            testIsCalledRecursive(test: 1)
        }
    }

    @objc private func testIsCalledRecursiveObjC(test2: Int) {
        if test2 > 0 {
            isCalledRecursive(className: "AdvancedFunctionsTests").assert(true)
        } else {
            isCalledRecursive(className: "AdvancedFunctionsTests").assert(false)
            testIsCalledRecursiveObjC(test2: 1)
        }
    }
}
