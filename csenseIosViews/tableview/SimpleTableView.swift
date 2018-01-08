//
//  SimpleTableView.swift
//  csenseIosViews
//
//  Created by Kasper T on 04/11/2017.
//  Copyright © 2017 commonsense. All rights reserved.
//

import Foundation
import csenseSwift
import UIKit

/**
 * Point of the class
 *
 * x) the tableView cannot deal with partial / sparse array of sections,
  but we want that, so we will translate the sectionIndex ( 0-> count of section) into the given key, using
  an ordered Dictionary (so the keys will be sorted).
 * y) allow a decentralized design , such that every type of cell can be used in this table;
    and also that all kinds of manipulations.

  * q) also allows to configure regular things like selection / deselection and the behavior hereof.

  * z) also performs so excellent that using a regular tableView with the extreme maintainens-burden, and bad design be default
        seems like a stupid idea.
 */
open class SimpleTableView: UITableView {

    // MARK: class properties / exposed
    public var insertionAnimation: UITableViewRowAnimation = UITableViewRowAnimation.automatic

    public var deletionAnimation: UITableViewRowAnimation = UITableViewRowAnimation.automatic

    public var reloadingAnimation: UITableViewRowAnimation = UITableViewRowAnimation.automatic

    private let nibRegistrator: NibRegistrator = NibRegistrator()

    private let data = TableDataContainer()

    // MARK: Init

    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        //potentially more setup required here.
        hookupDelegates()
    }

    private func hookupDelegates() {
        dataSource = data
        delegate = data
    }

    // MARK: Options for table
    public var delegateSelectionAsTab: Bool {
        get {
            return data.delegateSelectionAsTab
        }
        set(value) {
            data.delegateSelectionAsTab = value
        }
    }

    public var removeSelectionAfterSelecting: Bool {
        get {
            return data.removeSelectionAfterSelecting
        }
        set(value) {
            data.removeSelectionAfterSelecting = value
        }
    }

    // MARK: public functions

    public func add(item: GenericTableItem, forSection: Int) {
        addNibFromGenericTableItem(item: item)
        applyResultUpdate(update: data.add(item: item, forSection: forSection))
    }

    /**
     * retrives the size of a section, given the section key (not raw index)
     * the "numberOf inSections" is the ios version, using raw indexes.
     */
    public func sizeOfSection(forSection: Int) -> Int {
        return data.size(forSection: forSection)
    }

    public func add(items: [GenericTableItem], forSection: Int) {
        if items.isEmpty {
            return
        }
        items.forEach(addNibFromGenericTableItem)
        applyResultUpdate(update: data.add(items: items, forSection: forSection))
    }

    public func remove(section: Int) {
        let removed = data.remove(section: section)
        removed.items.forEach(removeNibFromGenericTableItem)
        removed.rawSectionIndex.useSafe { (rawSection: Int) in
            deleteSections(IndexSet(integer: rawSection), with: deletionAnimation)
        }
    }

    public func clear() {
        nibRegistrator.clear()
        let numberBefore = numberOfSections
        data.clear()
        //if we had data, then remove all the deleted sections.
        if numberBefore.isPositive {
            let sectionIndexes = IndexSet(0 ... numberOfSections - 1)
            deleteSections(sectionIndexes, with: deletionAnimation)
        }
    }

    public func set(item: GenericTableItem, forSection: Int) {
        set(items: [item], forSection: forSection)
    }

    public func set(items: [GenericTableItem], forSection: Int) {
       let update = data.setSection(items: items, forSection: forSection)
        //if the deleIndex is set, then we are deleting the section
        update.deleteIndex.useSafe { (value)  in
            deleteSections(IndexSet(integer: value), with: deletionAnimation)
        }
        //alternative, there are "updates"
        applyResultUpdate(update: update.result)
    }

    public func setHeader(header: GenericTableHeaderItem, forSection: Int) {
        data.setHeader(header, forSection: forSection)
    }

    /*public func setFooter(footer : GenericTableHeaderItem, forSection: Int){
        data.setFooter(footer, forSection: forSection)
    }*/

    // MARK: data and nib registration

    private func applyResultUpdate(update: TableDataContainerUpdate) {
        beginUpdates()
        if update.removed.isNotEmpty {
            deleteRows(at: update.removed, with: deletionAnimation)
        }
        if update.inserted.isNotEmpty {
            insertRows(at: update.inserted, with: insertionAnimation)
        }
        if update.updated.isNotEmpty {
            reloadRows(at: update.updated, with: reloadingAnimation)
        }
        endUpdates()
    }

    private func removeNibFromGenericTableItem(item: GenericTableItem) {
        let nib = item.getNib()
        let reuseId = item.getReuseIdentifier()
        nibRegistrator.removeNib(nib: nib, reuseId: reuseId, tableView: self)
    }

    private func addNibFromGenericTableItem(item: GenericTableItem) {
        let nib = item.getNib()
        let reuseId = item.getReuseIdentifier()
        nibRegistrator.addNib(nib: nib, reuseId: reuseId, tableView: self)
    }

}
