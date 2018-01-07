//
// Created by Kasper T on 09/12/2017.
// Copyright (c) 2017 commonsense. All rights reserved.
//

import Foundation
import csenseTests
@testable import csenseSwift
import XCTest

class FunctionExtensionsTests: XCTestCase {

    func testMethodPointerEmpty() {
        let cls = TestMe()
        let ptr = methodPointer(obj: cls, method: TestMe.increment)
        cls.counter.assert(0)
        ptr()
        cls.counter.assert(1)
        ptr()
        cls.counter.assert(2)
    }

    func testMethodPointerParam() {
        let cls = TestMe()
        let ptr = methodPointer(obj: cls, method: TestMe.incrementBy)
        cls.counter.assert(0)
        ptr(100)
        cls.counter.assert(100)
    }

    func testMethodPointerEmptyReturn() {
        let cls = TestMe()
        let ptr = methodPointer(obj: cls, method: TestMe.get)
        cls.counter.assert(0)
        ptr().assert(0)
        cls.counter.assert(0)
    }

    func testMethodPointerParamReturn() {
        let cls = TestMe()
        let ptr = methodPointer(obj: cls, method: TestMe.incAndGet)
        cls.counter.assert(0)
        ptr(100).assert(100)
    }
}

class TestMe {
    var counter: Int = 0

    func increment() {
        counter += 1
    }

    func incrementBy(count: Int) {
        counter += count
    }

    func get() -> Int {
        return counter
    }

    func incAndGet(count: Int) -> Int {
        incrementBy(count: count)
        return get()
    }
}
