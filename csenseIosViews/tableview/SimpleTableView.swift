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
 * x) the tableview cannot deal with partial / sparse array of sections,
  but we want that, so we will translate the sectionIndex ( 0-> count of section) into the given key, using
  an ordered Dictionary (so the keys will be sorted).
 * y) allow a decentralzed design , such that every type of cell can be used in this table;
    and also that all kinds of manipulations, and animations can be
 */
public class SimpleTableView: UITableView {

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
        hookupDelegates()
    }

    private func hookupDelegates() {
        dataSource = data
        delegate = data
    }


    //MARK: Options for table
    var delegateSelectionAsTab: Bool {
        get {
            return data.delegateSelectionAsTab
        }
        set(value) {
            data.delegateSelectionAsTab = value
        }

    }


    //MARK: public functions

    public func add(item: GenericTableItem, inSection: Int, shouldReload: Bool = false) {
        data.add(item: item, inSection: inSection)
        addNibFromGenericTableItem(item: item)
        shouldReload.ifTrue(reloadData)
    }


    public func add(items: [GenericTableItem], inSection: Int, shouldReload: Bool = false) {
        data.add(items: items, inSection: inSection)
        items.forEach(addNibFromGenericTableItem)
        shouldReload.ifTrue(reloadData)
    }


    public func remove(section: Int, shouldReload: Bool = false) {
        let removed: [GenericTableItem] = data.remove(section: section)
        removed.forEach(removeNibFromGenericTableItem)
        //cleanup the registered nibs.
        shouldReload.ifTrue(reloadData)
    }



    //MARK: data and nib registration

    private let data = TableDataContainer()

    private func removeNibFromGenericTableItem(item: GenericTableItem) {
        let nib = item.getNib()
        let reuseId = item.getReuseIdentifier()
        if containsNibAndReuse(nib: nib, reuseId: reuseId){
            
        }
    }

    private func addNibFromGenericTableItem(item: GenericTableItem) {
        let nib = item.getNib()
        let reuseId = item.getReuseIdentifier()
        if !containsNibAndReuse(nib: nib, reuseId: reuseId) {
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
