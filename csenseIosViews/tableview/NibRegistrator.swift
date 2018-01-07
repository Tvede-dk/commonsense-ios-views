//
// Created by Kasper T on 07/12/2017.
// Copyright (c) 2017 commonsense. All rights reserved.
//

import Foundation
import csenseSwift

public class NibRegistrator {


    private var registeredIdentifiers: [String : Int] = [:]


    public func addNib(nib: UINib, reuseId: String, tableView: UITableView) {
        if !containsNibAndReuse(nib: nib, reuseId: reuseId) {
            addNibAndReuseId(nib: nib, reuseId: reuseId)
            tableView.register(nib, forCellReuseIdentifier: reuseId)
        }
    }

    public func removeNib(nib: UINib, reuseId: String, tableView: UITableView) {
        //if we had but we ended up removing it,then "de"register the cell.
        if (containsNibAndReuse(nib: nib, reuseId: reuseId)) {
            removeNibAndReuseId(nib: nib, reuseId: reuseId).ifTrue {
                let nilUINib: UINib? = nil
                tableView.register(nilUINib, forCellReuseIdentifier: reuseId)
            }
        }
    }

    private func containsNibAndReuse(nib: UINib, reuseId: String) -> Bool {
        let count = registeredIdentifiers[reuseId].orZero
        return count.isPositive
    }

    private func addNibAndReuseId(nib: UINib, reuseId: String) {
        let oldValue = registeredIdentifiers[reuseId].orZero
        registeredIdentifiers.updateValue(oldValue + 1, forKey: reuseId)
    }

    /**
     *
     * returns true iff it was removed, false otherwise
     */
    private func removeNibAndReuseId(nib: UINib, reuseId: String) -> Bool {
        let oldValue = registeredIdentifiers[reuseId].orZero - 1
        if (oldValue.isZeroOrNegative) {
            registeredIdentifiers.removeValue(forKey: reuseId)
        } else {
            //oldValue -1 is positive
            registeredIdentifiers.updateValue(oldValue - 1, forKey: reuseId)
        }
        return oldValue.isZeroOrNegative
    }

    public func clear() {
        registeredIdentifiers.removeAll()
    }


}
