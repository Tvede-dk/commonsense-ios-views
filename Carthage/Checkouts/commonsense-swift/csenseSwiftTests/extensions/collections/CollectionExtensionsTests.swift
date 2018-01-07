//
//  CollectionExtensionsTests.swift
//  csenseSwiftTests
//
//  Created by Kasper T on 07/01/2018.
//  Copyright © 2018 commonsense. All rights reserved.
//

import Foundation
import csenseTests
import XCTest

class CollectionExtensionsTests: XCTestCase {

    func testMapIndexed() {
        var collection: [String] = []
        collection.mapIndex { (_, _) in
            failTests("should not be called on empty collection")
        }.assertCount(0)
        collection.append("test")
        collection.mapIndex { (item, index) -> Int in
            index.assert(0)
            item.assert("test")
            return item.count
        }.first.assertNotNilEquals("test".count)

        collection.append("test2")
        collection.append("test3")
        collection.append("test4")

        var counter = 0
        collection.mapIndex { (_, index) in
            index.assert(counter)
            counter += 1
        }.assertCount(4)
    }

    func testIsNotEmpty() {
        [].isEmpty.assert(true)
        [].isNotEmpty.assert(false)

        [""].isEmpty.assert(false)
        [""].isNotEmpty.assert(true)

    }
}
