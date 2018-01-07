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

}
