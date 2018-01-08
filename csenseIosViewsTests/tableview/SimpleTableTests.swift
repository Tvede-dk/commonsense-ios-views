//
//  SimpleTableTests.swift
//  csenseIosViewsTests
//
//  Created by Kasper T on 08/01/2018.
//  Copyright © 2018 commonsense. All rights reserved.
//

import Foundation
import csenseSwift
import csenseTests
@testable import csenseIosViews
import XCTest

class SimpleTableTests: XCTestCase {
    func testClear(){
        let table = SimpleTableView()
        table.clear()
    }
}
