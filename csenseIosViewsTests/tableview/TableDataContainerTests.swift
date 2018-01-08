//
//  TableDataContainerTests.swift
//  csenseIosViewsTests
//
//  Created by Kasper T on 05/11/2017.
//  Copyright © 2017 commonsense. All rights reserved.
//

import Foundation
import XCTest
@testable import csenseIosViews
import csenseTests

class TableDataContainerTestss : XCTestCase {
    
    func testSectionsIndexing(){
        let table = TableDataContainer()
        let tableView = UITableView()
        table.numberOfSections(in: tableView).assert(0)
        let addedForSec0 = table.add(item: EmptyItem(), forSection: 0 )
        addedForSec0.removed.assertCount(0)
        addedForSec0.updated.assertCount(0)
        addedForSec0.inserted.assertCount(1)
        table.numberOfSections(in: tableView).assert(1)
        table.tableView(tableView, numberOfRowsInSection: 0).assert(1)
        
        table.tableView(tableView, numberOfRowsInSection: 100).assert(0)
        let addedForSec10 = table.add(item: EmptyItem(), forSection: 10)
        addedForSec10.removed.assertCount(0)
        addedForSec10.updated.assertCount(0)
        addedForSec10.inserted.assertCount(1)
        table.tableView(tableView, numberOfRowsInSection: 1)
            .assert(1,
                    message:  "ios assumees sections are sequential, but ours is a sparse one, so we are to correctly transform the sparse into a sequential")
        
    }
    
    func testUpdateResult(){
        
        
    }
    
    
    
    func testDiffComputation(){
        let container = TableDataContainer()
        let emptyOnEmpty =  container.setSection(items: [], forSection: 1)
        emptyOnEmpty.deleteIndex.assertNil()
        emptyOnEmpty.result.removed.assertCount(0)
        emptyOnEmpty.result.updated.assertCount(0)
        emptyOnEmpty.result.inserted.assertCount(0)
        
        let create = container.setSection(items: [EmptyItem(),EmptyItem()], forSection: 1)
        create.deleteIndex.assertNil()
        create.result.removed.assertCount(0)
        create.result.updated.assertCount(0)
        create.result.inserted.assertCount(2)
        //TODO assert indicies
        
        let updatedAll = container.setSection(items: [EmptyItem(), EmptyItem()], forSection: 1)
        updatedAll.deleteIndex.assertNil()
        updatedAll.result.removed.assertCount(0)
        updatedAll.result.updated.assertCount(2)
        //TODO assert indicies
        updatedAll.result.inserted.assertCount(0)
        
        
        let removedSingle = container.setSection(items: [EmptyItem()], forSection: 1)
        
        removedSingle.deleteIndex.assertNil()
        removedSingle.result.removed.assertCount(1)
        removedSingle.result.updated.assertCount(1)
        removedSingle.result.inserted.assertCount(0)
        
        let inserted = container.setSection(items:
            [EmptyItem(), EmptyItem(), EmptyItem(), EmptyItem()],
                                            forSection: 1)
        inserted.deleteIndex.assertNil()
        inserted.result.removed.assertCount(0)
        inserted.result.updated.assertCount(1)
        inserted.result.inserted.assertCount(3)
        
        let removedAll = container.setSection(items: [], forSection: 1)
        removedAll.deleteIndex.assertNotNilEquals(0)
        removedAll.result.inserted.assertCount(0)
        removedAll.result.removed.assertCount(0)
        removedAll.result.updated.assertCount(0)
        
    }
}

class EmptyItem : GenericTableItemRender<UITableViewCell> {
    init() {
        super.init(reuseIdentifier: "a", nibName: "b", renderFunction: render)
    }
    
    func render(cell: UITableViewCell){
        
    }
}
