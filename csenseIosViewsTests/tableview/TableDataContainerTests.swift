//
//  TableDataContainerTests.swift
//  csenseIosViewsTests
//
//  Created by Kasper T on 05/11/2017.
//  Copyright © 2017 commonsense. All rights reserved.
//

import Foundation
import XCTest
import csenseIosViews
import csenseTests
class TableDataContainerTestss : XCTestCase {
    
    func testSectionsIndexing(){
        let table = TableDataContainer()
        let tableView = UITableView()
        table.numberOfSections(in: tableView).assert(0)
        table.addData(item: EmptyItem(), inSection: 0 )
        table.numberOfSections(in: tableView).assert(1)
        table.tableView(tableView, numberOfRowsInSection: 0).assert(1)
        
        table.tableView(tableView, numberOfRowsInSection: 100).assert(0)
        table.addData(item: EmptyItem(), inSection: 10 )
        table.tableView(tableView, numberOfRowsInSection: 1)
            .assert(1,
                    message:  "ios assumees sections are sequential, but ours is a sparse one, so we are to correctly transform the sparse into a sequential")
        
        
    }
}

class EmptyItem : GenericTableItem {
    func getNib() -> UINib {
        return UINib()
    }
    
    func getReuseIdentifier() -> String {
        return ""
    }
    
    func renderFor<T>(cell: T) where T : UITableViewCell {
        
    }
    
    
}
