//
//  UITableViewExtensions.swift
//  csenseIosViews
//
//  Created by Kasper T on 26/11/2017.
//  Copyright © 2017 commonsense. All rights reserved.
//

import Foundation

public extension UITableView {

    /**
     * scrolls to the first item in the table, and iff the table is empty,does nothing
     */
    public func scrollToTop() {
        if numberOfSections > 0 && numberOfRows(inSection: 0) > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}
