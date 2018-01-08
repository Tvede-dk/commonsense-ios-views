//
//  TableDataSection.swift
//  csenseIosViews
//
//  Created by Kasper T on 08/01/2018.
//  Copyright © 2018 commonsense. All rights reserved.
//

import Foundation
public class TableDataSection {

    public init() {
    }

    public init(data: [GenericTableItem], isHidden: Bool) {
        self.data = data
        self.isHidden = isHidden
    }

    public var data: [GenericTableItem] = []
    public var isHidden: Bool = true

    public var isEmpty: Bool {
        return data.isEmpty
    }

    public var isNotEmpty: Bool {
        return data.isNotEmpty
    }

    public var count: Int {
        return data.count
    }

    public func updateContentWith(_ newData: [GenericTableItem]) -> TableDataSection {
        self.data = newData
        return self
    }
}
