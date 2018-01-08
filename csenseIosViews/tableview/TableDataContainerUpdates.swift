//
//  TableDataContainerUpdates.swift
//  csenseIosViews
//
//  Created by Kasper T on 08/01/2018.
//  Copyright © 2018 commonsense. All rights reserved.
//

import Foundation

/**
 * Describes an update performed on a table, so for example if just inserting 1 element then
 * the inserted will contain that path.
 * the path will be in raw indexes (ios compatible). not logic indexes!
 */
public struct TableDataContainerUpdate {
    public let inserted: [IndexPath]
    public let updated: [IndexPath]
    public let removed: [IndexPath]

    /**
     * returns true if any of the updates lists contains anything,false otherwise.
     */
    func isNotEmpty() -> Bool {
        return inserted.isNotEmpty || updated.isNotEmpty || removed.isNotEmpty
    }
    /**
     *
     */
    public static let empty: TableDataContainerUpdate
        = TableDataContainerUpdate(inserted: [], updated: [], removed: [])

    public static func inserted(indexPaths: [IndexPath]) -> TableDataContainerUpdate {
        return TableDataContainerUpdate(inserted: indexPaths, updated: [], removed: [])
    }

    public static func deleted(indexPaths: [IndexPath]) -> TableDataContainerUpdate {
        return TableDataContainerUpdate(inserted: [], updated: [], removed: indexPaths)
    }
}

public struct TableDataSectionUpdate {
    public let createdSectionAtRawIndex: Int?
    public let deletedSectionAtRawIndex: Int?
    public let updatedRows: TableDataContainerUpdate

    public static func createdSection(rawSectionIndex: Int) -> TableDataSectionUpdate {
        return TableDataSectionUpdate(createdSectionAtRawIndex: rawSectionIndex,
                                      deletedSectionAtRawIndex: nil,
                                      updatedRows: TableDataContainerUpdate.empty)
    }

    public static func deletedSection(rawSectionIndex: Int) -> TableDataSectionUpdate {
        return TableDataSectionUpdate(createdSectionAtRawIndex: nil,
                                      deletedSectionAtRawIndex: rawSectionIndex,
                                      updatedRows: TableDataContainerUpdate.empty)
    }

    public static func updatedSection(updatedRows: TableDataContainerUpdate) -> TableDataSectionUpdate {
        return TableDataSectionUpdate(createdSectionAtRawIndex: nil,
                                      deletedSectionAtRawIndex: nil,
                                      updatedRows: updatedRows)
    }
    public static let empty: TableDataSectionUpdate
        = TableDataSectionUpdate.updatedSection(updatedRows: TableDataContainerUpdate.empty)
}
