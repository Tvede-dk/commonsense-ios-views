//
//  TableDataContainer.swift
//  csenseIosViews
//
//  Created by Kasper T on 04/11/2017.
//  Copyright © 2017 commonsense. All rights reserved.
//

import Foundation
import csenseSwift

/**
 * Point of the class
 *
 * x) the tableview cannot deal with partial / sparse array of sections,
 but we want that, so we will translate the sectionIndex ( 0-> count of section) into the given key, using
 an ordered Dictionary (so the keys will be sorted).
 */
public class TableDataContainer: NSObject,
    UITableViewDelegate,
UITableViewDataSource {
    
    public var delegateSelectionAsTab: Bool = true
    
    public var removeSelectionAfterSelecting = true
    
    
    private var sections: OrderedDictionary<Int, [GenericTableItem]> = OrderedDictionary()
    
    public func add(item: GenericTableItem, inSection: Int) {
        sections.addOrCreate(key: inSection, item: item)
    }
    
    public func add(items: [GenericTableItem], inSection: Int) {
        sections.addOrCreate(key: inSection, items: items)
    }
    
    public func remove(section: Int) -> [GenericTableItem] {
        return sections.removeValue(forKey: section) ?? []
    }
    
    public func remove(atRow: Int, inSection: Int) -> GenericTableItem? {
        var result: GenericTableItem? = nil
        updateSection(inSection: inSection, updateFunction: { content in
            result = content.remove(at: atRow)
        })
        //remove section iff empty
        removeSectionIfEmpty(sectionNumber: inSection)
        
        return result
    }
    
    public func clear() {
        sections.removeAll()
    }
    
    
    
    //MARK: Table view implementations
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSectionByIndex(index: section).count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return renderItem(tableView: tableView, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if delegateSelectionAsTab {
            getSectionRowByIndex(at: indexPath)?.onTappedCalled()
        }
        if removeSelectionAfterSelecting {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getSectionRowByIndex(at: indexPath)?.getCustomHeight() ?? UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return getSectionRowByIndex(at: indexPath)?.getEstimatedHeight() ?? UITableViewAutomaticDimension
    }
    
    //MARK: rendering and indexing
    
    private func getBadTableViewCell() -> UITableViewCell {
        //TODO log this, and or be able to configure this into a crash.
        return UITableViewCell()
    }
    
    private func updateSection(inSection: Int, updateFunction: MutatingFunction<[GenericTableItem]>) {
        var input = sections[inSection] ?? []
        updateFunction(&input)
        sections.updateValue(input, forKey: inSection)
    }
    
    private func getSectionRowByIndex(at: IndexPath) -> GenericTableItem? {
        return sections.ElementByIndex(index: at.section)?[at.row]
    }
    
    private func getSectionByIndex(index: Int) -> [GenericTableItem] {
        return sections.ElementByIndex(index: index) ?? []
    }
    
    
    
    private func renderItem(tableView: UITableView, at: IndexPath) -> UITableViewCell {
        let optItem = getSectionRowByIndex(at: at)
        guard let safeItem = optItem else {
            return getBadTableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: safeItem.getReuseIdentifier(),
                                                 for: at)
        safeItem.renderFor(cell: cell)
        let updater : EmptyFunction = { [weak tableView]in
            tableView?.reloadRows(at: [at], with: .automatic)
        }
        safeItem.setUpdateFunction(callback: updater)
        return cell
    }
    //MARK: cleanup and mangement.
    private func removeSectionIfEmpty(sectionNumber : Int){
        if (sections[sectionNumber]?.isEmpty == true){
            _ = remove(section: sectionNumber)
        }
    }
    
}

