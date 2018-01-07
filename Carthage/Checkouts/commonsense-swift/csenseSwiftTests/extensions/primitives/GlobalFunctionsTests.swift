//
//  GlobalFunctionsTests.swift
//  csenseSwiftTests
//
//  Created by Kasper T on 07/01/2018.
//  Copyright © 2018 commonsense. All rights reserved.
//

import Foundation
import XCTest
import csenseTests
@testable import csenseSwift

class GloalFunctionsTests: XCTestCase {

    func testIsAnyNotNil() {
        isAnyNotNil(nil, "").assert(true)
        isAnyNotNil("nil", "").assert(true)
        isAnyNotNil("nil", "", 23).assert(true)
        isAnyNotNil(nil).assert(false)
        isAnyNotNil().assert(true)
    }

    func testIsAnyNil() {
        isAnyNil(nil, "").assert(true)
        isAnyNil("nil", "").assert(false)
        isAnyNil("nil", "", nil).assert(true)
        isAnyNil("nil", "", 23).assert(false)
        isAnyNil(nil).assert(true)
        isAnyNil().assert(false)
    }
}
