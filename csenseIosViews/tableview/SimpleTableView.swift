//
//  SimpleTableView.swift
//  csenseIosViews
//
//  Created by Kasper T on 04/11/2017.
//  Copyright © 2017 commonsense. All rights reserved.
//

import Foundation
import csenseSwift
import csenseIosBase
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

    // MARK: public properties
    
    /**
     * animation when inserting cell(s)
     */
    public var insertionAnimation: UITableViewRowAnimation = UITableViewRowAnimation.automatic

    /**
     * animation when deleting cell(s)
     */
    public var deletionAnimation: UITableViewRowAnimation = UITableViewRowAnimation.automatic
    
    /**
     * animation when reloading cell(s)
     */
    public var reloadingAnimation: UITableViewRowAnimation = UITableViewRowAnimation.automatic

    // MARK: private properties
    private let nibRegistrator: NibRegistrator = NibRegistrator()
    
    /**
     * The data storage. also the guy that does most of the heavy section indexing / lifting.
     */
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
        items.forEach(addNibFromGenericTableItem)
        applyResultUpdate(update: data.add(items: items, forSection: forSection))
    }

    public func remove(section: Int) {
        //remove all nibs
        data.rowsInSection(forSection: section)?.forEach(removeNibFromGenericTableItem)
        let removed = data.remove(section: section)
        applyResultUpdate(update: removed)
    }

    public func clear() {
        nibRegistrator.clear()
        let numberBefore = numberOfSections
        applyResultUpdate(update: data.clear()) //TODO prettify this.. ??
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
        //update nibs.
        updateNibs(old: data.rowsInSection(forSection: forSection), new: items)
        let update = data.setSection(items: items, forSection: forSection)
        applyResultUpdate(update: update)
    }

    public func setHeader(header: GenericTableHeaderItem, forSection: Int) {
        data.setHeader(header, forSection: forSection)
    }

    /*public func setFooter(footer : GenericTableHeaderItem, forSection: Int){
        data.setFooter(footer, forSection: forSection)
    }*/
    
    // MARK: visibility handling
/*
    public func showSection(forSection: Int) {
        setSectionVisibility(forSection: forSection, visible: true)
    }

    public func hideSection(forSection: Int) {
        setSectionVisibility(forSection: forSection, visible: false)
    }

    public func setSectionVisibility(forSection: Int, visible: Bool) {
        let update = data.setSectionVisibility(forSection: forSection, visible: visible)
        applyResultUpdate(update: update)
    }
*/
    // MARK: data and nib registration

    private func applyResultUpdate(update: TableDataSectionUpdate) {
        if let safeDelete = update.deletedSectionAtRawIndex {
            deleteSections(IndexSet(integer: safeDelete), with: deletionAnimation)
            return
        } else if let safeCreate = update.createdSectionAtRawIndex {
            insertSections(IndexSet(integer: safeCreate), with: insertionAnimation)
        } else if update.updatedRows.isNotEmpty() {
            let updatedRows = update.updatedRows
            beginUpdates()
            if updatedRows.removed.isNotEmpty {
                deleteRows(at: updatedRows.removed, with: deletionAnimation)
            }
            if updatedRows.inserted.isNotEmpty {
                insertRows(at: updatedRows.inserted, with: insertionAnimation)
            }
            if updatedRows.updated.isNotEmpty {
                reloadRows(at: updatedRows.updated, with: reloadingAnimation)
            }
            endUpdates()
        } else {
            //Logger.shared.logDebug(message: "did not perform any updates.")
            
        }
    }

    /**
     * Handles removing some items and inserting new once regarding the nib registration.
     */
    private func updateNibs(old: [GenericTableItem]?, new: [GenericTableItem]) {
        old?.forEach(removeNibFromGenericTableItem)
        new.forEach(addNibFromGenericTableItem)
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

public extension SimpleTableView {
    /**
     * removes all animations from this table view (insertion, deletion, reloading)
     */
    func disableAnimations() {
        setAnimations(animation: .none)
    }

    /**
     * applies the given animation to all kinds of animations in the table view.
     */
    func setAnimations(animation: UITableViewRowAnimation) {
        self.insertionAnimation = animation
        self.deletionAnimation = animation
        self.reloadingAnimation = animation
    }
}
