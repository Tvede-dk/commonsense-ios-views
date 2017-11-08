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

    //MARK: Init

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


    //MARK: Options for table
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


    //MARK: public functions

    public func add(item: GenericTableItem, forSection: Int, shouldReload: Bool = false) {
        data.add(item: item, forSection: forSection)
        addNibFromGenericTableItem(item: item)
        shouldReload.ifTrue(reloadData)
    }


    public func add(items: [GenericTableItem], forSection: Int, shouldReload: Bool = false) {
        if(items.count==0){
            return
        }
        data.add(items: items, forSection: forSection)
        items.forEach(addNibFromGenericTableItem)
        shouldReload.ifTrue(reloadData)
    }


    public func remove(section: Int, shouldReload: Bool = false) {
        let removed: [GenericTableItem] = data.remove(section: section)
        removed.forEach(removeNibFromGenericTableItem)
        //cleanup the registered nibs.
        shouldReload.ifTrue(reloadData)
    }

    public func clear() {
        data.clear()
        registeredIdentifiers.removeAll()
        reloadData()
    }
    
    public func set(item: GenericTableItem, forSection: Int, shouldReload: Bool = false) {
        remove(section: forSection)
        add(item: item, forSection: forSection, shouldReload : shouldReload)
    }

    
    public func setHeader(header : GenericTableHeaderItem, forSection : Int){
        data.setHeader(header, forSection: forSection)
    }
    
    
    //MARK: data and nib registration

    private let data = TableDataContainer()

    private func removeNibFromGenericTableItem(item: GenericTableItem) {
        let nib = item.getNib()
        let reuseId = item.getReuseIdentifier()
        //TODO use ref counting to make sure we only deregister cells that are no longer presented.
        if containsNibAndReuse(nib: nib, reuseId: reuseId) {

            //register(nil, forCellReuseIdentifier: reuseId)
        }
    }

    private func addNibFromGenericTableItem(item: GenericTableItem) {
        let nib = item.getNib()
        let reuseId = item.getReuseIdentifier()
        if !containsNibAndReuse(nib: nib, reuseId: reuseId) {
            //TODO use ref counting to inc the counter for every type each time its added.
            addNibAndReuseId(nib: nib, reuseId: reuseId)
            register(nib, forCellReuseIdentifier: reuseId)
        }
    }

    private var registeredIdentifiers: Set<String> = Set()


    private func containsNibAndReuse(nib: UINib, reuseId: String) -> Bool {
        return registeredIdentifiers.contains(reuseId)
    }

    private func addNibAndReuseId(nib: UINib, reuseId: String) {
        registeredIdentifiers.update(with: reuseId)
    }

    private func removeNibAndReuseId(nib: UINib, reuseId: String) {
        registeredIdentifiers.remove(reuseId)
    }


}
